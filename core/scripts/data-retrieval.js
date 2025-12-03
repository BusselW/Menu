/**
 * Data Retrieval Module
 * 
 * Purpose: Handles all data fetching operations for the menu system.
 * Supports multiple data sources: static data, JSON files, REST APIs, and SharePoint lists.
 * 
 * Features:
 * - Multiple data source support
 * - Caching mechanism
 * - Error handling
 * - Data transformation
 * - SharePoint REST API integration
 */

(function(global) {
    'use strict';

    /**
     * Cache implementation for menu data
     */
    class DataCache {
        constructor(duration = 300000) {
            this.cache = new Map();
            this.duration = duration;
        }

        /**
         * Get cached data
         * @param {string} key - Cache key
         * @returns {*|null} Cached data or null if expired/not found
         */
        get(key) {
            const item = this.cache.get(key);
            if (!item) return null;
            
            if (Date.now() > item.expiry) {
                this.cache.delete(key);
                return null;
            }
            
            return item.data;
        }

        /**
         * Set cache data
         * @param {string} key - Cache key
         * @param {*} data - Data to cache
         * @param {number} duration - Optional custom duration
         */
        set(key, data, duration) {
            this.cache.set(key, {
                data: data,
                expiry: Date.now() + (duration || this.duration)
            });
        }

        /**
         * Clear all cache
         */
        clear() {
            this.cache.clear();
        }

        /**
         * Clear specific cache entry
         * @param {string} key - Cache key to clear
         */
        delete(key) {
            this.cache.delete(key);
        }
    }

    /**
     * DataRetrieval class for fetching menu data
     */
    class DataRetrieval {
        constructor(config) {
            this.config = config;
            this.cache = new DataCache(config.get('cacheDuration'));
        }

        /**
         * Main method to retrieve menu data based on configuration
         * @param {Object} options - Override options for this request
         * @returns {Promise<Array>} Menu data array
         */
        async getData(options = {}) {
            const dataSourceConfig = {
                ...this.config.get('dataSource'),
                ...options
            };

            const cacheKey = this.getCacheKey(dataSourceConfig);
            
            // Check cache first
            if (this.config.get('cacheData')) {
                const cachedData = this.cache.get(cacheKey);
                if (cachedData) {
                    return cachedData;
                }
            }

            let data;
            
            try {
                switch (dataSourceConfig.type) {
                    case 'static':
                        data = await this.getStaticData(dataSourceConfig);
                        break;
                    case 'json':
                        data = await this.getJsonData(dataSourceConfig);
                        break;
                    case 'api':
                        data = await this.getApiData(dataSourceConfig);
                        break;
                    case 'sharepoint':
                        data = await this.getSharePointData();
                        break;
                    default:
                        throw new Error(`Unknown data source type: ${dataSourceConfig.type}`);
                }

                // Apply transformation if provided
                if (typeof dataSourceConfig.transformResponse === 'function') {
                    data = dataSourceConfig.transformResponse(data);
                }

                // Normalize data structure
                data = this.normalizeData(data);

                // Cache the result
                if (this.config.get('cacheData')) {
                    this.cache.set(cacheKey, data);
                }

                // Trigger callback
                const onDataLoad = this.config.get('onDataLoad');
                if (typeof onDataLoad === 'function') {
                    onDataLoad(data);
                }

                return data;
            } catch (error) {
                console.error('Data Retrieval Error:', error);
                
                const onError = this.config.get('onError');
                if (typeof onError === 'function') {
                    onError(error);
                }
                
                throw error;
            }
        }

        /**
         * Generate cache key for data source
         * @param {Object} config - Data source configuration
         * @returns {string} Cache key
         */
        getCacheKey(config) {
            return `menu_${config.type}_${config.url || 'static'}_${JSON.stringify(config.headers || {})}`;
        }

        /**
         * Get static data from configuration
         * @param {Object} config - Data source configuration
         * @returns {Promise<Array>} Static data
         */
        async getStaticData(config) {
            return config.data || [];
        }

        /**
         * Fetch data from JSON file
         * @param {Object} config - Data source configuration
         * @returns {Promise<Array>} JSON data
         */
        async getJsonData(config) {
            if (!config.url) {
                throw new Error('JSON data source requires a URL');
            }

            const response = await fetch(config.url, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    ...config.headers
                }
            });

            if (!response.ok) {
                throw new Error(`Failed to fetch JSON: ${response.status} ${response.statusText}`);
            }

            return response.json();
        }

        /**
         * Fetch data from REST API
         * @param {Object} config - Data source configuration
         * @returns {Promise<Array>} API data
         */
        async getApiData(config) {
            if (!config.url) {
                throw new Error('API data source requires a URL');
            }

            const response = await fetch(config.url, {
                method: config.method || 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    ...config.headers
                },
                body: config.body ? JSON.stringify(config.body) : undefined
            });

            if (!response.ok) {
                throw new Error(`API request failed: ${response.status} ${response.statusText}`);
            }

            return response.json();
        }

        /**
         * Fetch data from SharePoint list using REST API
         * @returns {Promise<Array>} SharePoint list items
         */
        async getSharePointData() {
            const spConfig = this.config.get('sharePoint');
            
            if (!spConfig.enabled || !spConfig.siteUrl || !spConfig.listName) {
                throw new Error('SharePoint configuration is incomplete');
            }

            const selectFields = spConfig.selectFields.join(',');
            const orderBy = spConfig.orderBy ? 
                `&$orderby=${spConfig.orderBy} ${spConfig.ascending ? 'asc' : 'desc'}` : '';
            
            const apiUrl = `${spConfig.siteUrl}/_api/web/lists/getbytitle('${spConfig.listName}')/items?$select=${selectFields}${orderBy}`;

            const response = await fetch(apiUrl, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json;odata=verbose',
                    'Content-Type': 'application/json;odata=verbose'
                },
                credentials: 'include'
            });

            if (!response.ok) {
                throw new Error(`SharePoint request failed: ${response.status} ${response.statusText}`);
            }

            const result = await response.json();
            return this.transformSharePointData(result.d.results);
        }

        /**
         * Transform SharePoint list data to menu structure
         * @param {Array} items - SharePoint list items
         * @returns {Array} Transformed menu data
         */
        transformSharePointData(items) {
            // Build a map of items by ID for quick lookup
            const itemMap = new Map();
            items.forEach(item => {
                itemMap.set(item.Id, {
                    id: item.Id,
                    title: item.Title,
                    url: item.Url || '#',
                    parentId: item.ParentId || null,
                    order: item.Order || 0,
                    openInNewTab: item.OpenInNewTab || false,
                    children: []
                });
            });

            // Build hierarchical structure
            const rootItems = [];
            itemMap.forEach(item => {
                if (item.parentId && itemMap.has(item.parentId)) {
                    itemMap.get(item.parentId).children.push(item);
                } else {
                    rootItems.push(item);
                }
            });

            // Sort children by order
            const sortByOrder = (a, b) => a.order - b.order;
            const sortChildren = (items) => {
                items.sort(sortByOrder);
                items.forEach(item => {
                    if (item.children.length > 0) {
                        sortChildren(item.children);
                    }
                });
            };

            sortChildren(rootItems);
            return rootItems;
        }

        /**
         * Normalize data to ensure consistent structure
         * @param {Array} data - Raw data
         * @returns {Array} Normalized data
         */
        normalizeData(data) {
            if (!Array.isArray(data)) {
                console.warn('Menu data should be an array, received:', typeof data);
                return [];
            }

            return data.map(item => this.normalizeItem(item));
        }

        /**
         * Normalize a single menu item
         * @param {Object} item - Menu item
         * @param {number} level - Current level (1-indexed)
         * @returns {Object} Normalized item
         */
        normalizeItem(item, level = 1) {
            const maxLayers = this.config.get('layers');
            
            const normalized = {
                id: item.id || this.generateId(),
                title: item.title || item.label || item.name || 'Untitled',
                url: item.url || item.href || item.link || '#',
                openInNewTab: item.openInNewTab || item.target === '_blank' || false,
                icon: item.icon || null,
                cssClass: item.cssClass || item.className || '',
                level: level,
                children: []
            };

            // Only process children if within layer limit
            if (level < maxLayers && item.children && Array.isArray(item.children)) {
                normalized.children = item.children.map(child => 
                    this.normalizeItem(child, level + 1)
                );
            }

            return normalized;
        }

        /**
         * Generate unique ID
         * @returns {string} Unique ID
         */
        generateId() {
            return 'menu_' + Math.random().toString(36).substr(2, 9);
        }

        /**
         * Clear the data cache
         */
        clearCache() {
            this.cache.clear();
        }

        /**
         * Refresh data (bypass cache)
         * @param {Object} options - Override options
         * @returns {Promise<Array>} Fresh data
         */
        async refreshData(options = {}) {
            this.clearCache();
            return this.getData(options);
        }
    }

    // Export for different module systems
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = { DataRetrieval, DataCache };
    } else {
        global.SPMenu = global.SPMenu || {};
        global.SPMenu.DataRetrieval = DataRetrieval;
        global.SPMenu.DataCache = DataCache;
    }

})(typeof window !== 'undefined' ? window : this);
