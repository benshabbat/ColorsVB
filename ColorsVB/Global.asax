<%@ Application Language="VB" %>

<script runat="server">
    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' האפליקציה התחילה
        System.Diagnostics.Debug.WriteLine("Colors Management Application started")
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' טיפול בשגיאות גלובליות
        Dim exception As Exception = Server.GetLastError()
        If exception IsNot Nothing Then
            System.Diagnostics.Debug.WriteLine("Application Error: " & exception.Message)
        End If
        Server.ClearError()
    End Sub
</script>