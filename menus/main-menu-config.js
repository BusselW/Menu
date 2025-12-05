/**
 * Main Menu Configuration
 * 
 * Purpose: Defines the specific configuration for the main navigation menu.
 * This file specifies where to load menu data from and any menu-specific overrides.
 * 
 * Usage: Include this file in your HTML page along with the core scripts.
 */

(function(global) {
    'use strict';

    /**
     * Main Menu Data Source Configuration
     * 
     * Options for data source:
     * 1. Static data (inline data defined here)
     * 2. JSON file (external JSON file)
     * 3. SharePoint list (SharePoint REST API)
     * 4. API endpoint (custom REST API)
     */
    const MAIN_MENU_CONFIG = {
        // Data source configuration
        dataSource: {
            type: 'static',  // Change to 'json', 'sharepoint', or 'api' as needed
            
            // Static data - used when type is 'static'
            data: [
                {
                    id: 'home',
                    title: 'Home',
                    url: '/',
                    icon: null,
                    children: []
                },
                {
                    id: 'departments',
                    title: 'Departments',
                    url: '#',
                    children: [
                        {
                            id: 'hr',
                            title: 'Human Resources',
                            url: '/departments/hr',
                            children: [
                                { id: 'hr-policies', title: 'Policies', url: '/departments/hr/policies' },
                                { id: 'hr-benefits', title: 'Benefits', url: '/departments/hr/benefits' },
                                { id: 'hr-training', title: 'Training', url: '/departments/hr/training' }
                            ]
                        },
                        {
                            id: 'it',
                            title: 'Information Technology',
                            url: '/departments/it',
                            children: [
                                { id: 'it-helpdesk', title: 'Help Desk', url: '/departments/it/helpdesk' },
                                { id: 'it-software', title: 'Software Catalog', url: '/departments/it/software' },
                                { id: 'it-security', title: 'Security', url: '/departments/it/security' }
                            ]
                        },
                        {
                            id: 'finance',
                            title: 'Finance',
                            url: '/departments/finance',
                            children: [
                                { id: 'fin-reports', title: 'Reports', url: '/departments/finance/reports' },
                                { id: 'fin-budget', title: 'Budget', url: '/departments/finance/budget' }
                            ]
                        },
                        {
                            id: 'marketing',
                            title: 'Marketing',
                            url: '/departments/marketing',
                            children: []
                        }
                    ]
                },
                {
                    id: 'resources',
                    title: 'Resources',
                    url: '#',
                    children: [
                        {
                            id: 'documents',
                            title: 'Document Library',
                            url: '/resources/documents',
                            children: [
                                { id: 'doc-forms', title: 'Forms', url: '/resources/documents/forms' },
                                { id: 'doc-templates', title: 'Templates', url: '/resources/documents/templates' },
                                { id: 'doc-policies', title: 'Policies', url: '/resources/documents/policies' }
                            ]
                        },
                        {
                            id: 'tools',
                            title: 'Tools & Apps',
                            url: '/resources/tools',
                            children: [
                                { id: 'tools-office', title: 'Office 365', url: 'https://office.com', openInNewTab: true },
                                { id: 'tools-sharepoint', title: 'SharePoint', url: '/resources/tools/sharepoint' }
                            ]
                        },
                        {
                            id: 'calendar',
                            title: 'Company Calendar',
                            url: '/resources/calendar',
                            children: []
                        }
                    ]
                },
                {
                    id: 'news',
                    title: 'News',
                    url: '/news',
                    children: [
                        { id: 'news-announcements', title: 'Announcements', url: '/news/announcements' },
                        { id: 'news-events', title: 'Events', url: '/news/events' },
                        { id: 'news-blog', title: 'Company Blog', url: '/news/blog' }
                    ]
                },
                {
                    id: 'contact',
                    title: 'Contact Us',
                    url: '/contact',
                    children: []
                }
            ],
            
            // JSON file URL - used when type is 'json'
            // url: '/data/main-menu.json',
            
            // API configuration - used when type is 'api'
            // url: 'https://api.example.com/menu',
            // method: 'GET',
            // headers: { 'Authorization': 'Bearer token' }
        },

        // SharePoint configuration - used when dataSource.type is 'sharepoint'
        sharePoint: {
            enabled: false,
            siteUrl: '',           // e.g., 'https://yourtenant.sharepoint.com/sites/yoursite'
            listName: 'MainMenu',  // Name of the SharePoint list
            selectFields: ['Title', 'Url', 'ParentId', 'Order', 'OpenInNewTab'],
            orderBy: 'Order',
            ascending: true
        },

        // Behavior overrides
        triggerType: 'hover',      // 'hover' or 'click'
        layers: 3,                 // Number of menu layers (1-3)
        
        // Timing
        hoverDelay: 100,           // Delay before opening submenu on hover
        closeDelay: 250,           // Delay before closing submenu on mouse leave
        
        // Caching
        cacheData: true,
        cacheDuration: 300000,     // 5 minutes
        
        // Callbacks (optional)
        onMenuInit: function(menu) {
            console.log('Main menu initialized');
        },
        onMenuOpen: function(data) {
            // console.log('Submenu opened:', data);
        },
        onMenuClose: function(data) {
            // console.log('Submenu closed:', data);
        },
        onItemClick: function(data) {
            // console.log('Item clicked:', data);
        },
        onDataLoad: function(data) {
            console.log('Menu data loaded:', data.length, 'items');
        },
        onError: function(error) {
            console.error('Menu error:', error);
        }
    };

    // Export configuration
    global.MainMenuConfig = MAIN_MENU_CONFIG;

})(typeof window !== 'undefined' ? window : this);
