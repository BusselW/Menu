# SharePoint 2019 Modular Menu System

A modular, 3-layer navigation menu system designed for SharePoint Server 2019. Built following the DRY (Don't Repeat Yourself) principle with a focus on separation of concerns.

## Project Structure

```
Menu/
├── core/                           # Central shared modules
│   ├── styles/
│   │   └── menu.css               # Menu appearance and styling
│   └── scripts/
│       ├── menu-config.js         # Default configuration and behavior settings
│       ├── data-retrieval.js      # Data fetching utilities (static, JSON, API, SharePoint)
│       └── menu-engine.js         # Core menu functionality and rendering
├── menus/                          # Individual menu instances
│   ├── main-menu.html             # Example main navigation menu
│   └── main-menu-config.js        # Main menu data source configuration
└── README.md
```

## Module Descriptions

### Core Modules

| Module | Purpose |
|--------|---------|
| `menu.css` | Defines the visual appearance with CSS variables for theming. Supports 3-layer navigation with responsive design. |
| `menu-config.js` | Provides default configuration including layers, animation, accessibility, and SharePoint integration settings. |
| `data-retrieval.js` | Handles data fetching from multiple sources: static data, JSON files, REST APIs, and SharePoint lists. Includes caching. |
| `menu-engine.js` | Main orchestrator that renders the menu, handles events, and manages state. |

### Menu Instances

Each menu instance consists of:
1. **HTML file** - Loads core scripts and defines the menu container
2. **Config file** - Specifies data source and any setting overrides

## Quick Start

### 1. Basic Setup

```html
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="core/styles/menu.css">
</head>
<body>
    <div id="my-menu"></div>
    
    <!-- Load core scripts in order -->
    <script src="core/scripts/menu-config.js"></script>
    <script src="core/scripts/data-retrieval.js"></script>
    <script src="core/scripts/menu-engine.js"></script>
    
    <script>
        var menu = new SPMenu.MenuEngine('#my-menu', {
            dataSource: {
                type: 'static',
                data: [
                    { id: '1', title: 'Home', url: '/' },
                    { id: '2', title: 'About', url: '/about' }
                ]
            }
        });
        menu.init();
    </script>
</body>
</html>
```

### 2. Using SharePoint List

```javascript
var menu = new SPMenu.MenuEngine('#my-menu', {
    dataSource: { type: 'sharepoint' },
    sharePoint: {
        enabled: true,
        siteUrl: 'https://yourtenant.sharepoint.com/sites/yoursite',
        listName: 'NavigationMenu',
        selectFields: ['Title', 'Url', 'ParentId', 'Order', 'OpenInNewTab'],
        orderBy: 'Order',
        ascending: true
    }
});
menu.init();
```

### 3. Using JSON File

```javascript
var menu = new SPMenu.MenuEngine('#my-menu', {
    dataSource: {
        type: 'json',
        url: '/data/menu-data.json'
    }
});
menu.init();
```

### 4. Using REST API

```javascript
var menu = new SPMenu.MenuEngine('#my-menu', {
    dataSource: {
        type: 'api',
        url: 'https://api.example.com/menu',
        method: 'GET',
        headers: { 'Authorization': 'Bearer token' }
    }
});
menu.init();
```

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `layers` | number | 3 | Number of navigation layers (1-3) |
| `triggerType` | string | 'hover' | How submenus open: 'hover' or 'click' |
| `hoverDelay` | number | 150 | Delay (ms) before showing submenu on hover |
| `closeDelay` | number | 300 | Delay (ms) before hiding submenu on mouse leave |
| `closeOnOutsideClick` | boolean | true | Close menus when clicking outside |
| `closeOnEscape` | boolean | true | Close menus when pressing Escape |
| `enableKeyboardNavigation` | boolean | true | Enable arrow key navigation |
| `mobileBreakpoint` | number | 768 | Breakpoint (px) for mobile menu |
| `cacheData` | boolean | true | Cache retrieved menu data |
| `cacheDuration` | number | 300000 | Cache duration (ms) |

## Data Structure

Menu items should follow this structure:

```javascript
{
    id: 'unique-id',           // Unique identifier
    title: 'Menu Item',        // Display text
    url: '/path/to/page',      // Link URL
    openInNewTab: false,       // Open in new tab
    icon: 'icon-class',        // Optional icon class
    cssClass: 'custom-class',  // Optional CSS class
    children: []               // Array of child items
}
```

## CSS Customization

Override CSS variables to customize the appearance:

```css
.sp-menu-container {
    --menu-primary-bg: #1a5276;
    --menu-primary-text: #ffffff;
    --menu-primary-hover: #154360;
    --menu-font-family: Arial, sans-serif;
    --menu-height: 56px;
    --menu-border-radius: 0;
}
```

## Keyboard Navigation

| Key | Action |
|-----|--------|
| `←` / `→` | Navigate between items |
| `↓` | Open submenu / Move down |
| `↑` | Move up in submenu |
| `Enter` / `Space` | Activate item or toggle submenu |
| `Escape` | Close all submenus |
| `Home` / `End` | Go to first/last item |

## Callbacks

```javascript
var menu = new SPMenu.MenuEngine('#my-menu', {
    onMenuInit: function(menu) { /* Menu initialized */ },
    onMenuOpen: function(data) { /* Submenu opened */ },
    onMenuClose: function(data) { /* Submenu closed */ },
    onItemClick: function(data) { /* Item clicked */ },
    onDataLoad: function(data) { /* Data loaded */ },
    onError: function(error) { /* Error occurred */ }
});
```

## API Methods

| Method | Description |
|--------|-------------|
| `init()` | Initialize the menu |
| `refresh()` | Refresh data and re-render |
| `destroy()` | Remove menu and cleanup |
| `updateConfig(options)` | Update configuration |
| `closeAllSubmenus()` | Close all open submenus |

## Browser Support

- Microsoft Edge
- Google Chrome
- Mozilla Firefox
- Safari
- Internet Explorer 11 (SharePoint 2019 compatibility)

## Creating a New Menu Instance

1. Copy `menus/main-menu.html` to a new file (e.g., `menus/footer-menu.html`)
2. Copy `menus/main-menu-config.js` to a new file (e.g., `menus/footer-menu-config.js`)
3. Update the config file with your data source
4. Update the HTML file to reference your config file
5. Customize styles using CSS variables if needed

## SharePoint List Structure

If using SharePoint as a data source, create a list with these columns:

| Column | Type | Description |
|--------|------|-------------|
| Title | Single line of text | Menu item display text |
| Url | Single line of text | Link URL |
| ParentId | Number | ID of parent item (null for root items) |
| Order | Number | Sort order |
| OpenInNewTab | Yes/No | Open link in new tab |

## License

MIT License
