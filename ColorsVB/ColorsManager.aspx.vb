Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Services
Imports System.Web.Script.Services

Partial Class ColorsManager
    Inherits System.Web.UI.Page

    ' מחלקה לייצוג צבע
    Public Class ColorItem
        Public Property ColorID As Integer
        Public Property ColorName As String
        Public Property Price As Decimal
        Public Property DisplayOrder As Integer
        Public Property InStock As Boolean
        Public Property CreatedDate As DateTime
    End Class

    ' מחלקה לייצוג תגובת השרת
    Public Class ServerResponse
        Public Property Success As Boolean
        Public Property Message As String
        Public Property Data As Object
    End Class

    ' מחלקה לייצוג סדר הצגה
    Public Class DisplayOrderItem
        Public Property ColorID As Integer
        Public Property DisplayOrder As Integer
    End Class

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' אין צורך בקוד כאן - הכל נעשה דרך AJAX
    End Sub

    ' פונקציה לקבלת מחרוזת החיבור ויצירת טבלה אם לא קיימת
    Private Shared Function GetConnectionString() As String
        Return ConfigurationManager.ConnectionStrings("DefaultConnection").ConnectionString
    End Function

    ' פונקציה לוידוא שבסיס הנתונים והטבלה קיימים
    Private Shared Sub EnsureTableExists()
        Try
            ' קודם בדוק אם בסיס הנתונים קיים, ואם לא - צור אותו
            Dim masterConnectionString As String = "Data Source=Benshabbat\SQLEXPRESS;Initial Catalog=master;Integrated Security=True"

            Using masterConn As New SqlConnection(masterConnectionString)
                masterConn.Open()

                ' בדוק אם בסיס הנתונים קיים
                Dim checkDbSql As String = "SELECT COUNT(*) FROM sys.databases WHERE name = 'ColorsDB'"
                Using checkDbCmd As New SqlCommand(checkDbSql, masterConn)
                    Dim dbExists As Integer = Convert.ToInt32(checkDbCmd.ExecuteScalar())

                    If dbExists = 0 Then
                        ' צור את בסיס הנתונים
                        Dim createDbSql As String = "CREATE DATABASE ColorsDB"
                        Using createDbCmd As New SqlCommand(createDbSql, masterConn)
                            createDbCmd.ExecuteNonQuery()
                        End Using
                        System.Diagnostics.Debug.WriteLine("ColorsDB database created successfully")
                    End If
                End Using
            End Using

            ' עכשיו התחבר לבסיס הנתונים החדש ובדוק/צור את הטבלה
            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()

                ' בדיקה אם הטבלה קיימת
                Dim checkTableSql As String = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ColorsManagement'"
                Using cmd As New SqlCommand(checkTableSql, conn)
                    Dim tableExists As Integer = Convert.ToInt32(cmd.ExecuteScalar())

                    If tableExists = 0 Then
                        ' יצירת הטבלה החדשה
                        Dim createTableSql As String = "CREATE TABLE ColorsManagement (ColorID INT IDENTITY(1,1) PRIMARY KEY, ColorName NVARCHAR(100) NOT NULL, Price DECIMAL(10,2) NOT NULL, DisplayOrder INT NOT NULL DEFAULT 0, InStock BIT NOT NULL DEFAULT 1, CreatedDate DATETIME DEFAULT GETDATE())"

                        Using createCmd As New SqlCommand(createTableSql, conn)
                            createCmd.ExecuteNonQuery()
                        End Using

                        ' יצירת אינדקס
                        Dim indexSql As String = "CREATE INDEX IX_ColorsManagement_DisplayOrder ON ColorsManagement(DisplayOrder)"
                        Using indexCmd As New SqlCommand(indexSql, conn)
                            indexCmd.ExecuteNonQuery()
                        End Using

                        ' הוספת נתוני דוגמה
                        Dim insertSql As String = "INSERT INTO ColorsManagement (ColorName, Price, DisplayOrder, InStock) VALUES " &
                                                 "(N'אדום', 25.50, 1, 1), " &
                                                 "(N'כחול', 30.00, 2, 1), " &
                                                 "(N'ירוק', 22.75, 3, 0), " &
                                                 "(N'צהוב', 28.25, 4, 1), " &
                                                 "(N'סגול', 35.00, 5, 1)"

                        Using insertCmd As New SqlCommand(insertSql, conn)
                            insertCmd.ExecuteNonQuery()
                        End Using

                        System.Diagnostics.Debug.WriteLine("ColorsManagement table created successfully")
                    Else
                        ' הטבלה כבר קיימת - בדוק אם יש בה נתונים
                        Dim countSql As String = "SELECT COUNT(*) FROM ColorsManagement"
                        Using countCmd As New SqlCommand(countSql, conn)
                            Dim recordCount As Integer = Convert.ToInt32(countCmd.ExecuteScalar())

                            If recordCount = 0 Then
                                ' הטבלה קיימת אבל ריקה - הוסף נתוני דוגמה
                                Dim insertSql As String = "INSERT INTO ColorsManagement (ColorName, Price, DisplayOrder, InStock) VALUES " &
                                                         "(N'אדום', 25.50, 1, 1), " &
                                                         "(N'כחול', 30.00, 2, 1), " &
                                                         "(N'ירוק', 22.75, 3, 0), " &
                                                         "(N'צהוב', 28.25, 4, 1), " &
                                                         "(N'סגול', 35.00, 5, 1)"

                                Using insertCmd As New SqlCommand(insertSql, conn)
                                    insertCmd.ExecuteNonQuery()
                                End Using

                                System.Diagnostics.Debug.WriteLine("Sample data added to existing empty table")
                            Else
                                System.Diagnostics.Debug.WriteLine("Table exists with " & recordCount & " records")
                            End If
                        End Using
                    End If
                End Using
            End Using
        Catch ex As Exception
            ' אם יש שגיאה - רק רשום ללוג אבל אל תעצור את האפליקציה
            System.Diagnostics.Debug.WriteLine("Error in EnsureTableExists: " & ex.Message)
            ' לא זורקים שגיאה כאן 
        End Try
    End Sub

    ' WebMethod לקבלת כל הצבעים
    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GetColors() As ServerResponse
        Dim response As New ServerResponse()
        Dim colors As New List(Of ColorItem)()

        Try
            ' וידוא שהטבלה קיימת
            EnsureTableExists()

            Using conn As New SqlConnection(GetConnectionString())
                Dim sql As String = "SELECT ColorID, ColorName, Price, DisplayOrder, InStock, CreatedDate FROM ColorsManagement ORDER BY DisplayOrder ASC, ColorName ASC"

                Using cmd As New SqlCommand(sql, conn)
                    conn.Open()

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            Dim color As New ColorItem() With {
                                .ColorID = Convert.ToInt32(reader("ColorID")),
                                .ColorName = reader("ColorName").ToString(),
                                .Price = Convert.ToDecimal(reader("Price")),
                                .DisplayOrder = Convert.ToInt32(reader("DisplayOrder")),
                                .InStock = Convert.ToBoolean(reader("InStock")),
                                .CreatedDate = Convert.ToDateTime(reader("CreatedDate"))
                            }
                            colors.Add(color)
                        End While
                    End Using
                End Using
            End Using

            response.Success = True
            response.Data = colors
            response.Message = "נתונים נטענו בהצלחה"

        Catch ex As Exception
            response.Success = False
            response.Message = "שגיאה בטעינת הנתונים: " & ex.Message

            ' רישום השגיאה ללוג
            System.Diagnostics.Debug.WriteLine("Error in GetColors: " & ex.ToString())
        End Try

        Return response
    End Function

    ' WebMethod לשמירת צבע (הוספה או עדכון)
    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function SaveColor(color As ColorItem) As ServerResponse
        Dim response As New ServerResponse()

        Try
            ' ולידציה
            If String.IsNullOrWhiteSpace(color.ColorName) Then
                response.Success = False
                response.Message = "שם הצבע חובה"
                Return response
            End If

            If color.Price <= 0 Then
                response.Success = False
                response.Message = "מחיר חייב להיות גדול מ-0"
                Return response
            End If

            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()

                If color.ColorID = 0 Then
                    ' הוספת צבע חדש

                    ' בדיקה אם הצבע כבר קיים
                    Dim checkSql As String = "SELECT COUNT(*) FROM ColorsManagement WHERE ColorName = @ColorName"
                    Using checkCmd As New SqlCommand(checkSql, conn)
                        checkCmd.Parameters.AddWithValue("@ColorName", color.ColorName)
                        Dim count As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())

                        If count > 0 Then
                            response.Success = False
                            response.Message = "צבע עם שם זה כבר קיים במערכת"
                            Return response
                        End If
                    End Using

                    ' קבלת סדר הצגה הבא
                    If color.DisplayOrder = 0 Then
                        Dim orderSql As String = "SELECT ISNULL(MAX(DisplayOrder), 0) + 1 FROM ColorsManagement"
                        Using orderCmd As New SqlCommand(orderSql, conn)
                            color.DisplayOrder = Convert.ToInt32(orderCmd.ExecuteScalar())
                        End Using
                    End If

                    ' הוספה
                    Dim insertSql As String = "INSERT INTO ColorsManagement (ColorName, Price, DisplayOrder, InStock) VALUES (@ColorName, @Price, @DisplayOrder, @InStock)"
                    Using cmd As New SqlCommand(insertSql, conn)
                        cmd.Parameters.AddWithValue("@ColorName", color.ColorName)
                        cmd.Parameters.AddWithValue("@Price", color.Price)
                        cmd.Parameters.AddWithValue("@DisplayOrder", color.DisplayOrder)
                        cmd.Parameters.AddWithValue("@InStock", color.InStock)

                        cmd.ExecuteNonQuery()
                        response.Message = "הצבע נוסף בהצלחה"
                    End Using

                Else
                    ' עדכון צבע קיים

                    ' בדיקה אם הצבע קיים
                    Dim checkSql As String = "SELECT COUNT(*) FROM ColorsManagement WHERE ColorID = @ColorID"
                    Using checkCmd As New SqlCommand(checkSql, conn)
                        checkCmd.Parameters.AddWithValue("@ColorID", color.ColorID)
                        Dim count As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())

                        If count = 0 Then
                            response.Success = False
                            response.Message = "הצבע לא נמצא במערכת"
                            Return response
                        End If
                    End Using

                    ' בדיקה אם שם הצבע כבר קיים אצל צבע אחר
                    Dim nameCheckSql As String = "SELECT COUNT(*) FROM ColorsManagement WHERE ColorName = @ColorName AND ColorID <> @ColorID"
                    Using nameCheckCmd As New SqlCommand(nameCheckSql, conn)
                        nameCheckCmd.Parameters.AddWithValue("@ColorName", color.ColorName)
                        nameCheckCmd.Parameters.AddWithValue("@ColorID", color.ColorID)
                        Dim nameCount As Integer = Convert.ToInt32(nameCheckCmd.ExecuteScalar())

                        If nameCount > 0 Then
                            response.Success = False
                            response.Message = "צבע עם שם זה כבר קיים במערכת"
                            Return response
                        End If
                    End Using

                    ' עדכון
                    Dim updateSql As String = "UPDATE ColorsManagement SET ColorName = @ColorName, Price = @Price, DisplayOrder = @DisplayOrder, InStock = @InStock WHERE ColorID = @ColorID"
                    Using cmd As New SqlCommand(updateSql, conn)
                        cmd.Parameters.AddWithValue("@ColorID", color.ColorID)
                        cmd.Parameters.AddWithValue("@ColorName", color.ColorName)
                        cmd.Parameters.AddWithValue("@Price", color.Price)
                        cmd.Parameters.AddWithValue("@DisplayOrder", color.DisplayOrder)
                        cmd.Parameters.AddWithValue("@InStock", color.InStock)

                        cmd.ExecuteNonQuery()
                        response.Message = "הצבע עודכן בהצלחה"
                    End Using
                End If
            End Using

            response.Success = True

        Catch ex As Exception
            response.Success = False
            response.Message = "שגיאה בשמירת הנתונים: " & ex.Message

            ' רישום השגיאה ללוג
            System.Diagnostics.Debug.WriteLine("Error in SaveColor: " & ex.ToString())
        End Try

        Return response
    End Function

    ' WebMethod למחיקת צבע
    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function DeleteColor(colorId As Integer) As ServerResponse
        Dim response As New ServerResponse()

        Try
            If colorId <= 0 Then
                response.Success = False
                response.Message = "מזהה צבע לא תקין"
                Return response
            End If

            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()

                ' בדיקה אם הצבע קיים
                Dim checkSql As String = "SELECT COUNT(*) FROM ColorsManagement WHERE ColorID = @ColorID"
                Using checkCmd As New SqlCommand(checkSql, conn)
                    checkCmd.Parameters.AddWithValue("@ColorID", colorId)
                    Dim count As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())

                    If count = 0 Then
                        response.Success = False
                        response.Message = "הצבע לא נמצא במערכת"
                        Return response
                    End If
                End Using

                ' מחיקה
                Dim deleteSql As String = "DELETE FROM ColorsManagement WHERE ColorID = @ColorID"
                Using cmd As New SqlCommand(deleteSql, conn)
                    cmd.Parameters.AddWithValue("@ColorID", colorId)

                    Dim rowsAffected As Integer = cmd.ExecuteNonQuery()

                    If rowsAffected > 0 Then
                        response.Success = True
                        response.Message = "הצבע נמחק בהצלחה"
                    Else
                        response.Success = False
                        response.Message = "לא ניתן למחוק את הצבע"
                    End If
                End Using
            End Using

        Catch ex As Exception
            response.Success = False
            response.Message = "שגיאה במחיקת הנתונים: " & ex.Message

            ' רישום השגיאה ללוג
            System.Diagnostics.Debug.WriteLine("Error in DeleteColor: " & ex.ToString())
        End Try

        Return response
    End Function

    ' WebMethod לעדכון סדר הצגה (לתרגיל הבונוס)
    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function UpdateDisplayOrder(orders As List(Of DisplayOrderItem)) As ServerResponse
        Dim response As New ServerResponse()

        Try
            If orders Is Nothing OrElse orders.Count = 0 Then
                response.Success = False
                response.Message = "לא נתקבלו נתוני סדר"
                Return response
            End If

            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()

                ' התחלת טרנזקציה
                Using transaction As SqlTransaction = conn.BeginTransaction()
                    Try
                        For Each orderItem As DisplayOrderItem In orders
                            Dim updateSql As String = "UPDATE ColorsManagement SET DisplayOrder = @DisplayOrder WHERE ColorID = @ColorID"
                            Using cmd As New SqlCommand(updateSql, conn, transaction)
                                cmd.Parameters.AddWithValue("@DisplayOrder", orderItem.DisplayOrder)
                                cmd.Parameters.AddWithValue("@ColorID", orderItem.ColorID)
                                cmd.ExecuteNonQuery()
                            End Using
                        Next

                        ' אישור הטרנזקציה
                        transaction.Commit()

                        response.Success = True
                        response.Message = "סדר ההצגה עודכן בהצלחה"

                    Catch ex As Exception
                        ' ביטול הטרנזקציה במקרה של שגיאה
                        transaction.Rollback()
                        Throw ex
                    End Try
                End Using
            End Using

        Catch ex As Exception
            response.Success = False
            response.Message = "שגיאה בעדכון סדר ההצגה: " & ex.Message

            ' רישום השגיאה ללוג
            System.Diagnostics.Debug.WriteLine("Error in UpdateDisplayOrder: " & ex.ToString())
        End Try

        Return response
    End Function

End Class