<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ColorsManager.aspx.vb" Inherits="ColorsManager" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="rtl" lang="he">
<head runat="server">
    <meta charset="utf-8" />
    <title>ניהול צבעים - 2all</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <!-- Bootstrap CSS for styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://code.jquery.com/ui/1.13.2/themes/ui-lightness/jquery-ui.css" rel="stylesheet" />
    
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            direction: rtl;
        }
        
        .main-container {
            margin: 20px auto;
            max-width: 1200px;
        }
        
        .header-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: none;
            margin-bottom: 20px;
        }
        
        .card-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
            border: none;
            padding: 20px;
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn {
            border-radius: 10px;
            padding: 12px 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border: none;
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            border: none;
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            border: none;
        }
        
        .table {
            border-radius: 10px;
            overflow: hidden;
            background: white;
        }
        
        .table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .table tbody tr {
            transition: all 0.3s ease;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9ff;
            transform: scale(1.02);
        }
        
        .sortable-row {
            cursor: move;
        }
        
        .ui-sortable-helper {
            background-color: #fff3cd !important;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }
        
        .in-stock {
            color: #28a745;
            font-weight: bold;
        }
        
        .out-of-stock {
            color: #dc3545;
            font-weight: bold;
        }
        
        .price-cell {
            font-family: 'Courier New', monospace;
            font-weight: bold;
            color: #2d3748;
        }
        
        .action-buttons {
            white-space: nowrap;
        }
        
        .modal-content {
            border-radius: 15px;
            border: none;
        }
        
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            border: none;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
        }
        
        @media (max-width: 768px) {
            .main-container {
                margin: 10px;
            }
            
            .header-section {
                padding: 20px;
            }
            
            .table-responsive {
                font-size: 14px;
            }
            
            .btn {
                padding: 8px 15px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Header Section -->
            <div class="header-section text-center">
                <h1><i class="fas fa-palette me-3"></i>מערכת ניהול צבעים</h1>
                <p class="mb-0">ניהול מקיף של מלאי הצבעים שלך</p>
            </div>

            <!-- Add/Edit Color Form -->
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0"><i class="fas fa-plus-circle me-2"></i>הוספת/עריכת צבע</h3>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label for="txtColorName" class="form-label">שם הצבע</label>
                            <input type="text" id="txtColorName" class="form-control" placeholder="הזן שם צבע" />
                        </div>
                        <div class="col-md-2 mb-3">
                            <label for="txtPrice" class="form-label">מחיר (₪)</label>
                            <input type="number" id="txtPrice" class="form-control" step="0.01" placeholder="0.00" />
                        </div>
                        <div class="col-md-2 mb-3">
                            <label for="txtDisplayOrder" class="form-label">סדר הצגה</label>
                            <input type="number" id="txtDisplayOrder" class="form-control" placeholder="1" />
                        </div>
                        <div class="col-md-2 mb-3">
                            <label for="ddlInStock" class="form-label">במלאי</label>
                            <select id="ddlInStock" class="form-select">
                                <option value="true">כן</option>
                                <option value="false">לא</option>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3 d-flex align-items-end">
                            <button type="button" id="btnSave" class="btn btn-primary me-2">
                                <i class="fas fa-save me-1"></i>שמור
                            </button>
                            <button type="button" id="btnCancel" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>בטל
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Colors Table -->
            <div class="card">
                <div class="card-header">
                    <h3 class="mb-0"><i class="fas fa-list me-2"></i>רשימת צבעים</h3>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>גרור</th>
                                    <th>שם הצבע</th>
                                    <th>מחיר</th>
                                    <th>סדר הצגה</th>
                                    <th>במלאי</th>
                                    <th>פעולות</th>
                                </tr>
                            </thead>
                            <tbody id="colorsTableBody">
                                <!-- Data will be loaded here via AJAX -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Loading indicator -->
            <div id="loadingIndicator" class="text-center" style="display: none;">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">טוען...</span>
                </div>
                <p class="mt-2">טוען נתונים...</p>
            </div>

            <!-- Success/Error Messages -->
            <div id="alertContainer"></div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">אישור מחיקה</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>האם אתה בטוח שברצונך למחוק את הצבע "<span id="deleteColorName"></span>"?</p>
                        <p class="text-danger"><strong>פעולה זו לא ניתנת לביטול!</strong></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">בטל</button>
                        <button type="button" id="confirmDelete" class="btn btn-danger">מחק</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        $(document).ready(function() {
            let currentColorId = 0;
            let deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            
            // Load colors on page load
            loadColors();
            
            // Make table sortable
            makeSortable();
            
            // Save button click
            $('#btnSave').click(function() {
                saveColor();
            });
            
            // Cancel button click
            $('#btnCancel').click(function() {
                clearForm();
            });
            
            // Confirm delete button click
            $('#confirmDelete').click(function() {
                deleteColor(currentColorId);
                deleteModal.hide();
            });
            
            // Function to load all colors
            function loadColors() {
                showLoading(true);
                
                $.ajax({
                    type: "POST",
                    url: "ColorsManager.aspx/GetColors",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        showLoading(false);
                        if (response.d.Success) {
                            displayColors(response.d.Data);
                            makeSortable();
                        } else {
                            showAlert('error', 'שגיאה: ' + response.d.Message);
                        }
                    },
                    error: function(xhr, status, error) {
                        showLoading(false);
                        showAlert('error', 'שגיאה בטעינת הנתונים: ' + error);
                    }
                });
            }
            
            // Function to display colors in table
            function displayColors(colors) {
                let html = '';
                
                colors.forEach(function(color) {
                    let stockStatus = color.InStock ? 
                        '<span class="in-stock"><i class="fas fa-check-circle me-1"></i>כן</span>' :
                        '<span class="out-of-stock"><i class="fas fa-times-circle me-1"></i>לא</span>';
                    
                    html += `
                        <tr class="sortable-row" data-color-id="${color.ColorID}">
                            <td class="text-center">
                                <i class="fas fa-grip-vertical text-muted" style="cursor: move;"></i>
                            </td>
                            <td><strong>${color.ColorName}</strong></td>
                            <td class="price-cell">₪${parseFloat(color.Price).toFixed(2)}</td>
                            <td class="text-center">${color.DisplayOrder}</td>
                            <td class="text-center">${stockStatus}</td>
                            <td class="action-buttons">
                                <button type="button" class="btn btn-warning btn-sm me-1" onclick="editColor(${color.ColorID}, '${color.ColorName}', ${color.Price}, ${color.DisplayOrder}, ${color.InStock})">
                                    <i class="fas fa-edit"></i> ערוך
                                </button>
                                <button type="button" class="btn btn-danger btn-sm" onclick="confirmDeleteColor(${color.ColorID}, '${color.ColorName}')">
                                    <i class="fas fa-trash"></i> מחק
                                </button>
                            </td>
                        </tr>
                    `;
                });
                
                $('#colorsTableBody').html(html);
            }
            
            // Function to save color (add or update)
            function saveColor() {
                let colorData = {
                    ColorID: currentColorId,
                    ColorName: $('#txtColorName').val().trim(),
                    Price: parseFloat($('#txtPrice').val()) || 0,
                    DisplayOrder: parseInt($('#txtDisplayOrder').val()) || 0,
                    InStock: $('#ddlInStock').val() === 'true'
                };
                
                // Validation
                if (!colorData.ColorName) {
                    showAlert('warning', 'אנא הזן שם צבע');
                    $('#txtColorName').focus();
                    return;
                }
                
                if (colorData.Price <= 0) {
                    showAlert('warning', 'אנא הזן מחיר תקין');
                    $('#txtPrice').focus();
                    return;
                }
                
                showLoading(true);
                
                $.ajax({
                    type: "POST",
                    url: "ColorsManager.aspx/SaveColor",
                    data: JSON.stringify({ color: colorData }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        showLoading(false);
                        if (response.d.Success) {
                            showAlert('success', currentColorId > 0 ? 'הצבע עודכן בהצלחה!' : 'הצבע נוסף בהצלחה!');
                            clearForm();
                            loadColors();
                        } else {
                            showAlert('error', 'שגיאה: ' + response.d.Message);
                        }
                    },
                    error: function(xhr, status, error) {
                        showLoading(false);
                        showAlert('error', 'שגיאה בשמירת הנתונים: ' + error);
                    }
                });
            }
            
            // Function to delete color
            function deleteColor(colorId) {
                showLoading(true);
                
                $.ajax({
                    type: "POST",
                    url: "ColorsManager.aspx/DeleteColor",
                    data: JSON.stringify({ colorId: colorId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        showLoading(false);
                        if (response.d.Success) {
                            showAlert('success', 'הצבע נמחק בהצלחה!');
                            loadColors();
                        } else {
                            showAlert('error', 'שגיאה: ' + response.d.Message);
                        }
                    },
                    error: function(xhr, status, error) {
                        showLoading(false);
                        showAlert('error', 'שגיאה במחיקת הנתונים: ' + error);
                    }
                });
            }
            
            // Function to update display order after drag & drop
            function updateDisplayOrder() {
                let orderData = [];
                $('#colorsTableBody tr').each(function(index) {
                    let colorId = $(this).data('color-id');
                    orderData.push({
                        ColorID: colorId,
                        DisplayOrder: index + 1
                    });
                });
                
                $.ajax({
                    type: "POST",
                    url: "ColorsManager.aspx/UpdateDisplayOrder",
                    data: JSON.stringify({ orders: orderData }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        if (response.d.Success) {
                            showAlert('success', 'סדר ההצגה עודכן בהצלחה!');
                            loadColors();
                        } else {
                            showAlert('error', 'שגיאה: ' + response.d.Message);
                        }
                    },
                    error: function(xhr, status, error) {
                        showAlert('error', 'שגיאה בעדכון הסדר: ' + error);
                    }
                });
            }
            
            // Make table sortable
            function makeSortable() {
                $('#colorsTableBody').sortable({
                    items: 'tr.sortable-row',
                    handle: '.fa-grip-vertical',
                    placeholder: 'ui-state-highlight',
                    helper: 'clone',
                    update: function(event, ui) {
                        updateDisplayOrder();
                    }
                });
            }
            
            // Clear form
            function clearForm() {
                currentColorId = 0;
                $('#txtColorName').val('');
                $('#txtPrice').val('');
                $('#txtDisplayOrder').val('');
                $('#ddlInStock').val('true');
                $('.card-header h3').html('<i class="fas fa-plus-circle me-2"></i>הוספת צבע חדש');
            }
            
            // Show loading indicator
            function showLoading(show) {
                if (show) {
                    $('#loadingIndicator').show();
                    $('form').addClass('loading');
                } else {
                    $('#loadingIndicator').hide();
                    $('form').removeClass('loading');
                }
            }
            
            // Show alert message
            function showAlert(type, message) {
                let alertClass = type === 'success' ? 'alert-success' : 
                               type === 'warning' ? 'alert-warning' : 'alert-danger';
                let icon = type === 'success' ? 'check-circle' : 
                          type === 'warning' ? 'exclamation-triangle' : 'times-circle';
                
                let html = `
                    <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
                        <i class="fas fa-${icon} me-2"></i>
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                `;
                
                $('#alertContainer').html(html);
                
                // Auto hide after 5 seconds
                setTimeout(function() {
                    $('.alert').alert('close');
                }, 5000);
            }
            
            // Global functions for button clicks
            window.editColor = function(id, name, price, order, inStock) {
                currentColorId = id;
                $('#txtColorName').val(name);
                $('#txtPrice').val(price);
                $('#txtDisplayOrder').val(order);
                $('#ddlInStock').val(inStock.toString().toLowerCase());
                $('.card-header h3').html('<i class="fas fa-edit me-2"></i>עריכת צבע: ' + name);
                
                // Scroll to form
                $('html, body').animate({
                    scrollTop: $('.card').offset().top - 20
                }, 500);
            };
            
            window.confirmDeleteColor = function(id, name) {
                currentColorId = id;
                $('#deleteColorName').text(name);
                deleteModal.show();
            };
        });
    </script>
</body>
</html>