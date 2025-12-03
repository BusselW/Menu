<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SharePoint Lijsten GUID Selector</title>
    <link rel="icon" href="data:,">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
        }
        .header {
            background: #0078d4;
            color: white;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .card {
            border-radius: 4px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .card-header {
            background: #0078d4;
            color: white;
            font-weight: 500;
        }
        .table th {
            background-color: #f0f0f0;
        }
        .guid-text {
            font-family: monospace;
            font-size: 0.9rem;
            color: #555;
        }
        .dropdown-menu {
            max-height: 400px;
            overflow-y: auto;
        }
        .api-url-display {
            font-family: monospace;
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #dee2e6;
        }
        #guidSearch {
            max-width: 300px;
        }
        .loading {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 30px;
        }
        .search-container {
            position: relative;
        }
        .search-container .fa-search {
            position: absolute;
            top: 12px;
            left: 12px;
            color: #6c757d;
        }
        .search-container input {
            padding-left: 35px;
        }
        .site-url-container {
            background: white;
            padding: 15px;
            border-radius: 4px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-list me-2"></i> SharePoint Lijsten GUID Selector</h1>
            <p class="mb-0">Selecteer lijsten en gebruik hun GUIDs voor API-aanroepen</p>
        </div>
        
        <div class="site-url-container">
            <div class="row">
                <div class="col-md-8">
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-link"></i>
                        </span>
                        <input type="text" class="form-control" id="siteUrlInput" 
                               placeholder="https://sharepoint.site/sites/"
                               aria-label="SharePoint site URL">
                    </div>
                    <small class="form-text text-muted">
                        Voer de volledige URL in van de SharePoint site
                    </small>
                </div>
                <div class="col-md-4">
                    <div class="d-flex justify-content-end align-items-center h-100 flex-wrap">
                        <div class="form-check form-switch me-3">
                            <input class="form-check-input" type="checkbox" id="showHiddenLists">
                            <label class="form-check-label" for="showHiddenLists">
                                Toon verborgen lijsten
                            </label>
                        </div>
                        <div class="form-check form-switch me-3">
                            <input class="form-check-input" type="checkbox" id="includeSubsites">
                            <label class="form-check-label" for="includeSubsites">
                                Inclusief subsites
                            </label>
                        </div>
                        <button class="btn btn-primary" type="button" id="refreshBtn">
                            <i class="fas fa-sync-alt"></i> Vernieuwen
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-filter me-2"></i> Lijst Selecteren
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="listDropdown" class="form-label">Selecteer een lijst:</label>
                            <select class="form-select" id="listDropdown">
                                <option value="" selected disabled>Kies een lijst...</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="guidSearch" class="form-label">Of zoek op GUID:</label>
                            <div class="search-container">
                                <i class="fas fa-search"></i>
                                <input type="text" class="form-control" id="guidSearch" 
                                       placeholder="Typ een GUID of lijstnaam...">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <i class="fas fa-code me-2"></i> API Endpoint
                    </div>
                    <div class="card-body">
                        <label class="form-label">API URL met geselecteerde GUID:</label>
                        <div class="api-url-display" id="apiUrlDisplay">
                            Selecteer eerst een lijst
                        </div>
                        <div class="d-flex justify-content-end mt-3">
                            <button class="btn btn-sm btn-outline-secondary" id="copyApiBtn">
                                <i class="fas fa-copy me-1"></i> Kopiëren
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-table me-2"></i> Lijsten en GUIDs</span>
                <span class="badge bg-light text-dark" id="listsCount">0</span>
            </div>
            <div class="card-body p-0" id="tableContainer">
                <div class="text-center py-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Laden...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- JavaScript libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Include our custom SharePoint Lists helper -->
    <script src="sharepointLists.js"></script>
    
    <script>
        // Store lists data globally for reference
        let listData = [];
        
        $(document).ready(function() {
            // Auto-detect site URL
            detectSiteUrl();
            
            // Load lists automatically
            loadLists();
            
            // Set up event handlers
            $("#refreshBtn").click(function() {
                loadLists();
            });
            
            $("#siteUrlInput").keypress(function(e) {
                if (e.which == 13) { // Enter key
                    loadLists();
                }
            });
            
            $("#showHiddenLists, #includeSubsites").change(function() {
                loadLists();
            });
            
            // Handle list selection from dropdown
            $("#listDropdown").change(function() {
                const selectedGuid = $(this).val();
                const selectedOption = $(this).find("option:selected");
                const siteUrl = selectedOption.data('site-url');
                updateApiUrl(selectedGuid, siteUrl);
            });
            
            // Handle search functionality
            $("#guidSearch").on("input", function() {
                const searchTerm = $(this).val().toLowerCase();
                
                // If search is empty, just reset the dropdown
                if (!searchTerm) {
                    populateDropdown(listData);
                    return;
                }
                
                // Filter by title or GUID
                const filtered = listData.filter(list => 
                    list.title.toLowerCase().includes(searchTerm) || 
                    list.guid.toLowerCase().includes(searchTerm)
                );
                
                // Update dropdown with filtered results
                populateDropdown(filtered);
                
                // If exactly one match and it's not empty, automatically select it
                if (filtered.length === 1) {
                    $("#listDropdown").val(filtered[0].guid);
                    const siteUrl = filtered[0].siteUrl || '';
                    updateApiUrl(filtered[0].guid, siteUrl);
                }
            });
            
            // Copy API URL to clipboard
            $("#copyApiBtn").click(function() {
                const apiUrl = $("#apiUrlDisplay").text();
                
                if (apiUrl === "Selecteer eerst een lijst") {
                    return;
                }
                
                navigator.clipboard.writeText(apiUrl)
                    .then(function() {
                        // Temporarily change button text to indicate success
                        const originalHtml = $("#copyApiBtn").html();
                        $("#copyApiBtn").html('<i class="fas fa-check me-1"></i> Gekopieerd!');
                        
                        setTimeout(function() {
                            $("#copyApiBtn").html(originalHtml);
                        }, 2000);
                    })
                    .catch(function(err) {
                        console.error('Error copying to clipboard: ', err);
                        alert('Kopiëren naar klembord mislukt');
                    });
            });
        });
        
        // Detect and set site URL
        function detectSiteUrl() {
            try {
                // Extract from current URL if possible
                var pathParts = window.location.pathname.split('/');
                var sitesIndex = pathParts.indexOf('sites');
                
                if (sitesIndex !== -1 && pathParts.length > sitesIndex + 1) {
                    var siteUrl = window.location.protocol + "//" + window.location.host;
                    siteUrl += '/sites/' + pathParts[sitesIndex + 1];
                    $("#siteUrlInput").val(siteUrl);
                }
            } catch (e) {
                console.warn("Could not auto-detect site URL", e);
            }
        }
        
        // Function to load lists using our helper
        function loadLists() {
            const siteUrl = $("#siteUrlInput").val().trim();
            const showHidden = $("#showHiddenLists").is(":checked");
            const includeSubsites = $("#includeSubsites").is(":checked");
            
            if (!siteUrl) {
                showError("Voer een geldige SharePoint site URL in");
                return;
            }
            
            // Show loading state
            $("#tableContainer").html(`
                <div class="text-center py-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Laden...</span>
                    </div>
                </div>
            `);
            
            // Reset dropdown and search
            $("#listDropdown").html('<option value="" selected disabled>Kies een lijst...</option>');
            $("#guidSearch").val('');
            $("#apiUrlDisplay").text("Selecteer eerst een lijst");
            
            if (includeSubsites) {
                // Load main site and all subsites
                loadSiteAndSubsites(siteUrl, showHidden);
            } else {
                // Just load the main site
                // Use our SPHelper module to get lists
                SPHelper.Lists.getLists(siteUrl, {
                    includeHidden: showHidden,
                    forceRefresh: true
                })
                .then(function(lists) {
                    // Filter to ONLY show NavBar lists
                    const filteredLists = lists.filter(list => list.title.includes("NavBar"));
                    
                    // Process the lists
                    processLists(filteredLists, siteUrl);
                })
                .catch(function(error) {
                    showError("Fout bij het laden van lijsten: " + (error.message || "Onbekende fout"));
                    console.error("Error loading lists:", error);
                });
            }
        }
        
        // Function to load a site and all its subsites recursively
        function loadSiteAndSubsites(siteUrl, showHidden) {
            // Show loading with message
            $("#tableContainer").html(`
                <div class="text-center py-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Laden...</span>
                    </div>
                    <div class="mt-2">Subsites en lijsten aan het laden... Dit kan even duren.</div>
                </div>
            `);
            
            // Array to store all lists from all sites
            let allLists = [];
            
            // First, get all subsites
            const getSubsitesUrl = siteUrl + "/_api/web/GetSubwebsFilteredForCurrentUser(nWebTemplateFilter=-1)";
            
            $.ajax({
                url: getSubsitesUrl,
                method: "GET",
                headers: { "Accept": "application/json;odata=verbose" },
                xhrFields: { withCredentials: true },
                success: function(subsitesData) {
                    const subsites = subsitesData.d.results;
                    
                    // Add the main site to the list of sites to process
                    const allSites = [{ url: siteUrl, title: "Main Site" }].concat(
                        subsites.map(site => ({ 
                            url: site.ServerRelativeUrl.startsWith('/') ? 
                                window.location.protocol + "//" + window.location.host + site.ServerRelativeUrl : 
                                site.ServerRelativeUrl,
                            title: site.Title
                        }))
                    );
                    
                    // Create an array of promises for loading lists from each site
                    const listPromises = allSites.map(site => {
                        return SPHelper.Lists.getLists(site.url, {
                            includeHidden: showHidden,
                            forceRefresh: true
                        })
                        .then(lists => {
                            // Add site information to each list
                            return lists.map(list => ({
                                ...list,
                                siteUrl: site.url,
                                siteTitle: site.title
                            }));
                        })
                        .catch(error => {
                            console.warn(`Error loading lists from ${site.url}:`, error);
                            return []; // Return empty array on error
                        });
                    });
                    
                    // Wait for all promises to resolve
                    Promise.all(listPromises)
                        .then(listsArrays => {
                            // Flatten arrays and combine all lists
                            allLists = [].concat(...listsArrays);
                            
                            // Filter out NavBar lists
                            allLists = allLists.filter(list => !list.title.includes("NavBar"));
                            
                            // Process all the lists
                            processLists(allLists);
                        })
                        .catch(error => {
                            showError("Fout bij het laden van lijsten: " + (error.message || "Onbekende fout"));
                            console.error("Error processing sites:", error);
                        });
                },
                error: function(xhr, status, error) {
                    showError("Fout bij het laden van subsites: " + error);
                    console.error("Error loading subsites:", xhr);
                }
            });
        }
        
        // Function to process lists data
        function processLists(lists, siteUrl) {
            // Store globally for reference
            listData = lists;
            
            // Update count badge
            $("#listsCount").text(lists.length);
            
            if (lists.length === 0) {
                $("#tableContainer").html(`
                    <div class="text-center py-4 text-muted">
                        <i class="fas fa-info-circle me-2"></i>
                        Geen lijsten gevonden
                    </div>
                `);
                return;
            }
            
            // Sort lists alphabetically by title
            lists.sort((a, b) => a.title.localeCompare(b.title));
            
            // Populate dropdown
            populateDropdown(lists);
            
            // Create table HTML
            const tableHtml = createListTable(lists);
            $("#tableContainer").html(tableHtml);
        }
        
        // Create HTML table of lists
        function createListTable(lists) {
            let html = `
                <div class="table-responsive">
                    <table class="table table-striped table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>RequestdigestHeaders</th>
                                ${$("#includeSubsites").is(":checked") ? '<th>Site</th>' : ''}
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
            `;
            
            lists.forEach(function(list) {
                const hiddenBadge = list.hidden ? 
                    '<span class="badge bg-secondary ms-2">Verborgen</span>' : '';
                
                html += `
                    <tr>
                        <td>
                            <div class="d-flex align-items-center">
                                <i class="fas ${list.isDocumentLibrary ? 'fa-folder' : 'fa-table'} text-primary me-2"></i>
                                <span>${list.title} ${hiddenBadge}</span>
                            </div>
                        </td>
                        <td>
                            <span class="guid-text">${list.guid}</span>
                        </td>
                `;
                
                // Add site column if we're including subsites
                if ($("#includeSubsites").is(":checked")) {
                    html += `
                        <td>
                            <small class="text-muted">${list.siteTitle || 'Main Site'}</small>
                        </td>
                    `;
                }
                
                html += `
                        <td>
                            <button class="btn btn-sm btn-outline-primary" onclick="selectList('${list.guid}', '${list.siteUrl || ''}')">
                                Selecteren
                            </button>
                        </td>
                    </tr>
                `;
            });
            
            html += `
                        </tbody>
                    </table>
                </div>
            `;
            
            return html;
        }
        
        // Populate dropdown with lists
        function populateDropdown(lists) {
            let options = '<option value="" selected disabled>Kies een lijst...</option>';
            
            lists.forEach(function(list) {
                let label = list.title;
                if (list.hidden) {
                    label += ' (Verborgen)';
                }
                if (list.siteTitle && list.siteTitle !== 'Main Site') {
                    label += ` [${list.siteTitle}]`;
                }
                
                options += `<option value="${list.guid}" 
                                   data-site-url="${list.siteUrl || ''}">${label}</option>`;
            });
            
            $("#listDropdown").html(options);
        }
        
        // Select a list by GUID
        function selectList(guid, listSiteUrl) {
            $("#listDropdown").val(guid);
            updateApiUrl(guid, listSiteUrl);
            
            // Scroll to dropdown area
            $('html, body').animate({
                scrollTop: $("#listDropdown").offset().top - 100
            }, 300);
        }
        
        // Update API URL display
        function updateApiUrl(guid, listSiteUrl) {
            if (!guid) {
                $("#apiUrlDisplay").text("Selecteer eerst een lijst");
                return;
            }
            
            // Use the list's site URL if provided (for subsites), otherwise use the main site URL
            const siteUrl = listSiteUrl || $("#siteUrlInput").val().trim();
            if (!siteUrl) {
                return;
            }
            
            // Format: /_api/web/lists(guid'00000000-0000-0000-0000-000000000000')
            const apiUrl = `${siteUrl}/_api/web/lists(guid'${guid}')`;
            $("#apiUrlDisplay").text(apiUrl);
        }
        
        // Show error message
        function showError(message) {
            $("#tableContainer").html(`
                <div class="alert alert-danger m-3">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    ${message}
                </div>
            `);
        }
    </script>
</body>
</html>