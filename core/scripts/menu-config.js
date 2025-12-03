/**
 * Menu Configuration Module
 * 
 * Purpose: Defines the default configuration and behavior settings for the menu system.
 * This module provides centralized configuration that can be overridden by individual menu instances.
 * 
 * Features:
 * - Layer configuration (depth of menu)
 * - Animation settings
 * - Behavior options (hover vs click)
 * - Accessibility settings
 */

(function(global) {
    'use strict';

    /**
     * Default menu configuration
     * These settings can be overridden when initializing a menu instance
     */
    const DEFAULT_CONFIG = {
        // Menu Structure
        layers: 3,                          // Number of navigation layers (1-3)
        
        // Behavior Settings
        triggerType: 'hover',               // 'hover' or 'click' to open submenus
        closeOnOutsideClick: true,          // Close menus when clicking outside
        closeOnEscape: true,                // Close menus when pressing Escape
        keepOpenOnHover: true,              // Keep submenus open while hovering
        hoverDelay: 150,                    // Delay in ms before showing submenu on hover
        closeDelay: 300,                    // Delay in ms before hiding submenu on mouse leave
        
        // Animation Settings
        animated: true,                     // Enable/disable animations
        animationDuration: 200,             // Animation duration in ms
        
        // Accessibility Settings
        enableKeyboardNavigation: true,     // Arrow key navigation
        enableAriaAttributes: true,         // ARIA attributes for screen readers
        focusTrap: false,                   // Trap focus within open menu
        
        // Mobile Settings
        mobileBreakpoint: 768,              // Breakpoint for mobile menu
        mobileToggleSelector: '.sp-menu__toggle',
        
        // Data Settings
        cacheData: true,                    // Cache retrieved menu data
        cacheDuration: 300000,              // Cache duration in ms (5 minutes)
        
        // SharePoint Specific Settings
        sharePoint: {
            enabled: false,                 // Enable SharePoint integration
            listName: '',                   // Name of the SharePoint list
            siteUrl: '',                    // SharePoint site URL
            camlQuery: '',                  // Optional CAML query for filtering
            selectFields: ['Title', 'Url', 'ParentId', 'Order', 'OpenInNewTab'],
            orderBy: 'Order',               // Field to order by
            ascending: true                 // Sort direction
        },
        
        // Custom Data Source
        dataSource: {
            type: 'static',                 // 'static', 'json', 'sharepoint', 'api'
            url: '',                        // URL for json or api data source
            method: 'GET',                  // HTTP method for api
            headers: {},                    // Custom headers for api
            transformResponse: null         // Function to transform api response
        },
        
        // Callbacks
        onMenuInit: null,                   // Called when menu is initialized
        onMenuOpen: null,                   // Called when a submenu opens
        onMenuClose: null,                  // Called when a submenu closes
        onItemClick: null,                  // Called when a menu item is clicked
        onDataLoad: null,                   // Called when menu data is loaded
        onError: null                       // Called when an error occurs
    };

    /**
     * MenuConfig class for managing configuration
     */
    class MenuConfig {
        constructor(options = {}) {
            this.config = this.mergeConfig(DEFAULT_CONFIG, options);
            this.validateConfig();
        }

        /**
         * Deep merge configuration objects
         * @param {Object} defaults - Default configuration
         * @param {Object} overrides - Override values
         * @returns {Object} Merged configuration
         */
        mergeConfig(defaults, overrides) {
            const result = { ...defaults };
            
            for (const key in overrides) {
                if (overrides.hasOwnProperty(key)) {
                    if (typeof overrides[key] === 'object' && 
                        overrides[key] !== null && 
                        !Array.isArray(overrides[key]) &&
                        typeof defaults[key] === 'object') {
                        result[key] = this.mergeConfig(defaults[key], overrides[key]);
                    } else {
                        result[key] = overrides[key];
                    }
                }
            }
            
            return result;
        }

        /**
         * Validate configuration values
         * @throws {Error} If configuration is invalid
         */
        validateConfig() {
            const errors = [];

            // Validate layers
            if (this.config.layers < 1 || this.config.layers > 3) {
                errors.push('layers must be between 1 and 3');
            }

            // Validate trigger type
            if (!['hover', 'click'].includes(this.config.triggerType)) {
                errors.push('triggerType must be "hover" or "click"');
            }

            // Validate data source type
            const validDataTypes = ['static', 'json', 'sharepoint', 'api'];
            if (!validDataTypes.includes(this.config.dataSource.type)) {
                errors.push(`dataSource.type must be one of: ${validDataTypes.join(', ')}`);
            }

            // Validate delays
            if (this.config.hoverDelay < 0) {
                errors.push('hoverDelay must be a positive number');
            }
            if (this.config.closeDelay < 0) {
                errors.push('closeDelay must be a positive number');
            }

            if (errors.length > 0) {
                console.error('Menu Configuration Errors:', errors);
                throw new Error(`Invalid menu configuration: ${errors.join('; ')}`);
            }
        }

        /**
         * Get a configuration value
         * @param {string} key - Configuration key (supports dot notation)
         * @returns {*} Configuration value
         */
        get(key) {
            const keys = key.split('.');
            let value = this.config;
            
            for (const k of keys) {
                if (value && typeof value === 'object' && k in value) {
                    value = value[k];
                } else {
                    return undefined;
                }
            }
            
            return value;
        }

        /**
         * Set a configuration value
         * @param {string} key - Configuration key (supports dot notation)
         * @param {*} value - New value
         */
        set(key, value) {
            const keys = key.split('.');
            let obj = this.config;
            
            for (let i = 0; i < keys.length - 1; i++) {
                if (!(keys[i] in obj)) {
                    obj[keys[i]] = {};
                }
                obj = obj[keys[i]];
            }
            
            obj[keys[keys.length - 1]] = value;
        }

        /**
         * Get the full configuration object
         * @returns {Object} Full configuration
         */
        getAll() {
            return { ...this.config };
        }

        /**
         * Check if SharePoint integration is enabled
         * @returns {boolean}
         */
        isSharePointEnabled() {
            return this.config.sharePoint.enabled && 
                   this.config.sharePoint.listName && 
                   this.config.sharePoint.siteUrl;
        }

        /**
         * Get CSS variable overrides based on configuration
         * @returns {Object} CSS variable mappings
         */
        getCssVariables() {
            return {
                '--menu-transition': `${this.config.animationDuration}ms ease`
            };
        }
    }

    // Export for different module systems
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = { MenuConfig, DEFAULT_CONFIG };
    } else {
        global.SPMenu = global.SPMenu || {};
        global.SPMenu.MenuConfig = MenuConfig;
        global.SPMenu.DEFAULT_CONFIG = DEFAULT_CONFIG;
    }

})(typeof window !== 'undefined' ? window : this);
