<!DOCTYPE html>
<html lang="nl" xmlns:mso="urn:schemas-microsoft-com:office:office" xmlns:msdt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882">
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Navigatie Menu Beheer</title>

  <link rel="icon" href="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNGRkQ3MDAiIHN0cm9rZS13aWR0aD0iMS41IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPgogIDxwYXRoIGZpbGw9IiNGRkQ3MDAiIGQ9Ik0xNyA3LjgybDEuMDUyIDEuMDUyYTIuMjEgMi4yMSAwIDExLTMuMTI0IDMuMTI0TDQgMjJIMXYtM2wxMC45MjgtMTAuOTI4YTIuMjEgMi4yMSAwIDAxMy4xMjQgMHoiIC8+CiAgPHBhdGggZD0iTTIwLjUgNi41djEzaC0yTTE2LjUgMi41aC01TTExLjUgMi41aDUiIC8+CiAgPHBhdGggZD0iTTExLjUgMTEuNWw0LTQiIC8+CiAgPHBhdGggZD0iTTUuNSA3LjVIMy41QzIuOTQ3NzIgNy41IDIuNSA3Ljk0NzcyIDIuNSA4LjV2MTAiIC8+CiAgPHBhdGggZD0iTTE2LjUgMi41YzAtMSAxLTEuNSAxLjUtMS41czEuNSAwLjUgMS41IDEuNVY0YzAgMC41NTIyOCAwLjQ0NzcyIDEgMSAxaDAuNSIgLz4KPC9zdmc+" type="image/svg+xml">

  <script type="text/javascript" src="/_layouts/15/init.js"></script>
  <script type="text/javascript" src="/_layouts/15/MicrosoftAjax.js"></script>
  <script type="text/javascript" src="/_layouts/15/sp.runtime.js"></script>
  <script type="text/javascript" src="/_layouts/15/sp.js"></script>

  <script src="https://cdn.tailwindcss.com"></script>

  <link
    href="https://fonts.googleapis.com/icon?family=Material+Icons"
    rel="stylesheet"
  />
  <link
    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
    rel="stylesheet"
  />

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <script src="https://som.org.om.local/sites/MulderT/CustomPW/HBS/CRUD/V2/3/crudBasis.js"></script>
  <script>console.log("crudBasis.js script tag verwerkt (bevat globale functies).");</script>

  <script>
    // Configureer Tailwind thema (onveranderd)
    tailwind.config = {
        theme: {
            extend: {
                colors: {
                    "brand-blue": { light: "#E6F0F8", DEFAULT: "#004882", dark: "#003B6B" },
                    "brand-orange": { light: "#FFF2E9", DEFAULT: "#CA5010", dark: "#A94210" },
                    "brand-purple": { light: "#F3E5F5", DEFAULT: "#4B0082", dark: "#3A0065" },
                    "brand-green": { light: "#E8F5E9", DEFAULT: "#006400", dark: "#004D00" },
                    "brand-red": { light: "#FBECEC", DEFAULT: "#800000", dark: "#660000" },
                    "brand-turquoise": { light: "#EAF7F7", DEFAULT: "#006D77", dark: "#00575F" }
                }
            }
        }
     };
  </script>

  <style>
    /* Basisstijlen (onveranderd) */
    .spin { animation: spin 1s linear infinite; }
    @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
    .modal-backdrop { background: rgba(0,0,0,0.5); }
    .items-table-container { max-height: 70vh; overflow-y: auto; width: 100%; }
    .items-table { width: 100%; min-width: 100%; border-collapse: collapse; }
    .items-table th, .items-table td { padding: 0.75rem 1rem; vertical-align: middle; border: 1px solid #e2e8f0; }
    .items-table th { position: sticky; top: 0; z-index: 10; text-align: left; }
    /* Table Header Styling */
    .items-table thead th {
        background-color: #003B6B; /* brand-blue-dark */
        color: white;
        border: 1px solid black; /* Add black border */
    }
    .items-table th.text-center, .items-table td.text-center { text-align: center; }
    .items-table td { word-break: break-word; }

    /* Specific Header Styling */
    #itemsTableContainerParent > div:first-child > h2 { /* Target H2 in the first div inside the wrapper */
        background-color: #CA5010; /* brand-orange */
        color: white; /* White text for contrast */
        border: 1px solid black;
        padding: 0.75rem 1rem; /* Match table padding */
        border-bottom: none; /* Remove bottom border if it's part of the container */
        border-top-left-radius: 0.375rem; /* Match container radius */
        border-top-right-radius: 0.375rem; /* Match container radius */
        margin-bottom: 0; /* Remove default margin if any */
    }


    @media (max-width: 768px) {
      .items-table-container { max-height: none; overflow-x: auto; }
      .tooltip-content { display: none !important; }
       .items-table { display: block; }
       .items-table thead, .items-table tbody, .items-table tr { display: block; }
       .items-table th, .items-table td { display: block; text-align: right !important; }
       .items-table td::before { content: attr(data-label); float: left; font-weight: bold; text-transform: uppercase; margin-right: 1rem; }
       .items-table th { display: none; }
       .items-table td:last-child { border-bottom: 2px solid #ccc; }
       .items-table td:nth-child(7) div { justify-content: flex-end !important; }
    }
    .modal-buttons { display: flex; justify-content: flex-end; gap: 0.75rem; }
    #iconPickerPanel { z-index: 20; max-height: 300px; overflow-y: auto; background-color: white; border: 1px solid #e2e8f0; border-radius: 0.375rem; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06); position: relative; }
    #iconGrid { display: grid; grid-template-columns: repeat(auto-fill, minmax(40px, 1fr)); gap: 0.5rem; margin-top: 0.5rem; }
    #iconGrid .material-icons { font-size: 1.25rem; }
    #iconGrid > div:hover { background-color: #edf2f7; transform: scale(1.1); transition: all 0.2s; }
    #iconSearch { width: 100%; padding: 0.375rem 0.75rem; border: 1px solid #e2e8f0; border-radius: 0.25rem; font-size: 0.875rem; }
    .p-4 .space-x-3 { display: flex; flex-direction: row; gap: 0.75rem; }
    #itemParentID { max-width: 100%; }
    #itemForm .space-y-4 > div { margin-bottom: 1rem; }

    /* Hierarchy Indentation */
    .indent-level-1 { padding-left: 2rem !important; }
    .indent-level-2 { padding-left: 4rem !important; }
    .indent-level-3 { padding-left: 6rem !important; }
    /* Add more levels if needed */

    /* Hierarchy Background Colors - Blue-based Professional Scheme */
    #itemsTable tr {
      background-color: #e2e8f0; /* Tailwind slate-200 (Level 0) */
      transition: background-color 0.15s ease-in-out; /* Smooth transition */
    }
    #itemsTable tr:hover {
      background-color: #cbd5e1; /* Tailwind slate-300 on hover */
    }
    #itemsTable tr:has(td.indent-level-1) {
      background-color: #f1f5f9; /* Tailwind slate-100 (Level 1) */
    }
    #itemsTable tr:has(td.indent-level-1):hover {
      background-color: #e2e8f0; /* Tailwind slate-200 on hover */
    }
    #itemsTable tr:has(td.indent-level-2) {
      background-color: #f8fafc; /* Tailwind slate-50 (Level 2) */
    }
    #itemsTable tr:has(td.indent-level-2):hover {
      background-color: #f1f5f9; /* Tailwind slate-100 on hover */
    }
    /* Add more levels if needed */

    /* Hierarchy Icon Styling */
    .hierarchy-icon {
        font-size: 1.1em; /* Adjust size as needed */
        vertical-align: -2px; /* Align icon nicely with text */
        margin-right: 0.25rem; /* Space between icon and text */
        color: #b40000; /* Gray-500 */
    }

    /* Tooltip Stijlen (onveranderd) */
    .tooltip-trigger { position: relative; cursor: help; display: inline-flex; align-items: center; }
    .tooltip-content { position: absolute; top: 125%; left: 50%; transform: translateX(-50%); background-color: #2d3748; color: #f7fafc; padding: 0.5rem 0.75rem; border-radius: 0.375rem; font-size: 0.75rem; font-weight: 500; white-space: nowrap; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06); opacity: 0; visibility: hidden; transition: opacity 0.2s ease-in-out, visibility 0.2s ease-in-out; z-index: 100; min-width: 150px; }
    .tooltip-trigger:hover .tooltip-content { opacity: 1; visibility: visible; }
    .tooltip-content .material-icons, .tooltip-content .material-symbols-outlined { font-size: 1rem; vertical-align: left; margin-right: 0.25rem; color: #63b3ed; }
    .tooltip-content::after { content: ""; position: absolute; bottom: 100%; left: 50%; margin-left: -5px; border-width: 5px; border-style: solid; border-color: transparent transparent #2d3748 transparent; }
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 20; font-size: 1em; vertical-align: middle; }

    /* Tutorial stijlen (onveranderd) */
    .tutorial-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0, 0, 0, 0.7); z-index: 1000; display: none; }
    .tutorial-step { position: absolute; background-color: white; border-radius: 0.5rem; padding: 1.5rem; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05); max-width: 400px; width: calc(100% - 40px); z-index: 1001; display: none; overflow: auto; max-height: 80vh; }
    .tutorial-step.active { display: block; opacity: 1 !important; visibility: visible !important; }
    .tutorial-step h3 { font-weight: 600; font-size: 1.25rem; margin-bottom: 0.75rem; color: #004882; }
    .tutorial-step p { margin-bottom: 0.75rem; line-height: 1.5; }
    .tutorial-step strong { font-weight: 600; color: #004882; }
    .tutorial-navigation { display: flex; justify-content: space-between; margin-top: 1rem; }
    .highlight-element { position: relative; z-index: 1002; box-shadow: 0 0 0 4px #FFD700, 0 0 0 6px rgba(0, 0, 0, 0.5); border-radius: 4px; }
    .tutorial-step .escape-notice { font-size: 0.75rem; color: #666; font-style: italic; margin-top: 0.5rem; }
    .close-tutorial { position: absolute; top: 10px; right: 10px; background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #aaa; line-height: 1; }
    .close-tutorial:hover { color: #333; }

    /* Material Icons CSS (onveranderd) */
    .material-icons { font-family: 'Material Icons'; font-weight: normal; font-style: normal; display: inline-block; line-height: 1; text-transform: none; letter-spacing: normal; word-wrap: normal; white-space: nowrap; direction: ltr; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; -moz-osx-font-smoothing: grayscale; font-feature-settings: 'liga'; }
    .material-symbols-outlined { font-family: 'Material Symbols Outlined'; font-weight: normal; font-style: normal; display: inline-block; line-height: 1; text-transform: none; letter-spacing: normal; word-wrap: normal; white-space: nowrap; direction: ltr; -webkit-font-smoothing: antialiased; text-rendering: optimizeLegibility; -moz-osx-font-smoothing: grayscale; }
  </style>

<!--[if gte mso 9]><SharePoint:CTFieldRefs runat=server Prefix="mso:" FieldList="FileLeafRef,TaxCatchAllLabel,Waar_x0020_dit_x0020_voor_x0020_is"><xml>
<mso:CustomDocumentProperties>
<mso:Waar_x0020_dit_x0020_voor_x0020_is msdt:dt="string">Dit is de hoofdpagina van de navbar-editor. Dit bestand is slechts het omhulsel en vereist invoer via javascript vanuit andere bestanden
</mso:Waar_x0020_dit_x0020_voor_x0020_is>
</mso:CustomDocumentProperties>
</xml></SharePoint:CTFieldRefs><![endif]-->
</head>

<body class="bg-gray-50 font-sans text-gray-800" data-theme="blue">
  <header class="sticky top-0 z-50 bg-gradient-to-r from-brand-blue to-brand-blue-dark text-white shadow-md">
      <div class="px-4 py-3 flex justify-between items-center">
      <div class="flex items-center space-x-2">
        <span class="material-icons">edit</span>
        <h1 class="text-xl font-bold">Navigatie Menu Bewerken (crudBasis Functies)</h1>
      </div>
      <div class="flex items-center space-x-2">
          <a href="#" id="backToNavBar" class="hover:bg-white/20 px-3 py-1 rounded transition-colors text-sm flex items-center">
              <span class="material-icons mr-1">arrow_back</span> Terug
          </a>
        <button id="helpButton" class="hover:bg-white/20 px-3 py-1 rounded transition-colors text-sm flex items-center">
          <span class="material-icons mr-1">help_outline</span> Help
        </button>
      </div>
    </div>
  </header>

  <main class="w-[99%] mx-auto p-4">
    <div id="statusBar" class="mb-4 p-3 bg-white border border-gray-200 rounded-lg shadow text-sm">
        <div class="flex items-center">
        <span class="material-icons mr-2 text-gray-500">info</span>
        <span id="statusMessage">Laden...</span>
      </div>
      <div id="listInfo" class="mt-2 ml-6 text-xs text-gray-500"></div>
    </div>

    <div class="bg-white border border-gray-200 rounded-lg shadow-md mb-6 w-full">
      <div id="itemsTableContainerParent">
        <div class="flex justify-between items-center border-b border-black bg-brand-orange-dark">
          <h2 class="text-lg font-semibold text-white flex-grow p-4">Navigatie Items</h2> <button id="createNewItemBtn" class="bg-green-600 hover:bg-green-700 text-white px-3 py-2 rounded flex items-center space-x-1 m-4 mr-4"> <span class="material-icons text-sm">add</span>
            <span>Nieuw item</span>
          </button>
        </div>
        <div class="items-table-container">
          <table class="items-table min-w-full">
            <thead>
              <tr class="bg-gray-50">
                <th class="text-center text-xs font-medium text-gray-500 uppercase tracking-wider py-3 px-4">
                  <div class="flex items-center justify-center">
                    <span class="whitespace-nowrap">Volgorde</span>
                    <span class="tooltip-trigger ml-1">
                      <span class="material-symbols-outlined text-xs text-gray-400">help_outline</span>
                      <span class="tooltip-content"><span class="material-icons text-blue-400">sort</span> Bepaalt waar de knop in het menu zal worden weergeven. 1. Staat bovenaan, 10. staat onderaan.</span>
                    </span>
                  </div>
                </th>
                <th class="text-left text-xs font-medium text-gray-500 uppercase tracking-wider py-3 px-4">
                    <div class="flex items-center">
                      <span class="whitespace-nowrap">Titel</span>
                      <span class="tooltip-trigger ml-1">
                        <span class="material-symbols-outlined text-xs text-gray-400">help_outline</span>
                        <span class="tooltip-content"><span class="material-icons text-purple-400">title</span> De weergavenaam in het menu. Dit is het zichtbare deel van de knop.</span>
                      </span>
                    </div>
                </th>
                <th class="text-left text-xs font-medium text-gray-500 uppercase tracking-wider py-3 px-4">
                  <div class="flex items-center">
                    <span class="whitespace-nowrap">URL</span>
                    <span class="tooltip-trigger ml-1">
                      <span class="material-symbols-outlined text-xs text-gray-400">help_outline</span>
                      <span class="tooltip-content"><span class="material-icons text-green-400">link</span> De link waarnaartoe verwezen wordt. Vul hier een link in beginnend met http:// of https:// en de pagina in de link zal worden geopend na het klikken op de knop.</span>
                    </span>
                  </div>
                </th>
                <th class="text-left text-xs font-medium text-gray-500 uppercase tracking-wider py-3 px-4">
                  <div class="flex items-center">
                    <span class="whitespace-nowrap">Onderliggend aan</span>
                    <span class="tooltip-trigger ml-1">
                      <span class="material-symbols-outlined text-xs text-gray-400">help_outline</span>
                      <span class="tooltip-content"><span class="material-icons text-orange-400">account_tree</span> Bepaalt de menustructuur. Items zonder koppeling (hoofdmenu) zijn altijd zichtbaar. Sub-items verschijnen pas als je op hun 'ouder-item' klikt. Bijvoorbeeld: als 'Start' een hoofditem is met daaronder 'Medewerkers', dan zie je 'Medewerkers' pas als je op 'Start' klikt.</span>
                    </span>
                  </div>
                </th>
                <th class="text-center text-xs font-medium text-gray-500 uppercase tracking-wider py-3 px-4">
                  <div class="flex items-center justify-center">
                    <span class="whitespace-nowrap">Icoon</span>
                    <span class="tooltip-trigger ml-1">
                      <span class="material-symbols-outlined text-xs text-gray-400">help_outline</span>
                      <span class="tooltip-content"><span class="material-icons text-teal-400">preview</span> Het icoontje dat zichtbaar is in het menu. In het bewerkscherm kun je de icon picker gebruiken om eenvoudig een icoon te kiezen.</span>
                    </span>
                  </div>
                </th>
                <th class="text-left text-xs font-medium text-gray-500 uppercase tracking-wider py-3 px-4">
                  <div class="flex items-center">
                    <span class="whitespace-nowrap">Icoon Naam</span>
                    <span class="tooltip-trigger ml-1">
                      <span class="material-symbols-outlined text-xs text-gray-400">help_outline</span>
                      <span class="tooltip-content"><span class="material-icons text-indigo-400">edit_note</span> De naam van het gekozen icoon. Deze waarde bepaalt welk icoon wordt weergegeven in het menu.</span>
                    </span>
                  </div>
                </th>
                <th class="text-center text-xs font-medium text-gray-500 uppercase tracking-wider py-3 px-4">
                  <div class="flex items-center justify-center">
                    <span class="whitespace-nowrap">Acties</span>
                    <span class="tooltip-trigger ml-1">
                      <span class="material-symbols-outlined text-xs text-gray-400">help_outline</span>
                      <span class="tooltip-content tooltip-content-left"><span class="material-icons text-red-400">settings</span> Knoppen om het menu-item te bewerken of verwijderen.</span>
                    </span>
                  </div>
                </th>
              </tr>
            </thead>
            <tbody id="itemsTable" class="bg-white">
                <tr>
                 <td colspan="8" class="text-center py-8 text-gray-500">
                   <div class="flex flex-col items-center">
                     <span class="material-icons spin mb-2">refresh</span>
                     <span>Items laden...</span>
                   </div>
                 </td>
               </tr>
            </tbody>
          </table>
        </div>
        <div class="p-4 border-t border-gray-200 flex justify-between items-center">
          <div class="text-sm text-gray-500">
            <span id="itemCount">0</span> items geladen
          </div>
          <button id="reloadBtn" class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-2 rounded flex items-center space-x-1">
            <span class="material-icons text-sm">refresh</span>
            <span>Vernieuwen</span>
          </button>
        </div>
      </div>
    </div>
  </main>

  <div id="editorModal" class="hidden fixed inset-0 z-50 flex items-center justify-center modal-backdrop">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-[75%] max-h-[80%] h-[80%] flex flex-col">
      <div class="p-4 border-b border-gray-200 flex justify-between items-center">
        <h3 id="editorTitle" class="text-lg font-semibold text-gray-800">Item Bewerken</h3>
        <button id="closeEditorBtn" class="text-gray-400 hover:text-gray-600 focus:outline-none">
          <span class="material-icons">close</span>
        </button>
      </div>
      <div class="p-4 overflow-y-auto">
        <form id="itemForm" class="space-y-4">
          <input type="hidden" id="itemId" />
          <div>
            <label for="itemTitle" class="block text-sm font-medium text-gray-700 mb-1">Titel *</label>
            <input type="text" id="itemTitle" required class="block w-full border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-brand-blue/20 focus:border-brand-blue p-2 text-sm" />
          </div>
          <div>
            <label for="itemURL" class="block text-sm font-medium text-gray-700 mb-1">URL</label>
            <input type="text" id="itemURL" class="block w-full border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-brand-blue/20 focus:border-brand-blue p-2 text-sm" />
            <p class="mt-1 text-xs text-gray-500">Leeg laten als je geen link wil.</p>
          </div>
          <div>
            <label for="itemIcon" class="block text-sm font-medium text-gray-700 mb-1">Icoon</label>
            <div class="flex items-center space-x-2">
              <input type="text" id="itemIcon" class="block w-full border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-brand-blue/20 focus:border-brand-blue p-2 text-sm" />
              <div class="flex items-center justify-center w-10 h-10 bg-gray-100 rounded">
                <span id="previewIcon" class="material-icons text-gray-600">chevron_right</span>
              </div>
              <button type="button" id="iconPickerBtn" class="p-2 rounded bg-gray-100 hover:bg-gray-200">
                <span class="material-icons">format_list_bulleted</span>
              </button>
            </div>
            <div id="iconPickerPanel" class="hidden mt-3 p-3 bg-white border border-gray-300 rounded-md shadow-md w-full">
              <div class="mb-2 relative">
                <input type="text" id="iconSearch" placeholder="Zoek iconen..." class="w-full p-2 border border-gray-200 rounded text-sm" />
              </div>
              <div id="iconGrid" class="grid grid-cols-8 gap-2"></div>
            </div>
            <p class="mt-1 text-xs text-gray-500">Material icon naam (bijv. home, info, etc.)</p>
          </div>
          <div>
            <label for="itemVolgordeID" class="block text-sm font-medium text-gray-700 mb-1">Volgorde</label>
            <input type="number" id="itemVolgordeID" class="block w-full border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-brand-blue/20 focus:border-brand-blue p-2 text-sm" />
          </div>
          <div>
            <label for="itemParentID" class="block text-sm font-medium text-gray-700 mb-1">Onderliggend maken aan</label>
            <select id="itemParentID" class="block w-full border border-gray-300 rounded-md shadow-sm focus:ring focus:ring-brand-blue/20 focus:border-brand-blue p-2 text-sm">
              <option value="">Geen (hoofdniveau)</option>
              </select>
          </div>
        </form>
      </div>
      <div class="p-4 border-t border-gray-200 flex justify-between items-center">
        <button id="deleteItemBtn" class="bg-red-600 hover:bg-red-700 text-white py-2 px-4 rounded flex items-center transition-colors hidden">
          <span class="material-icons text-sm mr-1">delete</span> Verwijderen
        </button>
        <div class="modal-buttons">
          <button id="cancelEditBtn" class="bg-gray-300 hover:bg-gray-400 text-gray-800 py-2 px-4 rounded transition-colors">Annuleren</button>
          <button id="saveItemBtn" class="bg-brand-blue hover:bg-brand-blue-dark text-white py-2 px-4 rounded flex items-center transition-colors">
            <span class="material-icons text-sm mr-1">save</span> Opslaan
          </button>
        </div>
      </div>
    </div>
  </div>

  <div id="confirmModal" class="hidden fixed inset-0 z-50 flex items-center justify-center modal-backdrop">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-sm">
      <div class="p-4 border-b border-gray-200">
        <h3 id="confirmTitle" class="text-lg font-semibold text-gray-800">Bevestiging</h3>
      </div>
      <div class="p-4">
        <p id="confirmMessage" class="text-gray-600 text-sm">Weet je zeker dat je dit wilt doen?</p>
      </div>
      <div class="p-4 border-t border-gray-200 flex justify-end space-x-3">
        <button id="confirmCancelBtn" class="bg-gray-300 hover:bg-gray-400 text-gray-800 py-2 px-4 rounded transition-colors">Annuleren</button>
        <button id="confirmOkBtn" class="bg-red-600 hover:bg-red-700 text-white py-2 px-4 rounded transition-colors">Bevestigen</button>
      </div>
    </div>
  </div>

  <div id="tutorialOverlay" class="tutorial-overlay">
      <div id="tutorialStep1" class="tutorial-step" data-position="center"> <button class="close-tutorial" onclick="closeTutorial()">&times;</button> <h3>Welkom bij de Navigatie Menu Bewerken</h3> <p>Met deze tool kunt u navigatiemenu's voor SharePoint aanmaken en beheren. Deze korte uitleg laat zien hoe u deze interface effectief kunt gebruiken.</p> <div class="tutorial-navigation"> <button class="bg-gray-300 hover:bg-gray-400 text-gray-800 py-1 px-3 rounded" onclick="closeTutorial()">Sluiten</button> <button class="bg-brand-blue hover:bg-brand-blue-dark text-white py-1 px-3 rounded" onclick="showTutorialStep(2)">Volgende</button> </div> <p class="escape-notice">Druk op 'Esc' om de uitleg te sluiten.</p> </div>
      <div id="tutorialStep2" class="tutorial-step" data-target=".items-table-container" data-position="bottom"> <button class="close-tutorial" onclick="closeTutorial()">&times;</button> <h3>Navigatie Items Overzicht</h3> <p>In deze tabel ziet u alle beschikbare navigatie-items. De volgorde in deze lijst bepaalt de positie van items in het menu. Items worden getoond op basis van volgordenummer, van laag naar hoog.</p> <div class="tutorial-navigation"> <button class="bg-gray-300 hover:bg-gray-400 text-gray-800 py-1 px-3 rounded" onclick="showTutorialStep(1)">Vorige</button> <button class="bg-brand-blue hover:bg-brand-blue-dark text-white py-1 px-3 rounded" onclick="showTutorialStep(3)">Volgende</button> </div> <p class="escape-notice">Druk op 'Esc' om de uitleg te sluiten.</p> </div>
      <div id="tutorialStep3" class="tutorial-step" data-target="#createNewItemBtn" data-position="bottom-left"> <button class="close-tutorial" onclick="closeTutorial()">&times;</button> <h3>Nieuw Item Aanmaken</h3> <p>Klik op de "Nieuw item" knop om een menu-item toe te voegen. In het formulier dat opent, kunt u de titel, URL, icoon en andere eigenschappen instellen.</p> <div class="tutorial-navigation"> <button class="bg-gray-300 hover:bg-gray-400 text-gray-800 py-1 px-3 rounded" onclick="showTutorialStep(2)">Vorige</button> <button class="bg-brand-blue hover:bg-brand-blue-dark text-white py-1 px-3 rounded" onclick="showTutorialStep(4)">Volgende</button> </div> <p class="escape-notice">Druk op 'Esc' om de uitleg te sluiten.</p> </div>
      <div id="tutorialStep4" class="tutorial-step" data-position="center"> <button class="close-tutorial" onclick="closeTutorial()">&times;</button> <h3>Menustructuur Opbouwen</h3> <p>U kunt een hiërarchisch menu maken met hoofd- en sub-items:</p> <p><strong>Hoofdniveau items:</strong> Altijd zichtbaar in het menu.<br> <strong>Sub-items:</strong> Verschijnen alleen als bezoekers op het bovenliggende item klikken.</p> <p>Gebruik het veld "Onderliggend aan" om een item als sub-item toe te wijzen aan een hoofditem.</p> <div class="tutorial-navigation"> <button class="bg-gray-300 hover:bg-gray-400 text-gray-800 py-1 px-3 rounded" onclick="showTutorialStep(3)">Vorige</button> <button class="bg-brand-blue hover:bg-brand-blue-dark text-white py-1 px-3 rounded" onclick="showTutorialStep(5)">Volgende</button> </div> <p class="escape-notice">Druk op 'Esc' om de uitleg te sluiten.</p> </div>
      <div id="tutorialStep5" class="tutorial-step" data-target=".edit-item-btn:first-of-type" data-position="right"> <button class="close-tutorial" onclick="closeTutorial()">&times;</button> <h3>Items Bewerken</h3> <p>Klik op het potlood-icoon (<span class="material-icons text-sm align-middle">edit</span>) om een bestaand menu-item te bewerken. U kunt de titel, URL, icoon, volgorde en relatie met andere items aanpassen.</p> <p>Gebruik de icon picker (knop met lijstjes <span class="material-icons text-sm align-middle">format_list_bulleted</span>) om eenvoudig een icoon te selecteren voor uw menu-item.</p> <div class="tutorial-navigation"> <button class="bg-gray-300 hover:bg-gray-400 text-gray-800 py-1 px-3 rounded" onclick="showTutorialStep(4)">Vorige</button> <button class="bg-brand-blue hover:bg-brand-blue-dark text-white py-1 px-3 rounded" onclick="showTutorialStep(6)">Volgende</button> </div> <p class="escape-notice">Druk op 'Esc' om de uitleg te sluiten.</p> </div>
      <div id="tutorialStep6" class="tutorial-step" data-target=".delete-item-btn:first-of-type" data-position="left"> <button class="close-tutorial" onclick="closeTutorial()">&times;</button> <h3>Items Verwijderen</h3> <p>Klik op het prullenbak-icoon (<span class="material-icons text-sm align-middle">delete</span>) om een menu-item te verwijderen. U krijgt altijd een bevestigingsvenster voordat het item definitief wordt verwijderd.</p> <p>Let op: als u een item met sub-items verwijdert, worden de sub-items automatisch naar het hoofdniveau verplaatst.</p> <div class="tutorial-navigation"> <button class="bg-gray-300 hover:bg-gray-400 text-gray-800 py-1 px-3 rounded" onclick="showTutorialStep(5)">Vorige</button> <button class="bg-brand-blue hover:bg-brand-blue-dark text-white py-1 px-3 rounded" onclick="closeTutorial()">Afronden</button> </div> <p class="escape-notice">Druk op 'Esc' om de uitleg te sluiten.</p> </div>
  </div>

  <script>
    // === Globale Configuratie ===
    let huidigeLijstData = {
      guid: null,
      siteUrl: null,
      lijstNaam: null,
      lijstItemEntityType: null,
      items: [],
      veldTypes: {},
      parentFieldUsed: null // *** NIEUW: Houdt bij welk veld ('ParentID1' of 'ParentID') gebruikt is ***
    };

    // Lijst met veelgebruikte iconen (onveranderd)
    const commonIcons = [ 'home', 'house', 'cottage', 'apartment', 'people', 'person', 'group', 'groups', 'diversity_3', 'supervisor_account', 'psychology', 'engineering', 'school', 'biotech', 'business', 'description', 'assignment', 'menu_book', 'book', 'auto_stories', 'library_books', 'folder', 'folder_shared', 'content_paste', 'grading', 'event', 'calendar_today', 'calendar_month', 'schedule', 'today', 'gavel', 'rate_review', 'checklist', 'fact_check', 'verified', 'verified_user', 'thumb_up', 'task_alt', 'high_quality', 'devices', 'computer', 'memory', 'lan', 'desktop_windows', 'wifi', 'code', 'upload_file', 'download', 'cloud_upload', 'build', 'build_circle', 'handyman', 'settings_suggest', 'troubleshoot', 'report_problem', 'warning', 'error', 'place', 'map', 'location_on', 'explore', 'navigation', 'local_parking', 'traffic', 'speed', 'hearing', 'record_voice_over', 'mail', 'email', 'chat', 'forum', 'comment', 'phone', 'call', 'video_call', 'meeting_room', 'public', 'language', 'web_asset', 'link', 'support', 'contact_support', 'support_agent', 'help', 'settings', 'admin_panel_settings', 'dashboard', 'analytics', 'insights', 'trending_up', 'bar_chart', 'summarize', 'timeline', 'assignment_turned_in', 'format_list_bulleted', 'checklist_rtl', 'euro', 'payments', 'account_balance_wallet', 'savings', 'account_balance', 'security', 'policy', 'highlight', 'lightbulb', 'print', 'scanner', 'chevron_right', 'calculate', 'calculator', 'stacked_bar_chart', 'data_usage', 'data_exploration', 'functions', 'query_stats', 'pin', 'format_paint', 'construction', 'architecture', 'article', 'text_snippet', 'history_edu', 'receipt_long', 'shopping_cart', 'shopping_bag', 'storefront', 'local_shipping', 'receipt', 'paid', 'attach_money', 'price_check', 'credit_card', 'badge', 'card_membership', 'card_giftcard', 'redeem', 'loyalty', 'discount', 'percent', 'local_offer', 'sell', 'category', 'newspaper', 'feed', 'rss_feed', 'wysiwyg', 'model_training', 'app_registration', 'integration_instructions', 'developer_mode', 'smart_button', 'terminal', 'table_view', 'view_agenda', 'web', 'photo_camera', 'photo_library', 'picture_as_pdf', 'image', 'collections', 'videocam', 'video_library', 'subscriptions', 'movie', 'slideshow', 'mic', 'mic_external_on', 'headphones', 'headset', 'speaker', 'podcasts', 'music_note', 'queue_music', 'playlist_play', 'album', 'notes', 'sticky_note_2', 'push_pin', 'edit_note', 'note_add', 'list', 'playlist_add_check', 'add_task', 'playlist_add', 'post_add', 'data_object', 'api', 'data_array', 'key', 'vpn_key', 'cloud', 'cloud_sync', 'cloud_done', 'cloud_download', 'cloud_upload', 'admin_mdi', 'shield', 'gpp_good', 'work', 'work_outline', 'domain', 'business_center', 'corporate_fare', 'lab_profile', 'science', 'psychology_alt', 'design_services', 'anchor', 'sailing', 'directions_boat', 'kayaking', 'surfing', 'fastfood', 'restaurant', 'restaurant_menu', 'local_cafe', 'coffee', 'sports_bar', 'liquor', 'local_bar', 'wine_bar', 'bakery_dining', 'flight', 'flight_takeoff', 'flight_land', 'luggage', 'hotel', 'no_meeting_room', 'rv_hookup', 'villa', 'emoji_objects', 'emoji_events', 'emoji_flags', 'emoji_nature', 'emoji_people', 'emoji_symbols', 'emoji_transportation', 'emoji_food_beverage', 'emoji_emotions'];

    // SharePoint Menu Pad (onveranderd)
    const MENU_PATH = "https://som.org.om.local/sites/MulderT/CustomPW/HBS/MENU";

    // --- Initialisatie ---
    document.addEventListener("DOMContentLoaded", function() {
      console.log("DOMContentLoaded event afgevuurd.");
      ExecuteOrDelayUntilScriptLoaded(initialiseerPagina, 'sp.js');
      updateTerugKnop();
    });

    // --- Hulpfuncties voor Local Storage (onveranderd) ---
    function slaLaatstGeselecteerdIcoonOp(icon) { if (icon) { try { localStorage.setItem('navBar_lastSelectedIcon', icon); } catch (e) { console.warn("Kon laatst geselecteerde icoon niet opslaan:", e); } } }
    function laadLaatstGeselecteerdIcoon() { try { return localStorage.getItem('navBar_lastSelectedIcon') || ""; } catch (e) { console.warn("Kon laatst geselecteerde icoon niet laden:", e); return ""; } }

    // --- Pagina Initialisatie ---
    async function initialiseerPagina() {
      const functieNaam = "initialiseerPagina";
      toonStatus("Pagina initialiseren...", true);
      console.log(`[${functieNaam}] Start initialisatie.`);

      const urlParams = new URLSearchParams(window.location.search);
      const guidParam = urlParams.get("listGuid");
      let siteUrlParam = urlParams.get("siteUrl");
      if (!guidParam) { toonStatus("Fout: Geen lijst GUID gevonden in URL.", false, true); console.error(`[${functieNaam}] Fout: listGuid parameter ontbreekt.`); return; }
      huidigeLijstData.guid = guidParam;
      console.log(`[${functieNaam}] listGuid gevonden: ${guidParam}`);
      if (!siteUrlParam && typeof _spPageContextInfo !== 'undefined' && _spPageContextInfo?.webAbsoluteUrl) { siteUrlParam = _spPageContextInfo.webAbsoluteUrl; console.log(`[${functieNaam}] siteUrl uit _spPageContextInfo: ${siteUrlParam}`); }
      else if (!siteUrlParam) { siteUrlParam = window.location.origin + (_spPageContextInfo?.webServerRelativeUrl || ''); console.warn(`[${functieNaam}] Geen siteUrl parameter of context, fallback naar window.location: ${siteUrlParam}`); }
      else { console.log(`[${functieNaam}] siteUrl uit parameter: ${siteUrlParam}`); }
      if (!siteUrlParam) { toonStatus("Fout: Kon siteUrl niet bepalen.", false, true); console.error(`[${functieNaam}] Fout: Kon siteUrl niet definitief bepalen.`); return; }
      huidigeLijstData.siteUrl = siteUrlParam;
      document.getElementById('listInfo').textContent = `Site URL: ${huidigeLijstData.siteUrl}`;

      try {
        toonStatus(`Lijstnaam ophalen...`);
        console.log(`[${functieNaam}] Lijstnaam ophalen via fallback AJAX...`);
        huidigeLijstData.lijstNaam = await haalLijstNaamOpViaGuid_Fallback(huidigeLijstData.guid, huidigeLijstData.siteUrl);
        if (!huidigeLijstData.lijstNaam) { throw new Error(`Kon lijstnaam niet ophalen voor GUID ${huidigeLijstData.guid}.`); }
        document.getElementById('listInfo').textContent += ` | Lijst: ${huidigeLijstData.lijstNaam}`;
        console.log(`[${functieNaam}] Lijstnaam gevonden: ${huidigeLijstData.lijstNaam}`);

        toonStatus(`Item type ophalen voor lijst ${huidigeLijstData.lijstNaam}...`);
        console.log(`[${functieNaam}] ListItemEntityType ophalen...`);
        huidigeLijstData.lijstItemEntityType = await haalLijstItemEntityType(huidigeLijstData.siteUrl, huidigeLijstData.lijstNaam);
        if (!huidigeLijstData.lijstItemEntityType) { throw new Error(`Kon ListItemEntityType niet ophalen voor lijst ${huidigeLijstData.lijstNaam}.`); }
        console.log(`[${functieNaam}] ListItemEntityType gevonden: ${huidigeLijstData.lijstItemEntityType}`);

        // *** Aangepast: Data laden gebeurt nu binnen try-catch met fallback ***
        await laadLijstData();

        console.log(`[${functieNaam}] Data verwerkt (na laden), setupEventHandlers aanroepen...`);
        setupEventHandlers(); // Koppel event handlers NADAT de initiële data geladen IS (of laadpoging is afgerond)

        // Status pas zetten na succesvolle laadpoging of als laadLijstData zelf de status al op error heeft gezet
        if (huidigeLijstData.items.length > 0 || huidigeLijstData.parentFieldUsed !== null) {
            toonStatus("Initialisatie voltooid.", false);
             console.log(`[${functieNaam}] Initialisatie succesvol voltooid (Data geladen met veld: ${huidigeLijstData.parentFieldUsed || 'onbekend/geen'}).`);
        } else if (!document.getElementById("statusMessage").textContent.toLowerCase().includes('fout')) {
             // Als er geen items zijn, maar ook geen fout is weergegeven door laadLijstData
             toonStatus("Initialisatie voltooid (geen items gevonden).", false);
             console.log(`[${functieNaam}] Initialisatie voltooid (geen items gevonden).`);
        } else {
             console.log(`[${functieNaam}] Initialisatie voltooid met eerdere fout tijdens laden.`);
        }


      } catch (error) {
        // Fouten van VOOR laadLijstData (GUID, SiteURL, Lijstnaam, EntityType)
        console.error(`[${functieNaam}] Fout opgetreden tijdens initialisatie (vóór data laden):`, error);
        let userMessage = `Fout bij initialisatie: ${error.message}`;
        if (error.message.includes("Kon lijstnaam niet ophalen")) { userMessage += " Controleer of de lijst met het opgegeven GUID bestaat en toegankelijk is."; console.error(`[${functieNaam}] Actie: Verifieer GUID ${huidigeLijstData.guid} en permissies op site ${huidigeLijstData.siteUrl}.`); }
        else if (error.message.includes("Kon ListItemEntityType niet ophalen")) { userMessage += ` Controleer of de lijst '${huidigeLijstData.lijstNaam}' bestaat en toegankelijk is via de REST API.`; console.error(`[${functieNaam}] Actie: Verifieer lijstnaam en API toegang voor lijst '${huidigeLijstData.lijstNaam}' op ${huidigeLijstData.siteUrl}.`); }
        toonStatus(userMessage, false, true);
      }
    }

    // Fallback voor lijstnaam ophalen (onveranderd)
    function haalLijstNaamOpViaGuid_Fallback(guid, siteUrl) {
        console.log(`[haalLijstNaamOpViaGuid_Fallback] Lijstnaam ophalen voor GUID: ${guid} op ${siteUrl}`);
        const apiUrl = `${siteUrl}/_api/web/lists(guid'${guid}')?$select=Title`;
        return new Promise((resolve, reject) => {
            $.ajax({ url: apiUrl, method: "GET", headers: { Accept: "application/json;odata=verbose" }, xhrFields: { withCredentials: true },
                success: (data) => { if (data.d && data.d.Title) { resolve(data.d.Title); } else { console.error("[haalLijstNaamOpViaGuid_Fallback] Lijsttitel niet gevonden in response:", data); reject(new Error("Lijsttitel niet gevonden in response (fallback).")); } },
                error: (xhr, status, error) => { console.error(`[haalLijstNaamOpViaGuid_Fallback] Fout bij ophalen lijstnaam: ${error}`, xhr.responseText); reject(new Error(`Kon lijstnaam niet ophalen (fallback): ${error || status}`)); }
            });
        });
    }

    // Functie om ListItemEntityType op te halen (onveranderd)
    async function haalLijstItemEntityType(siteUrl, lijstNaam) {
        const functieNaam = "haalLijstItemEntityType";
        const endpoint = `_api/web/lists/getbytitle('${encodeURIComponent(lijstNaam)}')?$select=ListItemEntityTypeFullName`;
        console.log(`[${functieNaam}] Ophalen ListItemEntityType voor lijst '${lijstNaam}' via endpoint: ${endpoint}`);
        try {
             if (typeof haalGegevensOp !== 'function') { throw new Error("Globale functie 'haalGegevensOp' is niet beschikbaar."); }
            const data = await haalGegevensOp(siteUrl, endpoint);
            if (data && data.d && data.d.ListItemEntityTypeFullName) { return data.d.ListItemEntityTypeFullName; }
            else { console.error(`[${functieNaam}] Kon ListItemEntityTypeFullName niet vinden in het antwoord voor lijst '${lijstNaam}'. Response:`, data); return null; }
        } catch (error) {
            console.error(`[${functieNaam}] Fout bij ophalen ListItemEntityType voor lijst '${lijstNaam}':`, error);
            throw new Error(`Kon ListItemEntityType niet ophalen voor lijst ${lijstNaam}. Details: ${error.message}`);
        }
    }


    // Update 'Terug' Knop (onveranderd)
    function updateTerugKnop() { const terugKnop = document.getElementById("backToNavBar"); if (terugKnop) { terugKnop.removeAttribute("href"); terugKnop.addEventListener("click", function(e) { e.preventDefault(); window.history.back(); }); console.log("Terug knop ingesteld op history.back()"); } else { console.warn("Terug knop niet gevonden (ID 'backToNavBar')."); } }

    // Icon Picker Setup (onveranderd)
    function setupIconPicker() { const iconPickerBtn = document.getElementById('iconPickerBtn'); let iconPickerPanel = document.getElementById('iconPickerPanel'); const iconGrid = document.getElementById('iconGrid'); const iconSearch = document.getElementById('iconSearch'); const itemIcon = document.getElementById('itemIcon'); const previewIcon = document.getElementById('previewIcon'); if (!iconPickerBtn || !iconPickerPanel || !iconGrid || !iconSearch || !itemIcon || !previewIcon) { console.error("[setupIconPicker] Een of meer icon picker elementen niet gevonden."); return; } const newIconPickerBtn = iconPickerBtn.cloneNode(true); iconPickerBtn.parentNode.replaceChild(newIconPickerBtn, iconPickerBtn); iconPickerPanel.classList.add('hidden'); iconGrid.innerHTML = ''; function populateIconGrid(icons) { iconGrid.innerHTML = ''; icons.forEach(icon => { const iconItem = document.createElement('div'); iconItem.className = 'flex items-center justify-center p-2 border border-gray-200 rounded cursor-pointer hover:bg-gray-100 transition-colors'; iconItem.innerHTML = `<span class="material-icons">${icon}</span>`; iconItem.title = icon; iconItem.addEventListener('click', () => { itemIcon.value = icon; previewIcon.textContent = icon; slaLaatstGeselecteerdIcoonOp(icon); }); iconGrid.appendChild(iconItem); }); } populateIconGrid(commonIcons); newIconPickerBtn.addEventListener('click', (e) => { e.preventDefault(); e.stopPropagation(); iconPickerPanel.classList.toggle('hidden'); if (!iconPickerPanel.classList.contains('hidden')) { newIconSearch.value = ''; populateIconGrid(commonIcons); newIconSearch.focus(); } }); const newIconSearch = iconSearch.cloneNode(true); iconSearch.parentNode.replaceChild(newIconSearch, iconSearch); newIconSearch.addEventListener('click', (e) => e.stopPropagation()); newIconSearch.addEventListener('input', () => { const searchTerm = newIconSearch.value.toLowerCase().trim(); const filteredIcons = commonIcons.filter(icon => icon.toLowerCase().includes(searchTerm)); populateIconGrid(filteredIcons); }); const newIconPickerPanel = iconPickerPanel.cloneNode(false); while (iconPickerPanel.firstChild) { newIconPickerPanel.appendChild(iconPickerPanel.firstChild); } iconPickerPanel.parentNode.replaceChild(newIconPickerPanel, iconPickerPanel); iconPickerPanel = newIconPickerPanel; iconPickerPanel.addEventListener('click', (e) => e.stopPropagation()); const documentClickHandler = (e) => { if (!e.target.closest('#iconPickerPanel') && !e.target.closest('#iconPickerBtn') && !iconPickerPanel.classList.contains('hidden')) { iconPickerPanel.classList.add('hidden'); } }; document.removeEventListener('click', documentClickHandler); document.addEventListener('click', documentClickHandler); if (!iconPickerPanel.querySelector('.icon-picker-header')) { const header = document.createElement('div'); header.className = 'icon-picker-header flex justify-between items-center mb-2 px-1'; const title = document.createElement('h4'); title.className = 'text-sm font-medium text-gray-700'; title.textContent = 'Selecteer een icoon'; header.appendChild(title); const closeButton = document.createElement('button'); closeButton.type = "button"; closeButton.className = 'text-gray-500 hover:text-gray-700 p-1 -mr-1'; closeButton.innerHTML = '<span class="material-icons text-base">close</span>'; closeButton.addEventListener('click', (e) => { e.preventDefault(); e.stopPropagation(); iconPickerPanel.classList.add('hidden'); }); header.appendChild(closeButton); iconPickerPanel.insertBefore(header, iconPickerPanel.firstChild); } }

    // Event Handlers Setup (onveranderd, gebruikt nu cloneNode)
    function setupEventHandlers() {
        console.log("[setupEventHandlers] Event handlers koppelen...");
        const functieNaam = "setupEventHandlers";

        function voegListenerToe(id, event, handler) {
            const element = document.getElementById(id);
            if (element) {
                const newElement = element.cloneNode(true);
                element.parentNode.replaceChild(newElement, element);
                newElement.addEventListener(event, handler);
                console.log(`[${functieNaam}] Listener voor '${event}' toegevoegd/vervangen op #${id}`);
            } else {
                console.warn(`[${functieNaam}] Element met ID '${id}' niet gevonden. Kon geen listener toevoegen.`);
            }
        }

        voegListenerToe("createNewItemBtn", "click", () => openEditor(null));
        voegListenerToe("reloadBtn", "click", () => laadLijstData());
        voegListenerToe("closeEditorBtn", "click", closeEditor);
        voegListenerToe("cancelEditBtn", "click", closeEditor);
        voegListenerToe("saveItemBtn", "click", (e) => { e.preventDefault(); saveItem(); });
        voegListenerToe("deleteItemBtn", "click", (e) => { e.preventDefault(); confirmDelete(); });
        voegListenerToe("confirmCancelBtn", "click", hideConfirmModal);
        voegListenerToe("confirmOkBtn", "click", () => {
            actuallyDeleteItem();
            hideConfirmModal();
        });
        voegListenerToe("itemIcon", "input", function () {
            const iconName = this.value.trim() || "chevron_right";
            const previewIcon = document.getElementById("previewIcon");
            if(previewIcon) previewIcon.textContent = iconName;
        });
        voegListenerToe("helpButton", "click", startTutorial);

        console.log("[setupEventHandlers] Event handlers koppelen voltooid.");
    }

    // Tutorial Systeem Functies (onveranderd)
    let currentTutorialStep = 1; let highlightedElement = null; function initTutorialSystem() { const helpButton = document.getElementById('helpButton'); if (helpButton) { /* Listener wordt nu in setupEventHandlers toegevoegd */ } else { console.warn("[initTutorialSystem] Help knop niet gevonden."); } document.addEventListener('keydown', function(event) { if (event.key === 'Escape') { closeTutorial(); } }); window.addEventListener('resize', function() { const overlay = document.getElementById('tutorialOverlay'); if (overlay && overlay.style.display === 'block') { repositionCurrentStep(); } }); } function startTutorial() { const overlay = document.getElementById('tutorialOverlay'); if (overlay) { overlay.style.display = 'block'; showTutorialStep(1); } } function closeTutorial() { const overlay = document.getElementById('tutorialOverlay'); if (overlay) { overlay.style.display = 'none'; if (highlightedElement) { highlightedElement.classList.remove('highlight-element'); highlightedElement = null; } } } function repositionCurrentStep() { if (currentTutorialStep) { showTutorialStep(currentTutorialStep); } } function showTutorialStep(stepNumber) { const steps = document.querySelectorAll('.tutorial-step'); steps.forEach(step => step.classList.remove('active')); const currentStep = document.getElementById(`tutorialStep${stepNumber}`); if (!currentStep) return; currentStep.classList.add('active'); currentTutorialStep = stepNumber; currentStep.style.transform = ''; if (highlightedElement) { highlightedElement.classList.remove('highlight-element'); highlightedElement = null; } const targetSelector = currentStep.getAttribute('data-target'); let position = currentStep.getAttribute('data-position') || 'center'; if (targetSelector) { const targetElement = document.querySelector(targetSelector); if (targetElement) { targetElement.classList.add('highlight-element'); highlightedElement = targetElement; const targetRect = targetElement.getBoundingClientRect(); const stepRect = currentStep.getBoundingClientRect(); const viewportWidth = window.innerWidth; const viewportHeight = window.innerHeight; let left, top; switch (position) { case 'top': top = targetRect.top - stepRect.height - 20; left = targetRect.left + (targetRect.width / 2) - (stepRect.width / 2); break; case 'bottom': top = targetRect.bottom + 20; left = targetRect.left + (targetRect.width / 2) - (stepRect.width / 2); break; case 'left': top = targetRect.top + (targetRect.height / 2) - (stepRect.height / 2); left = targetRect.left - stepRect.width - 20; break; case 'right': top = targetRect.top + (targetRect.height / 2) - (stepRect.height / 2); left = targetRect.right + 20; break; case 'bottom-left': top = targetRect.bottom + 20; left = targetRect.left; break; default: top = targetRect.top + (targetRect.height / 2) - (stepRect.height / 2); left = targetRect.left + (targetRect.width / 2) - (stepRect.width / 2); } const padding = 20; if (left + stepRect.width > viewportWidth - padding) { left = viewportWidth - stepRect.width - padding; } if (left < padding) { left = padding; } if (top + stepRect.height > viewportHeight - padding) { if (position === 'bottom' || position === 'bottom-left') { top = Math.max(padding, targetRect.top - stepRect.height - 20); } else { top = viewportHeight - stepRect.height - padding; } } if (top < padding) { if (position === 'top') { top = Math.min(targetRect.bottom + 20, viewportHeight - stepRect.height - padding); } else { top = padding; } } currentStep.style.top = `${top}px`; currentStep.style.left = `${left}px`; if (viewportWidth < 600) { currentStep.style.left = '50%'; currentStep.style.transform = 'translateX(-50%)'; if (targetRect.top < viewportHeight / 2) { if (targetRect.bottom + stepRect.height + padding > viewportHeight) { currentStep.style.top = '50%'; currentStep.style.transform = 'translate(-50%, -50%)'; } else { currentStep.style.top = `${targetRect.bottom + 20}px`; } } else { if (targetRect.top - stepRect.height - padding < 0) { currentStep.style.top = '50%'; currentStep.style.transform = 'translate(-50%, -50%)'; } else { currentStep.style.top = `${targetRect.top - stepRect.height - 20}px`; } } } } else { position = 'center'; } } if (position === 'center') { currentStep.style.top = '50%'; currentStep.style.left = '50%'; currentStep.style.transform = 'translate(-50%, -50%)'; } }

    // Check Veld Type (onveranderd)
    function checkVeldType(guid, veldNaam) { return new Promise((resolve) => { if (huidigeLijstData.veldTypes[veldNaam]) { resolve(huidigeLijstData.veldTypes[veldNaam]); return; } const siteUrl = huidigeLijstData.siteUrl; if (!siteUrl || !guid) { console.error("SiteURL of GUID ontbreekt voor checkVeldType"); resolve({ veldType: 'Error', isNoteType: false, isUrlType: false }); return; } const apiUrl = `${siteUrl}/_api/web/lists(guid'${guid}')/fields?$filter=InternalName eq '${veldNaam}'&$select=TypeAsString`; $.ajax({ url: apiUrl, method: "GET", headers: { Accept: "application/json;odata=verbose" }, xhrFields: { withCredentials: true }, success: (data) => { let veldInfo = { veldType: 'Unknown', isNoteType: false, isUrlType: false }; if (data.d && data.d.results && data.d.results.length > 0) { const veld = data.d.results[0]; veldInfo = { veldType: veld.TypeAsString, isNoteType: veld.TypeAsString === 'Note', isUrlType: veld.TypeAsString === 'URL' }; } else { console.warn(`Veld ${veldNaam} niet gevonden.`); } huidigeLijstData.veldTypes[veldNaam] = veldInfo; resolve(veldInfo); }, error: (xhr, status, error) => { console.error(`Kon veldtype voor ${veldNaam} niet controleren: ${error}`, xhr.responseText); const defaultInfo = { veldType: 'Error', isNoteType: false, isUrlType: false }; huidigeLijstData.veldTypes[veldNaam] = defaultInfo; resolve(defaultInfo); } }); }); }

    // *** GEWIJZIGD: Laad Lijst Data (Two-Attempt Fetch) ***
    async function laadLijstData() {
        const functieNaam = "laadLijstData";
        const { lijstNaam, siteUrl } = huidigeLijstData;
        const tabelBody = document.getElementById("itemsTable"); // Haal tabelBody hier alvast op

        // Reset state before loading
        huidigeLijstData.items = [];
        huidigeLijstData.parentFieldUsed = null;
        if(tabelBody) {
             tabelBody.innerHTML = `<tr><td colspan="8" class="text-center py-8 text-gray-500"><div class="flex flex-col items-center"><span class="material-icons spin mb-2">refresh</span><span>Items laden...</span></div></td></tr>`;
        } else {
            console.error(`[${functieNaam}] Tabel body #itemsTable niet gevonden.`);
            toonStatus("Fout: Kan tabel niet vinden om te vullen.", false, true);
            return;
        }
        document.getElementById('itemCount').textContent = 0;


        if (!lijstNaam || !siteUrl) {
            console.warn(`[${functieNaam}] Aanroep gestopt: lijstNaam of siteUrl is niet beschikbaar.`);
            toonStatus("Fout: Lijstnaam of Site URL is niet beschikbaar om data te laden.", false, true);
            tabelBody.innerHTML = `<tr><td colspan="8" class="px-3 py-3 text-center text-sm text-red-600 italic">Lijstnaam of site URL ontbreekt.</td></tr>`;
            return;
        }

        toonStatus("Items laden (poging 1: met ParentID1)...", true);
        console.log(`[${functieNaam}] Items ophalen voor lijst: ${lijstNaam} (poging 1: met ParentID1)...`);

        const selectVeldenAttempt1 = "Id,Title,URL,ParentID1,VolgordeID,Icon"; // Poging 1 velden
        const selectVeldenAttempt2 = "Id,Title,URL,ParentID,VolgordeID,Icon";  // Poging 2 velden
        const orderBy = "VolgordeID asc, Title asc";
        const top = 5000; // Max items to fetch
        let items = [];
        let parentField = null; // Wordt 'ParentID1' of 'ParentID'

        try {
            // --- Poging 1: Probeer met ParentID1 ---
            const endpointAttempt1 = `_api/web/lists/getbytitle('${encodeURIComponent(lijstNaam)}')/items?$select=${selectVeldenAttempt1}&$orderby=${orderBy}&$top=${top}`;
            console.log(`[${functieNaam}] Poging 1 API call: ${endpointAttempt1}`);
            const data = await haalGegevensOp(siteUrl, endpointAttempt1);

            if (data && data.d && Array.isArray(data.d.results)) {
                items = data.d.results;
                parentField = 'ParentID1'; // Succes met ParentID1
                console.log(`[${functieNaam}] Poging 1 succesvol: ${items.length} items ontvangen met ParentID1.`);
            } else {
                console.warn(`[${functieNaam}] Poging 1: Geen items gevonden of onverwacht dataformaat:`, data);
                throw new Error("Poging 1 leverde onverwacht dataformaat op.");
            }

        } catch (errorAttempt1) {
            console.warn(`[${functieNaam}] Poging 1 (met ParentID1) mislukt:`, errorAttempt1.message || errorAttempt1);

            // --- Controleer of de fout specifiek komt doordat ParentID1 niet bestaat ---
            // Pas deze string aan als de foutmelding in de praktijk anders is
            const fieldNotFoundErrorMsg = "ParentID1 bestaat niet";
            const fieldNotFoundCheck = (msg) => msg && typeof msg === 'string' && msg.includes(fieldNotFoundErrorMsg);

            if (fieldNotFoundCheck(errorAttempt1.message) || fieldNotFoundCheck(errorAttempt1.foutData?.['odata.error']?.message?.value) ) {
                console.log(`[${functieNaam}] ParentID1 niet gevonden, probeer Poging 2 met ParentID...`);
                toonStatus("Items laden (poging 2: met ParentID)...", true);

                try {
                    // --- Poging 2: Probeer met ParentID ---
                    const endpointAttempt2 = `_api/web/lists/getbytitle('${encodeURIComponent(lijstNaam)}')/items?$select=${selectVeldenAttempt2}&$orderby=${orderBy}&$top=${top}`;
                    console.log(`[${functieNaam}] Poging 2 API call: ${endpointAttempt2}`);
                    const dataAttempt2 = await haalGegevensOp(siteUrl, endpointAttempt2);

                    if (dataAttempt2 && dataAttempt2.d && Array.isArray(dataAttempt2.d.results)) {
                        items = dataAttempt2.d.results;
                        parentField = 'ParentID'; // Succes met ParentID
                        console.log(`[${functieNaam}] Poging 2 succesvol: ${items.length} items ontvangen met ParentID.`);
                    } else {
                        console.warn(`[${functieNaam}] Poging 2: Geen items gevonden of onverwacht dataformaat:`, dataAttempt2);
                        throw new Error("Poging 2 (met ParentID) leverde onverwacht dataformaat op.");
                    }
                } catch (errorAttempt2) {
                    console.error(`[${functieNaam}] Poging 2 (met ParentID) mislukte ook:`, errorAttempt2.message || errorAttempt2);
                    // Beide pogingen mislukt, toon gecombineerde fout
                    let errorMsg = `Fout bij laden: Veld ParentID1 niet gevonden & laden met ParentID mislukt: ${errorAttempt2.message || "Onbekende fout bij poging 2"}.`;
                    toonStatus(errorMsg, false, true);
                    tabelBody.innerHTML = `<tr><td colspan="8" class="px-3 py-3 text-center text-sm text-red-600 italic">${errorMsg}</td></tr>`;
                    document.getElementById('itemCount').textContent = 0;
                    huidigeLijstData.items = [];
                    huidigeLijstData.parentFieldUsed = null;
                    return; // Stop uitvoering hier
                }

            } else {
                // Poging 1 mislukte om een *andere* reden dan "ParentID1 niet gevonden"
                console.error(`[${functieNaam}] Fout bij ophalen items (Poging 1, andere reden):`, errorAttempt1.message || errorAttempt1);
                let errorMsg = "Fout bij laden items: " + (errorAttempt1.message || "Onbekende fout bij poging 1.");
                toonStatus(errorMsg, false, true);
                tabelBody.innerHTML = `<tr><td colspan="8" class="px-3 py-3 text-center text-sm text-red-600 italic">${errorMsg}</td></tr>`;
                document.getElementById('itemCount').textContent = 0;
                huidigeLijstData.items = [];
                huidigeLijstData.parentFieldUsed = null;
                return; // Stop uitvoering hier
            }
        }

        // --- Verwerking na succesvolle poging 1 OF 2 ---
        huidigeLijstData.items = items;
        huidigeLijstData.parentFieldUsed = parentField; // Sla op welk veld gebruikt is

        console.log(`[${functieNaam}] Succesvol data geladen gebruikmakend van veld: ${parentField}`);
        console.log(`[${functieNaam}] Voorbeeld item data:`, items.length > 0 ? items[0] : 'Geen items');

        renderItemsTabel(items); // Render met de opgehaalde items
        toonStatus(`${items.length} items geladen.`);
        document.getElementById('itemCount').textContent = items.length;
    }


    // *** GEWIJZIGD: Render Tabel Rijen (Gebruikt nu huidigeLijstData.parentFieldUsed) ***
    function renderItemsTabel(items) {
        const tabelBody = document.getElementById("itemsTable");
        tabelBody.innerHTML = "";

        if (!items || items.length === 0) {
            tabelBody.innerHTML = `<tr><td colspan="8" class="px-3 py-3 text-center text-sm text-gray-500 italic">Geen items gevonden in deze lijst.</td></tr>`;
            return;
        }

        const parentVeld = huidigeLijstData.parentFieldUsed; // 'ParentID1' of 'ParentID'
        console.log(`[renderItemsTabel] Rendering table using parent field: ${parentVeld}`);

        // 1. Build a map for quick lookup and identify root items
        const itemMap = new Map(items.map(item => [item.Id, { ...item, children: [] }]));
        const rootItems = [];

        items.forEach(item => {
            const mappedItem = itemMap.get(item.Id);
            let parentIdToUse = null;
            if (parentVeld === 'ParentID1') {
                parentIdToUse = item.ParentID1;
            } else if (parentVeld === 'ParentID') {
                // SharePoint ParentID is vaak een object {Id: number}, maar kan ook alleen een nummer zijn.
                parentIdToUse = (item.ParentID && typeof item.ParentID === 'object') ? item.ParentID.Id : item.ParentID;
            }
            // console.log(`[renderItemsTabel] Item ${item.Id} (${item.Title}): Using field ${parentVeld}, Raw value=${item[parentVeld]}, parentIdToUse=${parentIdToUse}`); // Debug log

            if (parentIdToUse && itemMap.has(parentIdToUse)) {
                const parent = itemMap.get(parentIdToUse);
                if (parent) {
                   parent.children.push(mappedItem);
                } else {
                    console.warn(`[renderItemsTabel] Parent item met ID ${parentIdToUse} niet gevonden in map voor item ${item.Id}. Item wordt root.`);
                    rootItems.push(mappedItem);
                }
            } else {
                rootItems.push(mappedItem);
            }
        });


        // Helper function to sort children by VolgordeID, then Title
        function sortChildren(item) {
            item.children.sort((a, b) => {
                const orderA = a.VolgordeID ?? Infinity;
                const orderB = b.VolgordeID ?? Infinity;
                if (orderA !== orderB) return orderA - orderB;
                return (a.Title || "").localeCompare(b.Title || "");
            });
            item.children.forEach(sortChildren);
        }

        // Sort root items and their descendants
        rootItems.sort((a, b) => {
            const orderA = a.VolgordeID ?? Infinity;
            const orderB = b.VolgordeID ?? Infinity;
            if (orderA !== orderB) return orderA - orderB;
            return (a.Title || "").localeCompare(b.Title || "");
        });
        rootItems.forEach(sortChildren);

        // 2. Recursive function to render rows
        function renderNode(item, level) {
            let urlValue = '';
            let urlDisplay = '';
            if (item.URL) {
                if (typeof item.URL === 'object' && item.URL.Url) { urlValue = item.URL.Url; }
                else if (typeof item.URL === 'string') { urlValue = item.URL.replace(/<[^>]*>/g, ''); }
            }
            const hasLink = urlValue !== '';
            urlDisplay = hasLink ? `<a href="${urlValue}" target="_blank" title="${urlValue}" class="text-blue-600 hover:underline break-all">${urlValue}</a>` : "<span class='text-gray-400'>-</span>";

            // Bepaal parent ID en naam gebaseerd op het gebruikte veld
            let parentIdForDisplay = null;
             if (parentVeld === 'ParentID1') {
                parentIdForDisplay = item.ParentID1;
            } else if (parentVeld === 'ParentID') {
                parentIdForDisplay = (item.ParentID && typeof item.ParentID === 'object') ? item.ParentID.Id : item.ParentID;
            }
            const parentItem = parentIdForDisplay ? itemMap.get(parentIdForDisplay) : null;
            const parentName = parentItem ? parentItem.Title : "<span class='text-gray-400'>-</span>";

            const row = document.createElement("tr");
            row.className = "hover:bg-gray-50 transition-colors duration-150";

            // Indentation en hierarchy icon
            const indentClass = level > 0 ? `indent-level-${level}` : '';
            const hierarchyIcon = level > 0 ? `<span class="material-icons hierarchy-icon">subdirectory_arrow_right</span>` : '';
            const titleCellClass = `px-3 py-3 whitespace-nowrap ${indentClass}`;
            const titleDivClass = `text-sm text-gray-800 ${level === 0 ? 'font-semibold' : ''}`;

            row.innerHTML = `
                <td class="px-3 py-3 text-sm text-gray-500 text-center" data-label="Volgorde">${item.VolgordeID ?? "<span class='text-gray-400'>-</span>"}</td>
                <td class="${titleCellClass}" data-label="Titel">
                    <div class="${titleDivClass}">${hierarchyIcon}${item.Title || "<span class='text-red-500 italic'>[Geen Titel]</span>"}</div>
                </td>
                <td class="px-3 py-3 text-sm text-gray-500 max-w-xs" data-label="URL" title="${urlValue || ''}"> ${urlDisplay} </td>
                <td class="px-3 py-3 text-sm text-gray-500 whitespace-nowrap" data-label="Onderliggend aan">${parentName}</td>
                <td class="py-2 text-center" data-label="Icoon">
                    <span class="material-icons text-gray-600 text-base align-middle">${item.Icon || "chevron_right"}</span>
                </td>
                <td class="px-3 py-3 text-sm text-gray-500 overflow-hidden text-ellipsis whitespace-nowrap" data-label="Icoon Naam" title="${item.Icon || ''}">
                    ${item.Icon || "<span class='text-gray-400'>-</span>"}
                </td>
                <td class="px-3 py-3 text-center whitespace-nowrap" data-label="Acties">
                    <div class="flex justify-center space-x-2">
                        <button class="text-brand-blue hover:text-brand-blue-dark p-1 rounded edit-item-btn focus:outline-none focus:ring-2 focus:ring-brand-blue/50" title="Bewerken" data-id="${item.Id}">
                            <span class="material-icons text-lg">edit</span>
                        </button>
                        <button class="text-red-500 hover:text-red-700 p-1 rounded delete-item-btn focus:outline-none focus:ring-2 focus:ring-red-500/50" title="Verwijderen" data-id="${item.Id}">
                            <span class="material-icons text-lg">delete</span>
                        </button>
                    </div>
                </td>
            `;
            tabelBody.appendChild(row);

            // Recursief renderen van kinderen
            if (item.children && item.children.length > 0) {
                item.children.forEach(child => renderNode(child, level + 1));
            }
        }

        // Start rendering from root items
        rootItems.forEach(item => renderNode(item, 0));

        // Koppel listeners aan dynamisch toegevoegde knoppen
        tabelBody.querySelectorAll(".edit-item-btn").forEach(btn => {
             const newBtn = btn.cloneNode(true);
             btn.parentNode.replaceChild(newBtn, btn);
             newBtn.addEventListener("click", () => openEditor(newBtn.getAttribute("data-id")));
        });
        tabelBody.querySelectorAll(".delete-item-btn").forEach(btn => {
             const newBtn = btn.cloneNode(true);
             btn.parentNode.replaceChild(newBtn, btn);
             newBtn.addEventListener("click", () => {
                 const itemId = parseInt(newBtn.getAttribute("data-id"));
                 const itemForConfirm = items.find(i => i.Id === itemId); // Gebruik oorspronkelijke lijst
                 if (itemForConfirm) { confirmDirectDelete(itemForConfirm); }
                 else { toonStatus(`Fout: Kon item met ID ${itemId} niet vinden voor verwijderen.`, false, true); }
             });
        });
         console.log("[renderItemsTabel] Event listeners voor bewerk/verwijder knoppen opnieuw gekoppeld.");
    }


    // *** GEWIJZIGD: Editor Modal Functies (Gebruikt nu huidigeLijstData.parentFieldUsed) ***
    function openEditor(itemId) {
        const functieNaam = "openEditor";
        console.log(`[${functieNaam}] Opening editor for item ID: ${itemId || 'nieuw'}`);
        const parentVeld = huidigeLijstData.parentFieldUsed; // Haal het gebruikte veld op

        const itemForm = document.getElementById("itemForm");
        if (itemForm) itemForm.reset();
        else console.error(`[${functieNaam}] Fout: Element met ID 'itemForm' niet gevonden.`);

        const itemIdInput = document.getElementById("itemId"); if(itemIdInput) itemIdInput.value = "";
        const previewIcon = document.getElementById("previewIcon"); if(previewIcon) previewIcon.textContent = "chevron_right";
        const iconPickerPanel = document.getElementById('iconPickerPanel'); if (iconPickerPanel) iconPickerPanel.classList.add('hidden');
        const iconSearch = document.getElementById('iconSearch'); if (iconSearch) iconSearch.value = '';

        populateParentDropdown(itemId); // Vul dropdown (gebruikt ook parentVeld intern)

        if (!itemId) {
            // Nieuw item
            const editorTitle = document.getElementById("editorTitle"); if(editorTitle) editorTitle.textContent = "Nieuw Item";
            const deleteBtn = document.getElementById("deleteItemBtn"); if(deleteBtn) deleteBtn.classList.add("hidden");
            const maxOrder = Math.max(-1, ...huidigeLijstData.items.map(i => i.VolgordeID).filter(id => typeof id === 'number'));
            const volgordeInput = document.getElementById("itemVolgordeID"); if(volgordeInput) volgordeInput.value = maxOrder + 10;
            const lastIcon = laadLaatstGeselecteerdIcoon();
            if (lastIcon) {
                const itemIconInput = document.getElementById("itemIcon"); if(itemIconInput) itemIconInput.value = lastIcon;
                if(previewIcon) previewIcon.textContent = lastIcon;
            }
        } else {
            // Bestaand item bewerken
            const editorTitle = document.getElementById("editorTitle"); if(editorTitle) editorTitle.textContent = "Item Bewerken";
            const deleteBtn = document.getElementById("deleteItemBtn"); if(deleteBtn) deleteBtn.classList.remove("hidden");
            const item = huidigeLijstData.items.find((i) => i.Id == itemId);
            if (!item) { toonStatus(`Fout: Item met ID ${itemId} niet gevonden.`, false, true); closeEditor(); return; }

            if(itemIdInput) itemIdInput.value = item.Id;
            const titleInput = document.getElementById("itemTitle"); if(titleInput) titleInput.value = item.Title || "";
            const volgordeInput = document.getElementById("itemVolgordeID"); if(volgordeInput) volgordeInput.value = item.VolgordeID ?? "";
            const itemIconInput = document.getElementById("itemIcon"); if(itemIconInput) itemIconInput.value = item.Icon || "";
            if(previewIcon) previewIcon.textContent = item.Icon || "chevron_right";
            if (item.Icon) slaLaatstGeselecteerdIcoonOp(item.Icon);

            let urlValue = '';
            if (item.URL) { if (typeof item.URL === 'object' && item.URL.Url) urlValue = item.URL.Url; else if (typeof item.URL === 'string') urlValue = item.URL.replace(/<[^>]*>/g, ''); }
            const urlInput = document.getElementById("itemURL"); if(urlInput) urlInput.value = urlValue;

            // Bepaal parent ID gebaseerd op het gebruikte veld
            let parentIdValue = "";
            if (parentVeld === 'ParentID1') {
                 parentIdValue = item.ParentID1 || "";
            } else if (parentVeld === 'ParentID') {
                 // Haal ID uit object of gebruik direct nummer
                 parentIdValue = (item.ParentID && typeof item.ParentID === 'object') ? item.ParentID.Id : (item.ParentID || "");
            }
            const parentSelect = document.getElementById("itemParentID");
            if(parentSelect) parentSelect.value = parentIdValue;
            console.log(`[${functieNaam}] Item ${itemId} geladen. Gebruikt veld: ${parentVeld}. Dropdown ingesteld op: ${parentIdValue}`);
        }

        const saveBtn = document.getElementById("saveItemBtn");
        if(saveBtn) { saveBtn.disabled = false; saveBtn.innerHTML = `<span class="material-icons text-sm mr-1">save</span> Opslaan`; }

        setupIconPicker(); // Herinitialiseer icon picker listeners
        const editorModal = document.getElementById("editorModal");
        if(editorModal) editorModal.classList.remove("hidden");
        else console.error(`[${functieNaam}] Fout: Element met ID 'editorModal' niet gevonden.`);
    }
    function closeEditor() {
        const editorModal = document.getElementById("editorModal");
        if(editorModal) editorModal.classList.add("hidden");
        else console.warn("[closeEditor] Element 'editorModal' niet gevonden bij sluiten.");
    }

    // *** GEWIJZIGD: Populate Parent Dropdown (Gebruikt nu huidigeLijstData.parentFieldUsed) ***
    function populateParentDropdown(huidigItemId) {
        const parentSelect = document.getElementById("itemParentID");
        if (!parentSelect) { console.error("[populateParentDropdown] Element 'itemParentID' niet gevonden."); return; }
        parentSelect.innerHTML = `<option value="">Geen (hoofdniveau)</option>`;

        const items = huidigeLijstData.items;
        const parentVeld = huidigeLijstData.parentFieldUsed; // Haal gebruikte veld op
        const itemMap = new Map(items.map(i => [i.Id, i]));
        const descendants = new Set();

        function findDescendants(id) {
            if (!id) return;
            const numId = parseInt(id);
            if (descendants.has(numId)) return;
            descendants.add(numId);

            items.forEach(item => {
                // Bepaal parent ID gebaseerd op het gebruikte veld
                let parentIdToUse = null;
                 if (parentVeld === 'ParentID1') {
                     parentIdToUse = item.ParentID1;
                 } else if (parentVeld === 'ParentID') {
                     parentIdToUse = (item.ParentID && typeof item.ParentID === 'object') ? item.ParentID.Id : item.ParentID;
                 }

                if (parentIdToUse == id) { // Vergelijk met de ID van de huidige node
                    findDescendants(item.Id);
                }
            });
        }

        if (huidigItemId) {
            findDescendants(huidigItemId); // Vind afstammelingen
        }

        const sortedItems = [...items].sort((a, b) => (a.Title || "").localeCompare(b.Title || ""));

        for (const it of sortedItems) {
            if (it.Id != huidigItemId && !descendants.has(it.Id)) {
                const option = document.createElement("option");
                option.value = it.Id;
                option.textContent = it.Title || `[ID: ${it.Id}]`;
                parentSelect.appendChild(option);
            }
        }
        console.log(`[populateParentDropdown] Dropdown gevuld met veld ${parentVeld}, ${descendants.size} afstammelingen uitgesloten voor item ${huidigItemId || 'nieuw'}.`);
    }


    // Item Opslaan (Onveranderd: blijft ParentID1 gebruiken voor schrijven)
    async function saveItem() {
      const functieNaam = "saveItem"; console.log(`[${functieNaam}] Poging tot opslaan gestart.`);
      const { lijstNaam, siteUrl, lijstItemEntityType, guid } = huidigeLijstData;
      if (!lijstNaam || !siteUrl || !lijstItemEntityType) { const ontbrekend = !lijstNaam ? 'lijstNaam' : !siteUrl ? 'siteUrl' : 'lijstItemEntityType'; console.error(`[${functieNaam}] Fout: Essentiële data ontbreekt (${ontbrekend}). Kan niet opslaan.`); toonStatus(`Fout: Kan niet opslaan omdat ${ontbrekend} ontbreekt. Herlaad de pagina.`, false, true); return; }
      if (typeof voegItemToe !== 'function' || typeof werkItemBij !== 'function') { console.error(`[${functieNaam}] Fout: Functie 'voegItemToe' of 'werkItemBij' is niet gedefinieerd.`); toonStatus("Fout: Opslaan functies niet gevonden. Opslaan geannuleerd.", false, true); return; }
      const icon = document.getElementById("itemIcon").value.trim(); if (icon) slaLaatstGeselecteerdIcoonOp(icon); const itemIdValue = document.getElementById("itemId").value.trim(); const itemId = itemIdValue ? parseInt(itemIdValue) : null; const isNieuw = !itemId;
      const itemData = { Title: document.getElementById("itemTitle").value.trim() || "Naamloos Item", Icon: icon || null };
      const volgordeValue = document.getElementById("itemVolgordeID").value.trim();
      itemData.VolgordeID = volgordeValue === "" ? null : parseInt(volgordeValue);
      const parentIdValue = document.getElementById("itemParentID").value;
      // === BLIJFT ParentID1 gebruiken voor de payload ===
      itemData.ParentID1 = parentIdValue ? parseInt(parentIdValue) : null;
      const urlValue = document.getElementById("itemURL").value.trim();

      const saveBtn = document.getElementById("saveItemBtn"); saveBtn.disabled = true; saveBtn.innerHTML = `<span class="material-icons text-sm spin mr-1">refresh</span> Opslaan...`;
      function resetSaveButtonState() { saveBtn.disabled = false; saveBtn.innerHTML = `<span class="material-icons text-sm mr-1">save</span> Opslaan`; }
      function handleSaveSuccess(message) { console.log(`[${functieNaam}] Succes: ${message}`); closeEditor(); toonStatus(message); laadLijstData(); resetSaveButtonState(); try { if (window.opener && !window.opener.closed && window.opener.location?.href.includes("navigation-implementation.aspx")) { window.opener.location.reload(); } } catch (e) { console.warn(`[${functieNaam}] Kon opener niet vernieuwen:`, e); } }
      function handleSaveError(error, pogingBeschrijving) { console.error(`[${functieNaam}] Fout (${pogingBeschrijving}):`, error); let msg = `Fout bij opslaan: ${error.message || "Onbekende fout."}`; if (typeof error.message === 'string' && error.message?.includes("foutData")) { msg = `Fout bij opslaan: ${error.message}`; } toonStatus(msg, false, true); resetSaveButtonState(); }

      try {
        console.log(`[${functieNaam}] Controleren URL veldtype...`); const veldInfo = await checkVeldType(guid, 'URL');
        let payload = { ...itemData, __metadata: { 'type': lijstItemEntityType } };

        if (veldInfo.isUrlType) { console.log(`[${functieNaam}] URL veld formatteren als FieldUrlValue.`); payload.URL = urlValue ? { __metadata: { type: "SP.FieldUrlValue" }, Url: urlValue, Description: payload.Title } : null; }
        else { console.log(`[${functieNaam}] URL veld formatteren als tekst/null.`); payload.URL = urlValue || null; }

        // Zorg dat ParentID1 correct is (null of getal) - Dit is de waarde uit de dropdown
        if ('ParentID1' in payload && payload.ParentID1 === null) {
             payload.ParentID1 = null;
             console.log(`[${functieNaam}] ParentID1 wordt expliciet null verzonden.`);
        } else if (payload.ParentID1) {
            console.log(`[${functieNaam}] ParentID1 wordt verzonden met waarde: ${payload.ParentID1}`);
        } else {
             console.log(`[${functieNaam}] ParentID1 is niet aanwezig of leeg in payload, wordt null.`);
             payload.ParentID1 = null;
        }

        // LET OP: We sturen *geen* ParentID mee in de payload, alleen ParentID1.
        console.log(`[${functieNaam}] Payload voor opslaan:`, JSON.stringify(payload));

        let resultaat;
        if (isNieuw) {
            console.log(`[${functieNaam}] Functie voegItemToe aanroepen...`);
            resultaat = await voegItemToe(siteUrl, lijstNaam, payload, lijstItemEntityType);
        } else {
            console.log(`[${functieNaam}] Functie werkItemBij aanroepen voor ID ${itemId}...`);
            resultaat = await werkItemBij(siteUrl, lijstNaam, itemId, payload, lijstItemEntityType);
            resultaat = true; // werkItemBij geeft geen data terug bij succes (204)
        }

        if (resultaat) { handleSaveSuccess(`Item succesvol ${isNieuw ? "aangemaakt" : "bijgewerkt"}.`); }
        else if (!isNieuw) { console.warn(`[${functieNaam}] werkItemBij leek succesvol maar resultaat is niet 'true'.`); handleSaveSuccess(`Item succesvol bijgewerkt (status 204 ontvangen).`); }
        else { throw new Error(`Opslaan nieuw item mislukt (voegItemToe retourneerde geen data).`); }
      } catch (error) { handleSaveError(error, `globale functie ${isNieuw ? 'voegItemToe' : 'werkItemBij'}`); }
    }


    // Item Verwijderen Functies (onveranderd)
    function confirmDelete() {
        const confirmModal = document.getElementById("confirmModal");
        if(!confirmModal) { console.error("[confirmDelete] Element 'confirmModal' niet gevonden."); return; }
        const itemTitleElement = document.getElementById("itemTitle");
        const itemTitle = itemTitleElement ? itemTitleElement.value : "dit item";
        const confirmMsgElement = document.getElementById("confirmMessage");
        const confirmTitleElement = document.getElementById("confirmTitle");
        if(confirmTitleElement) confirmTitleElement.textContent = "Item verwijderen";
        if(confirmMsgElement) confirmMsgElement.textContent = `Weet je zeker dat je "${itemTitle}" wilt verwijderen? Onderliggende items komen op het hoofdniveau te staan.`;
        confirmModal.classList.remove("hidden");
    }
    function confirmDirectDelete(item) {
        const confirmModal = document.getElementById("confirmModal");
        if(!confirmModal) { console.error("[confirmDirectDelete] Element 'confirmModal' niet gevonden."); return; }
        if (!item) return;
        const confirmTitleElement = document.getElementById("confirmTitle");
        const confirmMsgElement = document.getElementById("confirmMessage");
        const confirmOkBtn = document.getElementById("confirmOkBtn");

        if(confirmTitleElement) confirmTitleElement.textContent = "Item verwijderen";
        if(confirmMsgElement) confirmMsgElement.textContent = `Weet je zeker dat je "${item.Title || 'dit item'}" wilt verwijderen? Onderliggende items komen op het hoofdniveau te staan.`;
        if(confirmOkBtn) confirmOkBtn.setAttribute("data-delete-id", item.Id);
        confirmModal.classList.remove("hidden");
    }

    // Daadwerkelijk Verwijderen (onveranderd)
    async function actuallyDeleteItem() {
        const functieNaam = "actuallyDeleteItem"; console.log(`[${functieNaam}] Poging tot verwijderen gestart.`);
        const { lijstNaam, siteUrl } = huidigeLijstData;
        if (!lijstNaam || !siteUrl) { const ontbrekend = !lijstNaam ? 'lijstNaam' : 'siteUrl'; console.error(`[${functieNaam}] Fout: Essentiële data ontbreekt (${ontbrekend}). Kan niet verwijderen.`); toonStatus(`Fout: Kan niet verwijderen omdat ${ontbrekend} ontbreekt. Herlaad de pagina.`, false, true); hideConfirmModal(); return; }
        if (typeof verwijderItem !== 'function') { console.error(`[${functieNaam}] Fout: Functie 'verwijderItem' is niet gedefinieerd.`); toonStatus("Fout: Verwijder functie niet gevonden. Verwijderen geannuleerd.", false, true); hideConfirmModal(); return; }
        const confirmOkBtn = document.getElementById("confirmOkBtn"); const directDeleteId = confirmOkBtn ? confirmOkBtn.getAttribute("data-delete-id") : null;
        const itemIdInput = document.getElementById("itemId");
        const itemIdValue = directDeleteId || (itemIdInput ? itemIdInput.value.trim() : null);

        if (!itemIdValue) { console.error(`[${functieNaam}] Fout: Geen item ID gevonden.`); toonStatus("Fout: Geen item ID gevonden om te verwijderen.", false, true); hideConfirmModal(); return; }
        const itemId = parseInt(itemIdValue); toonStatus("Item verwijderen...", true);
        function handleDeleteSuccess(deletedItemId) { console.log(`[${functieNaam}] Item ${deletedItemId} succesvol verwijderd.`); closeEditor(); hideConfirmModal(); toonStatus("Item succesvol verwijderd."); laadLijstData(); try { if (window.opener && !window.opener.closed && window.opener.location?.href.includes("navigation-implementation.aspx")) { window.opener.location.reload(); } } catch (e) { console.warn(`[${functieNaam}] Kon opener niet vernieuwen:`, e); } }
        function handleDeleteError(error) { console.error(`[${functieNaam}] Fout bij verwijderen:`, error); let msg = `Fout bij verwijderen: ${error.message || "Onbekende fout."}`; if (typeof error.message === 'string' && error.message?.includes("foutData")) { msg = `Fout bij verwijderen: ${error.message}`; } toonStatus(msg, false, true); hideConfirmModal(); }
        try { console.log(`[${functieNaam}] Globale functie verwijderItem aanroepen voor ID ${itemId} in lijst ${lijstNaam}...`); await verwijderItem(siteUrl, lijstNaam, itemId); handleDeleteSuccess(itemId); }
        catch (error) { handleDeleteError(error); }
        finally { if(confirmOkBtn) confirmOkBtn.removeAttribute("data-delete-id"); }
    }

    // Verberg Bevestigings Modal (onveranderd)
    function hideConfirmModal() {
        const confirmModal = document.getElementById("confirmModal"); if(confirmModal) confirmModal.classList.add("hidden");
        else console.warn("[hideConfirmModal] Element 'confirmModal' niet gevonden.");
        const confirmOkBtn = document.getElementById("confirmOkBtn"); if(confirmOkBtn) confirmOkBtn.removeAttribute("data-delete-id");
    }

    // Status Weergave (onveranderd)
    function toonStatus(msg, isLoading = false, isError = false) { const statusMessage = document.getElementById("statusMessage"); const statusBar = document.getElementById("statusBar"); if (!statusBar || !statusMessage) { console.error("Status bar or message element not found."); return; } const iconSpan = statusBar.querySelector('.material-icons:first-child'); if (!iconSpan) { console.error("Status icon not found."); return; } statusBar.classList.remove("bg-red-100", "border-red-300", "text-red-700", "bg-green-100", "border-green-300", "text-green-700"); iconSpan.classList.remove("text-red-500", "text-green-500", "spin"); statusBar.classList.add("bg-white", "border-gray-200"); statusMessage.classList.remove("text-red-700", "text-green-700"); statusMessage.classList.add("text-gray-800"); iconSpan.classList.add("text-gray-500"); if (isLoading) { iconSpan.textContent = 'refresh'; iconSpan.classList.add("spin"); statusMessage.textContent = msg; } else { statusMessage.textContent = msg; if (isError) { statusBar.classList.add("bg-red-100", "border-red-300"); statusMessage.classList.add("text-red-700"); iconSpan.textContent = 'error'; iconSpan.classList.remove("text-gray-500"); iconSpan.classList.add("text-red-500"); } else if (msg.toLowerCase().includes("succesvol") || msg.toLowerCase().includes("geladen") || msg.toLowerCase().includes("geïnitialiseerd") || msg.toLowerCase().includes("klaar") || msg.toLowerCase().includes("voltooid")) { iconSpan.textContent = 'check_circle'; iconSpan.classList.remove("text-gray-500"); iconSpan.classList.add("text-green-500"); if (!msg.toLowerCase().includes("klaar") && !msg.toLowerCase().includes("voltooid") && !msg.includes("geladen")) { setTimeout(() => { const currentStatus = document.getElementById("statusMessage")?.textContent; if (currentStatus === msg) { toonStatus("Klaar."); } }, 3000); } } else { iconSpan.textContent = 'info'; } } }

  </script>
</body>
</html>