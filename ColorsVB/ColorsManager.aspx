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
    
    <!-- Custom CSS -->
    <link href="css/colors-manager.css" rel="stylesheet" />
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
                    <div class="row form-row-aligned">
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
                        <div class="col-md-3 mb-3">
                            <label class="form-label" style="visibility: hidden;">פעולות</label>
                            <div class="form-buttons">
                                <button type="button" id="btnSave" class="btn btn-primary pulse-btn">
                                    <i class="fas fa-save me-2"></i>שמור
                                </button>
                                <button type="button" id="btnCancel" class="btn btn-secondary cancel-btn">
                                    <i class="fas fa-times me-2"></i>בטל
                                </button>
                            </div>
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
                                    <th width="80">גרור</th>
                                    <th>שם הצבע</th>
                                    <th width="120">מחיר</th>
                                    <th width="100">סדר הצגה</th>
                                    <th width="100">במלאי</th>
                                    <th width="180">פעולות</th>
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
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            אישור מחיקה
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="סגור"></button>
                    </div>
                    <div class="modal-body">
                        <div class="text-center mb-3">
                            <i class="fas fa-trash-alt text-danger" style="font-size: 48px;"></i>
                        </div>
                        <p class="text-center">האם אתה בטוח שברצונך למחוק את הצבע</p>
                        <p class="text-center">
                            <strong>"<span id="deleteColorName" class="text-primary"></span>"</strong>?
                        </p>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>אזהרה:</strong> פעולה זו לא ניתנת לביטול!
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>בטל
                        </button>
                        <button type="button" id="confirmDelete" class="btn btn-danger">
                            <i class="fas fa-trash me-2"></i>מחק סופית
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script src="js/colors-manager.js"></script>
    
    <!-- Fallback JavaScript (in case external file fails) -->
    <script>
        // Colors Manager JavaScript Functions - Fixed Version

        // Global variables
        var currentColorId = 0;
        var deleteModal;

        // Initialize when document is ready
        $(document).ready(function () {
            console.log("Colors Manager JS loaded");

            // Initialize Bootstrap modal
            deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));

            // Load colors on page load
            loadColors();

            // Make table sortable
            makeSortable();

            // Save button click
            $('#btnSave').on('click', function () {
                saveColor();
            });

            // Cancel button click
            $('#btnCancel').on('click', function () {
                clearForm();
            });

            // Confirm delete button click
            $('#confirmDelete').on('click', function () {
                deleteColor(currentColorId);
                deleteModal.hide();
            });
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
                    console.log("Error loading colors:", error);
                }
            });
        }

        // Function to display colors in table
        function displayColors(colors) {
            var html = '';

            for (var i = 0; i < colors.length; i++) {
                var color = colors[i];
                var stockStatus = color.InStock ?
                    '<span class="in-stock"><i class="fas fa-check-circle me-1"></i>כן</span>' :
                    '<span class="out-of-stock"><i class="fas fa-times-circle me-1"></i>לא</span>';

                html += '<tr class="sortable-row table-row-animated" data-color-id="' + color.ColorID + '" title="לחץ וגרור לשינוי סדר">' +
                    '<td class="text-center drag-handle">' +
                    '<i class="fas fa-grip-vertical text-muted drag-icon" style="cursor: move;"></i>' +
                    '</td>' +
                    '<td class="color-name-cell">' +
                    '<div class="color-display">' +
                    '<div class="color-circle" style="background: ' + getColorHex(color.ColorName) + ';"></div>' +
                    '<strong>' + color.ColorName + '</strong>' +
                    '</div>' +
                    '</td>' +
                    '<td class="price-cell">₪' + parseFloat(color.Price).toFixed(2) + '</td>' +
                    '<td class="text-center order-badge">' +
                    '<span class="badge bg-primary">' + color.DisplayOrder + '</span>' +
                    '</td>' +
                    '<td class="text-center">' + stockStatus + '</td>' +
                    '<td class="action-buttons">' +
                    '<button type="button" class="btn btn-warning btn-sm me-1 edit-btn" onclick="editColor(' + color.ColorID + ', \'' + color.ColorName + '\', ' + color.Price + ', ' + color.DisplayOrder + ', ' + color.InStock + ')">' +
                    '<i class="fas fa-edit me-1"></i> ערוך' +
                    '</button>' +
                    '<button type="button" class="btn btn-danger btn-sm delete-btn" onclick="confirmDeleteColor(' + color.ColorID + ', \'' + color.ColorName + '\')">' +
                    '<i class="fas fa-trash me-1"></i> מחק' +
                    '</button>' +
                    '</td>' +
                    '</tr>';
            }

            $('#colorsTableBody').html(html);
        }

        // Function to save color (add or update)
        function saveColor() {
            var colorData = {
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
                    console.log("Error saving color:", error);
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
                    console.log("Error deleting color:", error);
                }
            });
        }

        // Function to update display order after drag & drop
        function updateDisplayOrder() {
            var orderData = [];
            $('#colorsTableBody tr').each(function (index) {
                var colorId = $(this).data('color-id');
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
                    console.log("Error updating display order:", error);
                }
            });
        }

        // Make table sortable
        function makeSortable() {
            try {
                $('#colorsTableBody').sortable({
                    items: 'tr.sortable-row',
                    handle: false, // Allow dragging from entire row
                    placeholder: 'ui-sortable-placeholder',
                    helper: function (e, tr) {
                        var $originals = tr.children();
                        var $helper = tr.clone();
                        $helper.children().each(function (index) {
                            $(this).width($originals.eq(index).width());
                        });
                        $helper.addClass('ui-sortable-helper-custom');
                        return $helper;
                    },
                    start: function (event, ui) {
                        ui.item.addClass('dragging');
                        $('body').addClass('sorting-active');
                    },
                    stop: function (event, ui) {
                        ui.item.removeClass('dragging');
                        $('body').removeClass('sorting-active');
                    },
                    update: function (event, ui) {
                        updateDisplayOrder();
                    },
                    tolerance: 'pointer',
                    cursor: 'grabbing',
                    opacity: 0.8,
                    revert: 100,
                    scroll: true,
                    scrollSensitivity: 100,
                    scrollSpeed: 20
                });
            } catch (e) {
                console.log("Error making table sortable:", e);
            }
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
            var alertClass = type === 'success' ? 'alert-success' :
                type === 'warning' ? 'alert-warning' : 'alert-danger';
            var icon = type === 'success' ? 'check-circle' :
                type === 'warning' ? 'exclamation-triangle' : 'times-circle';

            var html = '<div class="alert ' + alertClass + ' alert-dismissible fade show" role="alert">' +
                '<i class="fas fa-' + icon + ' me-2"></i>' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                '</div>';

            $('#alertContainer').html(html);

            // Auto hide after 5 seconds
            setTimeout(function () {
                $('.alert').alert('close');
            }, 5000);
        }

        // פונקציה לקבלת צבע hex לפי שם
        function getColorHex(colorName) {
            var colorMap = {
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

        // Global functions for button clicks (must be global for onclick handlers)
        function editColor(id, name, price, order, inStock) {
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
        }

        function confirmDeleteColor(id, name) {
            currentColorId = id;
            $('#deleteColorName').text(name);
            deleteModal.show();
        }
    </script>
</body>
</html>