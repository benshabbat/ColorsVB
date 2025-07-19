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
            border-radius: 15px;
            border: 2px solid #e9ecef;
            padding: 15px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            font-size: 16px;
            background-color: #fff;
        }
        
        .custom-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%23667eea' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: left 15px center;
            background-repeat: no-repeat;
            background-size: 16px 12px;
            padding-left: 45px;
        }
        
        .custom-select option {
            padding: 10px;
            font-size: 16px;
            background-color: #fff;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.15), 0 4px 20px rgba(102, 126, 234, 0.2);
            transform: translateY(-2px);
        }
        
        .input-group {
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border-radius: 15px;
            overflow: hidden;
            position: relative;
        }
        
        .input-group .form-select {
            border-radius: 0 15px 15px 0 !important;
            border-left: none;
        }
        
        .input-group .form-control {
            border-radius: 0 15px 15px 0 !important;
            border-left: none;
        }
        
        .input-group-text {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px 20px;
            font-weight: 600;
            border-radius: 15px 0 0 15px !important;
        }
        
        .form-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 10px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .form-label i {
            color: #667eea;
        }
        
        .btn {
            border-radius: 15px;
            padding: 15px 30px;
            font-weight: 700;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }
        
        .btn:hover::before {
            left: 100%;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            position: relative;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
        }
        
        .btn-secondary:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.4);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
        }
        
        .btn-success:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            border: none;
            color: #212529;
        }
        
        .btn-warning:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.4);
            color: #212529;
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border: none;
        }
        
        .btn-danger:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 8px 25px rgba(220, 53, 69, 0.4);
        }
        
        .pulse-btn {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3); }
            50% { box-shadow: 0 4px 25px rgba(102, 126, 234, 0.6); }
            100% { box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3); }
        }
        
        .cancel-btn:hover {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
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
            border-radius: 10px;
        }
        
        .table tbody tr:hover {
            background: linear-gradient(135deg, #f8f9ff 0%, #e3f2fd 100%);
            transform: scale(1.02);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .table-row-animated {
            animation: slideInFromLeft 0.5s ease forwards;
        }
        
        @keyframes slideInFromLeft {
            0% {
                opacity: 0;
                transform: translateX(-50px);
            }
            100% {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        .color-display {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .color-circle {
            width: 25px;
            height: 25px;
            border-radius: 50%;
            border: 3px solid #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            flex-shrink: 0;
        }
        
        .color-name-cell {
            font-weight: 600;
            color: #2d3748;
        }
        
        .order-badge .badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
            border-radius: 20px;
            padding: 8px 12px;
            font-size: 12px;
            font-weight: 700;
        }
        
        .drag-handle:hover .drag-icon {
            color: #667eea !important;
            transform: scale(1.2);
        }
        
        .drag-icon {
            transition: all 0.3s ease;
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
            position: relative;
        }
        
        .loading::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        .loading::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 40px;
            height: 40px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            z-index: 1001;
            transform: translate(-50%, -50%);
        }
        
        @keyframes spin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
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
        
        .edit-btn {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            border: none;
            color: white;
            font-size: 12px;
            padding: 8px 15px;
        }
        
        .edit-btn:hover {
            background: linear-gradient(135deg, #e67e22 0%, #d35400 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(243, 156, 18, 0.4);
        }
        
        .delete-btn {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            border: none;
            color: white;
            font-size: 12px;
            padding: 8px 15px;
        }
        
        .delete-btn:hover {
            background: linear-gradient(135deg, #c0392b 0%, #a93226 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
        }
        
        .btn-sm {
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
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
            border-radius: 15px;
            border: none;
            padding: 20px;
            font-weight: 600;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .alert::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: currentColor;
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border-left: 5px solid #28a745;
        }
        
        .alert-warning {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            color: #856404;
            border-left: 5px solid #ffc107;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border-left: 5px solid #dc3545;
        }
        
        .loading-spinner {
            padding: 40px;
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
        }
        
        .spinner-container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .custom-spinner {
            width: 60px;
            height: 60px;
            border-width: 5px;
            border-color: transparent;
            border-top-color: #667eea;
            border-right-color: #764ba2;
            animation: rainbow-spin 1.5s linear infinite;
        }
        
        @keyframes rainbow-spin {
            0% {
                transform: rotate(0deg);
                border-top-color: #667eea;
                border-right-color: #764ba2;
            }
            25% {
                border-top-color: #f093fb;
                border-right-color: #f5576c;
            }
            50% {
                border-top-color: #4facfe;
                border-right-color: #00f2fe;
            }
            75% {
                border-top-color: #43e97b;
                border-right-color: #38f9d7;
            }
            100% {
                transform: rotate(360deg);
                border-top-color: #667eea;
                border-right-color: #764ba2;
            }
        }
        
        .loading-text {
            color: #667eea;
            font-weight: 600;
            font-size: 16px;
            margin: 0;
        }
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
                            <label for="txtColorName" class="form-label">
                                <i class="fas fa-palette me-2"></i>שם הצבע
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-tag"></i>
                                </span>
                                <input type="text" id="txtColorName" class="form-control" placeholder="הזן שם צבע" maxlength="100" />
                            </div>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label for="txtPrice" class="form-label">
                                <i class="fas fa-shekel-sign me-2"></i>מחיר (₪)
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">₪</span>
                                <input type="number" id="txtPrice" class="form-control" step="0.01" min="0" placeholder="0.00" />
                            </div>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label for="txtDisplayOrder" class="form-label">
                                <i class="fas fa-sort-numeric-down me-2"></i>סדר הצגה
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-hashtag"></i>
                                </span>
                                <input type="number" id="txtDisplayOrder" class="form-control" min="1" placeholder="1" />
                            </div>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label for="ddlInStock" class="form-label">
                                <i class="fas fa-boxes me-2"></i>במלאי
                            </label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-clipboard-check"></i>
                                </span>
                                <select id="ddlInStock" class="form-select custom-select">
                                    <option value="true">✓ כן</option>
                                    <option value="false">✗ לא</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3 d-flex align-items-end">
                            <button type="button" id="btnSave" class="btn btn-primary me-2 pulse-btn">
                                <i class="fas fa-save me-2"></i>שמור
                            </button>
                            <button type="button" id="btnCancel" class="btn btn-secondary cancel-btn">
                                <i class="fas fa-times me-2"></i>בטל
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
            <div id="loadingIndicator" class="text-center loading-spinner" style="display: none;">
                <div class="spinner-container">
                    <div class="spinner-border text-primary custom-spinner" role="status">
                        <span class="visually-hidden">טוען...</span>
                    </div>
                    <p class="mt-3 loading-text">
                        <i class="fas fa-magic me-2"></i>טוען נתונים...
                    </p>
                </div>
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
        $(document).ready(function () {
            let currentColorId = 0;
            let deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));

            // Load colors on page load
            loadColors();

            // Make table sortable
            makeSortable();

            // Save button click
            $('#btnSave').click(function () {
                saveColor();
            });

            // Cancel button click
            $('#btnCancel').click(function () {
                clearForm();
            });

            // Confirm delete button click
            $('#confirmDelete').click(function () {
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
                    success: function (response) {
                        showLoading(false);
                        if (response.d.Success) {
                            displayColors(response.d.Data);
                            makeSortable();
                        } else {
                            showAlert('error', 'שגיאה: ' + response.d.Message);
                        }
                    },
                    error: function (xhr, status, error) {
                        showLoading(false);
                        showAlert('error', 'שגיאה בטעינת הנתונים: ' + error);
                    }
                });
            }

            // Function to display colors in table
            function displayColors(colors) {
                let html = '';

                colors.forEach(function (color) {
                    let stockStatus = color.InStock ?
                        '<span class="in-stock"><i class="fas fa-check-circle me-1"></i>כן</span>' :
                        '<span class="out-of-stock"><i class="fas fa-times-circle me-1"></i>לא</span>';

                    html += `
                        <tr class="sortable-row table-row-animated" data-color-id="${color.ColorID}">
                            <td class="text-center drag-handle">
                                <i class="fas fa-grip-vertical text-muted drag-icon" style="cursor: move;"></i>
                            </td>
                            <td class="color-name-cell">
                                <div class="color-display">
                                    <div class="color-circle" style="background: ${getColorHex(color.ColorName)};"></div>
                                    <strong>${color.ColorName}</strong>
                                </div>
                            </td>
                            <td class="price-cell">₪${parseFloat(color.Price).toFixed(2)}</td>
                            <td class="text-center order-badge">
                                <span class="badge bg-primary">${color.DisplayOrder}</span>
                            </td>
                            <td class="text-center">${stockStatus}</td>
                            <td class="action-buttons">
                                <button type="button" class="btn btn-warning btn-sm me-1 edit-btn" onclick="editColor(${color.ColorID}, '${color.ColorName}', ${color.Price}, ${color.DisplayOrder}, ${color.InStock})">
                                    <i class="fas fa-edit me-1"></i> ערוך
                                </button>
                                <button type="button" class="btn btn-danger btn-sm delete-btn" onclick="confirmDeleteColor(${color.ColorID}, '${color.ColorName}')">
                                    <i class="fas fa-trash me-1"></i> מחק
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
                    success: function (response) {
                        showLoading(false);
                        if (response.d.Success) {
                            showAlert('success', currentColorId > 0 ? 'הצבע עודכן בהצלחה!' : 'הצבע נוסף בהצלחה!');
                            clearForm();
                            loadColors();
                        } else {
                            showAlert('error', 'שגיאה: ' + response.d.Message);
                        }
                    },
                    error: function (xhr, status, error) {
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
                    success: function (response) {
                        showLoading(false);
                        if (response.d.Success) {
                            showAlert('success', 'הצבע נמחק בהצלחה!');
                            loadColors();
                        } else {
                            showAlert('error', 'שגיאה: ' + response.d.Message);
                        }
                    },
                    error: function (xhr, status, error) {
                        showLoading(false);
                        showAlert('error', 'שגיאה במחיקת הנתונים: ' + error);
                    }
                });
            }

            // Function to update display order after drag & drop
            function updateDisplayOrder() {
                let orderData = [];
                $('#colorsTableBody tr').each(function (index) {
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
                    success: function (response) {
                        if (response.d.Success) {
                            showAlert('success', 'סדר ההצגה עודכן בהצלחה!');
                            loadColors();
                        } else {
                            showAlert('error', 'שגיאה: ' + response.d.Message);
                        }
                    },
                    error: function (xhr, status, error) {
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
                    update: function (event, ui) {
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
                setTimeout(function () {
                    $('.alert').alert('close');
                }, 5000);
            }

            // פונקציה לקבלת צבע hex לפי שם
            function getColorHex(colorName) {
                const colorMap = {
                    'אדום': '#e74c3c',
                    'כחול': '#3498db',
                    'ירוק': '#27ae60',
                    'צהוב': '#f1c40f',
                    'סגול': '#9b59b6',
                    'כתום': '#e67e22',
                    'ורוד': '#e91e63',
                    'חום': '#8d6e63',
                    'שחור': '#2c3e50',
                    'לבן': '#ecf0f1',
                    'אפור': '#95a5a6',
                    'תכלת': '#1abc9c'
                };

                return colorMap[colorName] || '#667eea';
            }

            // Global functions for button clicks
            window.editColor = function (id, name, price, order, inStock) {
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

            window.confirmDeleteColor = function (id, name) {
                currentColorId = id;
                $('#deleteColorName').text(name);
                deleteModal.show();
            };
        });
    </script>
</body>
</html>