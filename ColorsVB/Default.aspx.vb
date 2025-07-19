Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Partial Class _Default
    Inherits System.Web.UI.Page

    ' ������ ������ ����� �������
    Private ReadOnly connectionString As String = "Data Source=Benshabbat\SQLEXPRESS;Initial Catalog=ColorsDB;Integrated Security=True"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadColors()
        End If
    End Sub

    ' ����� ������ ������
    Private Sub LoadColors()
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "SELECT ColorId, ColorName, Price, DisplayOrder, InStock FROM Colors ORDER BY DisplayOrder"

                Using adapter As New SqlDataAdapter(query, connection)
                    Dim dataTable As New DataTable()
                    adapter.Fill(dataTable)
                    rptColors.DataSource = dataTable
                    rptColors.DataBind()
                End Using
            End Using
        Catch ex As Exception
            ShowMessage("����� ������ �������: " & ex.Message, "error")
        End Try
    End Sub

    ' ����� ��� (����� �� �����)
    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            Dim colorName As String = txtColorName.Text.Trim()
            Dim price As Decimal
            Dim displayOrder As Integer
            Dim inStock As Boolean = chkInStock.Checked
            Dim colorId As Integer = Convert.ToInt32(hiddenColorId.Value)

            ' ����� �������
            If String.IsNullOrEmpty(colorName) Then
                ShowMessage("��� ���� �� ���", "error")
                Return
            End If

            If Not Decimal.TryParse(txtPrice.Text, price) OrElse price < 0 Then
                ShowMessage("��� ���� ���� ����", "error")
                Return
            End If

            If Not Integer.TryParse(txtDisplayOrder.Text, displayOrder) OrElse displayOrder < 1 Then
                ShowMessage("��� ���� ��� ���� ����", "error")
                Return
            End If

            Using connection As New SqlConnection(connectionString)
                connection.Open()

                If colorId = 0 Then
                    ' ����� ��� ���
                    Dim checkQuery As String = "SELECT COUNT(*) FROM Colors WHERE ColorName = @ColorName"
                    Using checkCommand As New SqlCommand(checkQuery, connection)
                        checkCommand.Parameters.AddWithValue("@ColorName", colorName)
                        Dim count As Integer = Convert.ToInt32(checkCommand.ExecuteScalar())

                        If count > 0 Then
                            ShowMessage("��� �� �� �� ��� ���� ������", "error")
                            Return
                        End If
                    End Using

                    ' �����
                    Dim insertQuery As String = "INSERT INTO Colors (ColorName, Price, DisplayOrder, InStock) VALUES (@ColorName, @Price, @DisplayOrder, @InStock)"
                    Using command As New SqlCommand(insertQuery, connection)
                        command.Parameters.AddWithValue("@ColorName", colorName)
                        command.Parameters.AddWithValue("@Price", price)
                        command.Parameters.AddWithValue("@DisplayOrder", displayOrder)
                        command.Parameters.AddWithValue("@InStock", inStock)

                        Dim rowsAffected As Integer = command.ExecuteNonQuery()
                        If rowsAffected > 0 Then
                            ShowMessage("���� ���� ������", "success")
                            ClearForm()
                        Else
                            ShowMessage("����� ������ ����", "error")
                        End If
                    End Using
                Else
                    ' ����� ��� ����
                    Dim checkQuery As String = "SELECT COUNT(*) FROM Colors WHERE ColorName = @ColorName AND ColorId <> @ColorId"
                    Using checkCommand As New SqlCommand(checkQuery, connection)
                        checkCommand.Parameters.AddWithValue("@ColorName", colorName)
                        checkCommand.Parameters.AddWithValue("@ColorId", colorId)
                        Dim count As Integer = Convert.ToInt32(checkCommand.ExecuteScalar())

                        If count > 0 Then
                            ShowMessage("��� �� �� �� ��� ���� ������", "error")
                            Return
                        End If
                    End Using

                    ' �����
                    Dim updateQuery As String = "UPDATE Colors SET ColorName = @ColorName, Price = @Price, DisplayOrder = @DisplayOrder, InStock = @InStock WHERE ColorId = @ColorId"
                    Using command As New SqlCommand(updateQuery, connection)
                        command.Parameters.AddWithValue("@ColorId", colorId)
                        command.Parameters.AddWithValue("@ColorName", colorName)
                        command.Parameters.AddWithValue("@Price", price)
                        command.Parameters.AddWithValue("@DisplayOrder", displayOrder)
                        command.Parameters.AddWithValue("@InStock", inStock)

                        Dim rowsAffected As Integer = command.ExecuteNonQuery()
                        If rowsAffected > 0 Then
                            ShowMessage("���� ����� ������", "success")
                            CancelEdit()
                        Else
                            ShowMessage("����� ������ ����", "error")
                        End If
                    End Using
                End If
            End Using

            LoadColors()

        Catch ex As Exception
            ShowMessage("�����: " & ex.Message, "error")
        End Try
    End Sub

    ' ����� �����
    Protected Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        CancelEdit()
    End Sub

    ' ����� �����
    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ClearForm()
    End Sub

    ' ����� ������� ������ (����� ������)
    Protected Sub rptColors_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptColors.ItemCommand
        Dim colorId As Integer = Convert.ToInt32(e.CommandArgument)

        Select Case e.CommandName
            Case "Edit"
                EditColor(colorId)
            Case "Delete"
                DeleteColor(colorId)
        End Select
    End Sub

    ' ����� ���
    Private Sub EditColor(colorId As Integer)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "SELECT ColorName, Price, DisplayOrder, InStock FROM Colors WHERE ColorId = @ColorId"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@ColorId", colorId)

                    Using reader As SqlDataReader = command.ExecuteReader()
                        If reader.Read() Then
                            txtColorName.Text = reader("ColorName").ToString()
                            txtPrice.Text = Convert.ToDecimal(reader("Price")).ToString()
                            txtDisplayOrder.Text = Convert.ToInt32(reader("DisplayOrder")).ToString()
                            chkInStock.Checked = Convert.ToBoolean(reader("InStock"))

                            hiddenColorId.Value = colorId.ToString()
                            lblFormTitle.Text = "����� ���"
                            btnCancel.CssClass = "btn btn-cancel"

                            ShowMessage("����� ���� ����� ������", "success")
                        Else
                            ShowMessage("�� ���� ��� �� ���� ��", "error")
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ShowMessage("����� ������ ������� ������: " & ex.Message, "error")
        End Try
    End Sub

    ' ����� ���
    Private Sub DeleteColor(colorId As Integer)
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim query As String = "DELETE FROM Colors WHERE ColorId = @ColorId"

                Using command As New SqlCommand(query, connection)
                    command.Parameters.AddWithValue("@ColorId", colorId)

                    Dim rowsAffected As Integer = command.ExecuteNonQuery()
                    If rowsAffected > 0 Then
                        ShowMessage("���� ���� ������", "success")
                        LoadColors()
                    Else
                        ShowMessage("����� ������ ����", "error")
                    End If
                End Using
            End Using
        Catch ex As Exception
            ShowMessage("����� ������ ����: " & ex.Message, "error")
        End Try
    End Sub

    ' ����� ��� �����
    Private Sub CancelEdit()
        hiddenColorId.Value = "0"
        lblFormTitle.Text = "����� ��� ���"
        btnCancel.CssClass = "btn btn-cancel hidden"
        ClearForm()
    End Sub

    ' ����� ���� �����
    Private Sub ClearForm()
        txtColorName.Text = ""
        txtPrice.Text = ""
        txtDisplayOrder.Text = ""
        chkInStock.Checked = True
    End Sub

    ' ���� ������
    Private Sub ShowMessage(message As String, type As String)
        lblMessage.Text = message
        messagePanel.CssClass = "message " & type

        Dim script As String = "setTimeout(function() { " &
                              "var panel = document.getElementById('" & messagePanel.ClientID & "'); " &
                              "if(panel) panel.className = 'message hidden'; " &
                              "}, 5000);"
        ClientScript.RegisterStartupScript(Me.GetType(), "HideMessage", script, True)
    End Sub

End Class