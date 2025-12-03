<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Navigation System</title>

    <!-- ========================================== -->
    <!-- CENTRALE CONFIGURATIE & VARIABELEN         -->
    <!-- ========================================== -->
    <script>
        // --- 1. Basis Paden & Instellingen ---
        const SETTINGS = {
            // De hoofd URL van de site
            siteRoot: "https://som.org.om.local/sites/MulderT",
            
            // Het pad naar de CustomPW map
            customPwRoot: "https://som.org.om.local/sites/MulderT/CustomPW",
            
            // GUIDs voor de SharePoint lijsten
            listGuids: {
                navigation: "69832e47-6f67-4bb1-bb3d-dd1eda4d8db9",
                calendar: "e57d552c-a51d-4f2b-9fff-a7de1252fb5d"
            },
            
            // Debugging inschakelen?
            debug: false
        };

        // --- 2. Afgeleide Paden (Automatisch gegenereerd) ---
        const PATHS = {
            menuAssets: `${SETTINGS.customPwRoot}/HBS/MENU`,
            navbarEdit: `${SETTINGS.customPwRoot}/HBS/NAVBAR/NAVBAREDIT`,
            scripts: `${SETTINGS.customPwRoot}/_scripts`
        };

        // --- 3. Applicatie Configuratie (CONFIG object) ---
        // Dit object wordt gebruikt door de applicatie scripts
        window.CONFIG = {
            site: {
                root: SETTINGS.siteRoot,
                detectSubsites: true
            },
            branding: {
                theme: "blue", // Opties: blue, orange, purple, green, red, turquoise
                applyToHeader: true,
                applyToContent: true,
                customHeader: "" // Optioneel: aangepaste header tekst
            },
            navigation: {
                listGuid: SETTINGS.listGuids.navigation,
                container: "#menu",
                hoverDelay: 300,
                forceClickBehavior: false,
                editButton: {
                    enabled: true,
                    url: `${PATHS.navbarEdit}/navbar-editor.aspx`,
                    allowedRoles: ["Owner", "Administrator"],
                    showForCurrentUser: true
                }
            },
            calendar: {
                enabled: true,
                listGuid: SETTINGS.listGuids.calendar,
                container: "#calendar-container",
                title: "Planning",
                itemCount: 5,
                showPagination: true,
                baseUrl: SETTINGS.siteRoot,
                addEventUrl: `${SETTINGS.siteRoot}/Lists/YourCalendarList/NewForm.aspx`,
                editEventUrl: `${SETTINGS.siteRoot}/Lists/YourCalendarList/EditForm.aspx?ID=`,
                dateFormat: "DD/MM/YYYY",
                timeFormat: "HH:mm",
                filterField: "EventDate",
                filterValue: "range:today:3months"
            },
            debug: {
                enabled: SETTINGS.debug,
                level: "info"
            }
        };

        // --- 4. Resource Loader Functies ---
        // Helpt bij het laden van CSS en JS bestanden met de juiste paden
        function loadCss(url) {
            document.write('<link rel="stylesheet" href="' + url + '">');
        }
        
        function loadJs(url) {
            document.write('<script src="' + url + '"><\/script>');
        }

        // --- 5. Laden van Resources (Head) ---
        
        // Externe Fonts & Icons
        loadCss("https://fonts.googleapis.com/icon?family=Material+Icons");
        
        // Applicatie Stijlen
        loadCss(`${PATHS.menuAssets}/CSS/navigation-styles.css`);
        loadCss(`${PATHS.menuAssets}/CSS/fix-theming.css`);

        // Core Libraries (jQuery, Tailwind)
        loadJs(`${PATHS.scripts}/jquery371min.js`);
        loadJs(`${PATHS.menuAssets}/JS/tailwind-configuration.js`);
        loadJs("https://cdn.tailwindcss.com");

        // SharePoint Libraries
        loadJs("/_layouts/15/init.js");
        loadJs("/_layouts/15/MicrosoftAjax.js");
        loadJs("/_layouts/15/sp.runtime.js");
        loadJs("/_layouts/15/sp.js");

    </script>
</head>

<body class="bg-gray-50 font-sans">
    
    <!-- Thema Toepassen -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const theme = CONFIG.branding.theme || "orange";
            document.documentElement.setAttribute('data-theme', theme);
            document.body.setAttribute('data-theme', theme);
            if (CONFIG.debug.enabled) console.log(`Thema toegepast: ${theme}`);
        });
    </script>

    <div class="min-h-screen">
        <!-- Header met dynamisch thema -->
        <header id="page-header" class="sticky top-0 z-50 text-white shadow-md">
            <div class="max-w-6xl mx-auto px-4 py-3 flex justify-between items-center">
                <h1 id="header-title" class="text-xl font-bold">Navigatie</h1>
                <div id="header-actions" class="flex items-center"></div>
            </div>
        </header>

        <!-- Content Gebied -->
        <div class="max-w-6xl mx-auto px-4 py-6">
            <!-- Navigatie Menu -->
            <div class="mb-8">
                <nav class="w-full">
                    <ul id="menu" class="space-y-1 rounded-lg overflow-hidden">
                        <li class="text-center py-4">Navigatie laden...</li>
                    </ul>
                </nav>
            </div>
            
            <!-- Kalender Container (Alleen zichtbaar indien ingeschakeld) -->
            <div id="calendar-container" class="hidden">
                <div class="calendar-header">
                    <h2 id="calendar-title">Aankomende Evenementen</h2>
                    <button id="add-event-btn" class="hidden px-3 py-1 bg-gray-100 hover:bg-gray-200 rounded text-sm flex items-center">
                        <span class="material-icons text-sm mr-1">add</span>
                        Toevoegen
                    </button>
                </div>
                <ul id="calendar-events" class="calendar-event-list">
                    <li class="text-center py-4">Evenementen laden...</li>
                </ul>
                <div id="calendar-pagination" class="mt-4 text-center hidden">
                    <button id="prev-page" class="px-3 py-1 bg-gray-100 hover:bg-gray-200 rounded text-sm">Vorige</button>
                    <button id="next-page" class="px-3 py-1 bg-gray-100 hover:bg-gray-200 rounded ml-2 text-sm">Volgende</button>
                </div>
            </div>
        </div>
    </div>

    <!-- --- 6. Laden van Applicatie Scripts (Body) --- -->
    <script>
        // Deze scripts worden geladen nadat de HTML is opgebouwd
        loadJs(`${PATHS.menuAssets}/JS/setup.js`);
        loadJs(`${PATHS.menuAssets}/JS/iconMapping.js`);
        loadJs(`${PATHS.menuAssets}/JS/renderNav.js`);
        loadJs(`${PATHS.menuAssets}/JS/renderCal.js`);
    </script>
</body>
</html>