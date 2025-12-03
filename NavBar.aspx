<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Navigation System</title>

    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />

    <!-- Navigation Styles -->
    <link rel="stylesheet" href="https://som.org.om.local/sites/MulderT/CustomPW/HBS/MENU/CSS/navigation-styles.css">
    
    <!-- Core dependencies - jQuery first, then TailwindCSS -->
    <script src="https://som.org.om.local/sites/MulderT/CustomPW/_scripts/jquery371min.js"></script>
    
    <!-- Load Tailwind Configuration before Tailwind CSS -->
    <script src="https://som.org.om.local/sites/MulderT/CustomPW/HBS/MENU/JS/tailwind-configuration.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- SharePoint JS Libraries -->
    <script type="text/javascript" src="/_layouts/15/init.js"></script>
    <script type="text/javascript" src="/_layouts/15/MicrosoftAjax.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.runtime.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.js"></script>
    
    <!-- Critical styling fixes -->
    <link rel="stylesheet" href="https://som.org.om.local/sites/MulderT/CustomPW/HBS/MENU/CSS/fix-theming.css"></script>
</head>

<body class="bg-gray-50 font-sans">
    <!-- Direct Menu Loading Script -->
    <script>
        // Configuration
        const CONFIG = {
            site: {
                root: "https://som.org.om.local/sites/MulderT",
                detectSubsites: true
            },
            branding: {
                theme: "blue", // Options: blue, orange, purple, green, red, turquoise
                applyToHeader: true,
                applyToContent: true,
                customHeader: "" // Optional: custom header text, leave empty to use default "Navigatie"
            },
            navigation: {
                listGuid: "69832e47-6f67-4bb1-bb3d-dd1eda4d8db9",
                container: "#menu",
                hoverDelay: 300, // Delay in ms for hover menu expansion
                forceClickBehavior: false, // When true, always uses click to expand instead of hover
                editButton: {
                    enabled: true,
                    url: "https://som.org.om.local/sites/MulderT/CustomPW/HBS/NAVBAR/NAVBAREDIT/navbar-editor.aspx",
                    allowedRoles: ["Owner", "Administrator"], // SharePoint groups allowed to see edit button
                    showForCurrentUser: true // Fall back option to override permissions check
                }
            },
// In your config:
calendar: {
    enabled: true,
    listGuid: "e57d552c-a51d-4f2b-9fff-a7de1252fb5d",
    container: "#calendar-container",
    title: "Planning",
    itemCount: 5,
    showPagination: true,
    baseUrl: "https://som.org.om.local/sites/MulderT", // Add your SharePoint site URL here
    addEventUrl: "https://som.org.om.local/sites/MulderT/Lists/YourCalendarList/NewForm.aspx",
    editEventUrl: "https://som.org.om.local/sites/MulderT/Lists/YourCalendarList/EditForm.aspx?ID=",
    dateFormat: "DD/MM/YYYY",
    timeFormat: "HH:mm",
    filterField: "EventDate",
    filterValue: "range:today:3months"
},        debug: {
                enabled: false, // Enable debug mode with console logging
                level: "info" // Options: error, warn, info, debug
            }
        };
        
        // Apply theme immediately based on configuration
        document.addEventListener('DOMContentLoaded', function() {
            const theme = CONFIG.branding.theme || "orange";
            document.documentElement.setAttribute('data-theme', theme);
            document.body.setAttribute('data-theme', theme);
            
            if (CONFIG.debug.enabled) {
                console.log(`Applied theme: ${theme}`);
            }
        });
    </script>

    <div class="min-h-screen">
        <!-- Header with dynamic theme -->
        <header id="page-header" class="sticky top-0 z-50 text-white shadow-md">
            <div class="max-w-6xl mx-auto px-4 py-3 flex justify-between items-center">
                <h1 id="header-title" class="text-xl font-bold">Navigatie</h1>
                <div id="header-actions" class="flex items-center"></div>
            </div>
        </header>

        <!-- Content Area -->
        <div class="max-w-6xl mx-auto px-4 py-6">
            <!-- Navigation Menu -->
            <div class="mb-8">
                <nav class="w-full">
                    <ul id="menu" class="space-y-1 rounded-lg overflow-hidden">
                        <li class="text-center py-4">Loading navigation...</li>
                    </ul>
                </nav>
            </div>
            
            <!-- Calendar Container (Only rendered if enabled) -->
            <div id="calendar-container" class="hidden">
                <div class="calendar-header">
                    <h2 id="calendar-title">Upcoming Events</h2>
                    <button id="add-event-btn" class="hidden px-3 py-1 bg-gray-100 hover:bg-gray-200 rounded text-sm flex items-center">
                        <span class="material-icons text-sm mr-1">add</span>
                        Add Event
                    </button>
                </div>
                <ul id="calendar-events" class="calendar-event-list">
                    <li class="text-center py-4">Loading events...</li>
                </ul>
                <div id="calendar-pagination" class="mt-4 text-center hidden">
                    <button id="prev-page" class="px-3 py-1 bg-gray-100 hover:bg-gray-200 rounded text-sm">Previous</button>
                    <button id="next-page" class="px-3 py-1 bg-gray-100 hover:bg-gray-200 rounded ml-2 text-sm">Next</button>
                </div>
            </div>
        </div>
    </div>

		<script src="https://som.org.om.local/sites/MulderT/CustomPW/HBS/MENU/JS/setup.js"></script>        
		<script src="https://som.org.om.local/sites/MulderT/CustomPW/HBS/MENU/JS/iconMapping.js"></script>
		<script src="https://som.org.om.local/sites/MulderT/CustomPW/HBS/MENU/JS/renderNav.js"></script>
		<script src="https://som.org.om.local/sites/MulderT/CustomPW/HBS/MENU/JS/renderCal.js"></script>
</body>
</html>