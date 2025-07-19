<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ניהול טבלת צבעים</title>
    <meta charset="utf-8" />
    <style>
        body {
            font-family: Arial, sans-serif;
            direction: rtl;
            margin: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .form-section {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: inline-block;
            width: 120px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"], .textbox {
            width: 200px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-edit {
            background-color: #2196F3;
        }
        .btn-edit:hover {
            background-color: #0b7dda;
        }
        .btn-delete {
            background-color: #f44336;
        }
        .btn-delete:hover {
            background-color: #da190b;
        }
        .btn-cancel {
            background-color: #ff9800;
        }
        .btn-cancel:hover {
            background-color: #e68900;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 12px;
            text-align: right;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        .actions {
            text-align: center;
        }
        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .in-stock {
            color: green;
            font-weight: bold;
        }
        .out-of-stock {
            color: red;
            font-weight: bold;
        }
        .hidden {
            display: none !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>ניהול טבלת צבעים</h1>
            
            <asp:Panel ID="messagePanel" runat="server" CssClass="message hidden">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>
            
            <div class="form-section">
                <h2><asp:Label ID="lblFormTitle" runat="server" Text="הוספת צבע חדש"></asp:Label></h2>
                
                <asp:HiddenField ID="hiddenColorId" runat="server" Value="0" />
                
                <div class="form-group">
                    <label for="<%= txtColorName.ClientID %>">שם הצבע:</label>
                    <asp:TextBox ID="txtColorName" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= txtPrice.ClientID %>">מחיר:</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= txtDisplayOrder.ClientID %>">סדר הצגה:</label>
                    <asp:TextBox ID="txtDisplayOrder" runat="server" CssClass="textbox"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="<%= chkInStock.ClientID %>">במלאי:</label>
                    <asp:CheckBox ID="chkInStock" runat="server" Checked="true" />
                </div>
                <div class="form-group">
                    <asp:Button ID="btnSave" runat="server" Text="שמור" CssClass="btn" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="בטל" CssClass="btn btn-cancel hidden" OnClick="btnCancel_Click" />
                    <asp:Button ID="btnClear" runat="server" Text="נקה" CssClass="btn" OnClick="btnClear_Click" />
                </div>
            </div>
            
            <div>
                <h2>רשימת צבעים</h2>
                <asp:Repeater ID="rptColors" runat="server" OnItemCommand="rptColors_ItemCommand">
                    <HeaderTemplate>
                        <table>
                            <thead>
                                <tr>
                                    <th>מספר זיהוי</th>
                                    <th>שם הצבע</th>
                                    <th>מחיר</th>
                                    <th>סדר הצגה</th>
                                    <th>במלאי</th>
                                    <th>פעולות</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("ColorId") %></td>
                            <td><%# Eval("ColorName") %></td>
                            <td><%# String.Format("{0:F2} ש"ח", Eval("Price")) %></td>
                            <td><%# Eval("DisplayOrder") %></td>
                            <td>
                                <span class='<%# If(Convert.ToBoolean(Eval("InStock")), "in-stock", "out-of-stock") %>'>
                                    <%# If(Convert.ToBoolean(Eval("InStock")), "כן", "לא") %>
                                </span>
                            </td>
                            <td class="actions">
                                <asp:Button ID="btnEdit" runat="server" Text="עריכה" 
                                    CssClass="btn btn-edit" CommandName="Edit" 
                                    CommandArgument='<%# Eval("ColorId") %>' />
                                <asp:Button ID="btnDelete" runat="server" Text="מחיקה" 
                                    CssClass="btn btn-delete" CommandName="Delete" 
                                    CommandArgument='<%# Eval("ColorId") %>' 
                                    OnClientClick="return confirm('האם אתה בטוח שברצונך למחוק צבע זה?');" />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </form>
</body>
</html>