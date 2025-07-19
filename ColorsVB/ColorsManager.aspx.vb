Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Services
Imports System.Web.Script.Services

Partial Class ColorsManager
    Inherits System.Web.UI.Page

#Region "Classes"
    ''' <summary>
    ''' מחלקה לייצוג צבע
    ''' </summary>
    Public Class ColorItem
        Public Property ColorID As Integer
        Public Property ColorName As String
        Public Property Price As Decimal
        Public Property DisplayOrder As Integer
        Public Property InStock As Boolean
        Public Property CreatedDate As DateTime
    End Class

    ''' <summary>
    ''' מחלקה לייצוג תגובת השרת
    ''' </summary>
    Public Class ServerResponse
        Public Property Success As Boolean
        Public Property Message As String
        Public Property Data As Object
    End Class

    ''' <summary>
    ''' מחלקה לייצוג סדר הצגה
    ''' </summary>
    Public Class DisplayOrderItem
        Public Property ColorID As Integer
        Public Property DisplayOrder As Integer
    End Class
#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' הכל נעשה דרך AJAX - אין צורך בקוד כאן
    End Sub
#End Region

#Region "Private Methods"
    ''' <summary>
    ''' קבלת מחרוזת החיבור מקובץ התצורה
    ''' </summary>
    Private Shared Function GetConnectionString() As String
        Return ConfigurationManager.ConnectionStrings("DefaultConnection").ConnectionString
    End Function

    ''' <summary>
    ''' וידוא שבסיס הנתונים והטבלה קיימים
    ''' </summary>
    Private Shared Sub EnsureDatabaseAndTableExist()
        Try
            CreateDatabaseIfNotExists()
            CreateTableIfNotExists()
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error in EnsureDatabaseAndTableExist: " & ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' יצירת בסיס הנתונים אם לא קיים
    ''' </summary>
    Private Shared Sub CreateDatabaseIfNotExists()
        Dim masterConnectionString As String = "Data Source=Benshabbat\SQLEXPRESS;Initial Catalog=master;Integrated Security=True"

        Using masterConn As New SqlConnection(masterConnectionString)
            masterConn.Open()

            Dim checkDbSql As String = "SELECT COUNT(*) FROM sys.databases WHERE name = 'ColorsDB'"
            Using checkDbCmd As New SqlCommand(checkDbSql, masterConn)
                Dim dbExists As Integer = Convert.ToInt32(checkDbCmd.ExecuteScalar())

                If dbExists = 0 Then
                    Dim createDbSql As String = "CREATE DATABASE ColorsDB"
                    Using createDbCmd As New SqlCommand(createDbSql, masterConn)
                        createDbCmd.ExecuteNonQuery()
                    End Using
                    System.Diagnostics.Debug.WriteLine("ColorsDB database created successfully")
                End If
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' יצירת הטבלה והנתונים אם לא קיימים
    ''' </summary>
    Private Shared Sub CreateTableIfNotExists()
        Using conn As New SqlConnection(GetConnectionString())
            conn.Open()

            Dim checkTableSql As String = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ColorsManagement'"
            Using cmd As New SqlCommand(checkTableSql, conn)
                Dim tableExists As Integer = Convert.ToInt32(cmd.ExecuteScalar())

                If tableExists = 0 Then
                    CreateTable(conn)
                    CreateIndex(conn)
                    InsertSampleData(conn)
                    System.Diagnostics.Debug.WriteLine("ColorsManagement table created with sample data")
                Else
                    EnsureSampleDataExists(conn)
                End If
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' יצירת הטבלה
    ''' </summary>
    Private Shared Sub CreateTable(conn As SqlConnection)
        Dim createTableSql As String = "CREATE TABLE ColorsManagement (" &
                                      "ColorID INT IDENTITY(1,1) PRIMARY KEY, " &
                                      "ColorName NVARCHAR(100) NOT NULL, " &
                                      "Price DECIMAL(10,2) NOT NULL, " &
                                      "DisplayOrder INT NOT NULL DEFAULT 0, " &
                                      "InStock BIT NOT NULL DEFAULT 1, " &
                                      "CreatedDate DATETIME DEFAULT GETDATE())"

        Using createCmd As New SqlCommand(createTableSql, conn)
            createCmd.ExecuteNonQuery()
        End Using
    End Sub

    ''' <summary>
    ''' יצירת אינדקס על סדר הצגה
    ''' </summary>
    Private Shared Sub CreateIndex(conn As SqlConnection)
        Dim indexSql As String = "CREATE INDEX IX_ColorsManagement_DisplayOrder ON ColorsManagement(DisplayOrder)"
        Using indexCmd As New SqlCommand(indexSql, conn)
            indexCmd.ExecuteNonQuery()
        End Using
    End Sub

    ''' <summary>
    ''' הוספת נתוני דוגמה
    ''' </summary>
    Private Shared Sub InsertSampleData(conn As SqlConnection)
        Dim insertSql As String = "INSERT INTO ColorsManagement (ColorName, Price, DisplayOrder, InStock) VALUES " &
                                 "(N'אדום', 25.50, 1, 1), " &
                                 "(N'כחול', 30.00, 2, 1), " &
                                 "(N'ירוק', 22.75, 3, 0), " &
                                 "(N'צהוב', 28.25, 4, 1), " &
                                 "(N'סגול', 35.00, 5, 1)"

        Using insertCmd As New SqlCommand(insertSql, conn)
            insertCmd.ExecuteNonQuery()
        End Using
    End Sub

    ''' <summary>
    ''' וידוא שיש נתוני דוגמה אם הטבלה ריקה
    ''' </summary>
    Private Shared Sub EnsureSampleDataExists(conn As SqlConnection)
        Dim countSql As String = "SELECT COUNT(*) FROM ColorsManagement"
        Using countCmd As New SqlCommand(countSql, conn)
            Dim recordCount As Integer = Convert.ToInt32(countCmd.ExecuteScalar())

            If recordCount = 0 Then
                InsertSampleData(conn)
                System.Diagnostics.Debug.WriteLine("Sample data added to existing empty table")
            End If
        End Using
    End Sub

    ''' <summary>
    ''' בדיקת קיום צבע לפי שם
    ''' </summary>
    Private Shared Function IsColorNameExists(colorName As String, Optional excludeColorId As Integer = 0) As Boolean
        Using conn As New SqlConnection(GetConnectionString())
            conn.Open()

            Dim sql As String = "SELECT COUNT(*) FROM ColorsManagement WHERE ColorName = @ColorName"
            If excludeColorId > 0 Then
                sql &= " AND ColorID <> @ColorID"
            End If

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ColorName", colorName)
                If excludeColorId > 0 Then
                    cmd.Parameters.AddWithValue("@ColorID", excludeColorId)
                End If

                Return Convert.ToInt32(cmd.ExecuteScalar()) > 0
            End Using
        End Using
    End Function

    ''' <summary>
    ''' קבלת סדר הצגה הבא
    ''' </summary>
    Private Shared Function GetNextDisplayOrder() As Integer
        Using conn As New SqlConnection(GetConnectionString())
            conn.Open()

            Dim sql As String = "SELECT ISNULL(MAX(DisplayOrder), 0) + 1 FROM ColorsManagement"
            Using cmd As New SqlCommand(sql, conn)
                Return Convert.ToInt32(cmd.ExecuteScalar())
            End Using
        End Using
    End Function
#End Region

#Region "Web Methods"
    ''' <summary>
    ''' קבלת כל הצבעים
    ''' </summary>
    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GetColors() As ServerResponse
        Dim response As New ServerResponse()
        Dim colors As New List(Of ColorItem)()

        Try
            EnsureDatabaseAndTableExist()

            Using conn As New SqlConnection(GetConnectionString())
                Dim sql As String = "SELECT ColorID, ColorName, Price, DisplayOrder, InStock, CreatedDate " &
                                   "FROM ColorsManagement ORDER BY DisplayOrder ASC, ColorName ASC"

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
            System.Diagnostics.Debug.WriteLine("Error in GetColors: " & ex.ToString())
        End Try

        Return response
    End Function

    ''' <summary>
    ''' שמירת צבע (הוספה או עדכון)
    ''' </summary>
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

            ' בדיקת קיום שם צבע
            If IsColorNameExists(color.ColorName, color.ColorID) Then
                response.Success = False
                response.Message = "צבע עם שם זה כבר קיים במערכת"
                Return response
            End If

            Using conn As New SqlConnection(GetConnectionString())
                conn.Open()

                If color.ColorID = 0 Then
                    ' הוספת צבע חדש
                    If color.DisplayOrder = 0 Then
                        color.DisplayOrder = GetNextDisplayOrder()
                    End If

                    Dim insertSql As String = "INSERT INTO ColorsManagement (ColorName, Price, DisplayOrder, InStock) " &
                                             "VALUES (@ColorName, @Price, @DisplayOrder, @InStock)"

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
                    Dim updateSql As String = "UPDATE ColorsManagement SET ColorName = @ColorName, Price = @Price, " &
                                             "DisplayOrder = @DisplayOrder, InStock = @InStock WHERE ColorID = @ColorID"

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
            System.Diagnostics.Debug.WriteLine("Error in SaveColor: " & ex.ToString())
        End Try

        Return response
    End Function

    ''' <summary>
    ''' מחיקת צבע
    ''' </summary>
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
            System.Diagnostics.Debug.WriteLine("Error in DeleteColor: " & ex.ToString())
        End Try

        Return response
    End Function

    ''' <summary>
    ''' עדכון סדר הצגה (תרגיל בונוס - גרירה ושחרור)
    ''' </summary>
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

                        transaction.Commit()
                        response.Success = True
                        response.Message = "סדר ההצגה עודכן בהצלחה"

                    Catch ex As Exception
                        transaction.Rollback()
                        Throw ex
                    End Try
                End Using
            End Using

        Catch ex As Exception
            response.Success = False
            response.Message = "שגיאה בעדכון סדר ההצגה: " & ex.Message
            System.Diagnostics.Debug.WriteLine("Error in UpdateDisplayOrder: " & ex.ToString())
        End Try

        Return response
    End Function
#End Region

End Class