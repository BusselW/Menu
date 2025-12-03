/**
 * @fileoverview Enhanced SharePoint Lists Helper for NavBar
 * @description Extended utility to retrieve SharePoint lists, their GUIDs, and manage NavBar items
 * @version 2.0
 */

// Create namespace to avoid global conflicts
var SPHelper = SPHelper || {};

/**
 * Lists module for retrieving SharePoint lists and managing navigation items
 */
SPHelper.Lists = (function() {
    // Private variables
    var _cache = {
        lists: {},
        items: {},
        digests: {}
    };
    var _defaultSiteUrl = "";
    var _baseUrl = "https://som.org.om.local/sites/";
    
    /**
     * Makes a REST API GET request to SharePoint
     * @param {string} url - Full API URL
     * @returns {Promise} Promise that resolves with the data
     * @private
     */
    function _makeRequest(url) {
        return new Promise(function(resolve, reject) {
            $.ajax({
                url: url,
                method: "GET",
                headers: { "Accept": "application/json;odata=verbose" },
                xhrFields: { withCredentials: true },
                success: function(data) {
                    resolve(data);
                },
                error: function(xhr, status, error) {
                    reject({
                        status: xhr.status,
                        message: error,
                        details: xhr.responseJSON || xhr.responseText
                    });
                }
            });
        });
    }
    
    /**
     * Makes a REST API POST/PATCH/DELETE request to SharePoint
     * @param {string} url - Full API URL
     * @param {string} method - HTTP method (POST, PATCH, DELETE)
     * @param {Object} data - Data to send
     * @param {string} digest - The request digest value
     * @param {Object} [additionalHeaders] - Additional headers to include
     * @returns {Promise} Promise that resolves with the response data
     * @private
     */
    function _makeWriteRequest(url, method, data, digest, additionalHeaders) {
        var headers = {
            "Accept": "application/json;odata=verbose",
            "Content-Type": "application/json;odata=verbose",
            "X-RequestDigest": digest
        };
        
        // Add additional headers
        if (additionalHeaders) {
            for (var key in additionalHeaders) {
                headers[key] = additionalHeaders[key];
            }
        }
        
        return new Promise(function(resolve, reject) {
            $.ajax({
                url: url,
                method: method,
                data: data ? JSON.stringify(data) : null,
                headers: headers,
                xhrFields: { withCredentials: true },
                success: function(data) {
                    resolve(data);
                },
                error: function(xhr, status, error) {
                    reject({
                        status: xhr.status,
                        message: error,
                        details: xhr.responseJSON || xhr.responseText
                    });
                }
            });
        });
    }
    
    /**
     * Builds a complete site URL from a site name
     * @param {string} siteName - Site name or full URL
     * @returns {string} Complete site URL
     * @private
     */
    function _buildSiteUrl(siteName) {
        // If already a full URL, return as is
        if (siteName.toLowerCase().startsWith('http')) {
            return siteName;
        }
        
        // Remove any leading or trailing slashes
        siteName = siteName.replace(/^\/+|\/+$/g, '');
        
        // If it already starts with "sites/", just prepend the base protocol/domain
        if (siteName.toLowerCase().startsWith('sites/')) {
            return window.location.protocol + "//" + window.location.host + "/" + siteName;
        }
        
        // Otherwise, build the full URL
        return _baseUrl + siteName;
    }
    
    /**
     * Gets a request digest for write operations
     * @param {string} siteUrl - Full URL of the SharePoint site
     * @param {boolean} [forceRefresh=false] - Whether to bypass cache
     * @returns {Promise<string>} Promise that resolves with the digest value
     * @public
     */
    function getRequestDigest(siteUrl, forceRefresh) {
        siteUrl = _buildSiteUrl(siteUrl);
        
        // Check cache if not forcing refresh
        if (!forceRefresh && _cache.digests[siteUrl] && _cache.digests[siteUrl].expires > Date.now()) {
            return Promise.resolve(_cache.digests[siteUrl].value);
        }
        
        return new Promise(function(resolve, reject) {
            $.ajax({
                url: siteUrl + "/_api/contextinfo",
                method: "POST",
                headers: { "Accept": "application/json;odata=verbose" },
                xhrFields: { withCredentials: true },
                success: function(data) {
                    const digestValue = data.d.GetContextWebInformation.FormDigestValue;
                    const expiresIn = data.d.GetContextWebInformation.FormDigestTimeoutSeconds * 1000;
                    
                    // Cache the digest value with expiration
                    _cache.digests[siteUrl] = {
                        value: digestValue,
                        expires: Date.now() + expiresIn - 60000 // Subtract 1 minute to be safe
                    };
                    
                    resolve(digestValue);
                },
                error: function(xhr, status, error) {
                    reject({
                        status: xhr.status,
                        message: "Failed to get request digest: " + error,
                        details: xhr.responseJSON || xhr.responseText
                    });
                }
            });
        });
    }
    
    /**
     * Gets all lists from a SharePoint site
     * @param {string} siteName - Name or URL of the SharePoint site
     * @param {Object} [options] - Additional options
     * @param {boolean} [options.includeHidden=false] - Whether to include hidden lists
     * @param {boolean} [options.forceRefresh=false] - Whether to bypass cache
     * @param {boolean} [options.navBarOnly=false] - Whether to filter for NavBar lists only
     * @returns {Promise} Promise that resolves with list data
     * @public
     */
    function getLists(siteName, options) {
        var opts = options || {};
        var includeHidden = opts.includeHidden || false;
        var forceRefresh = opts.forceRefresh || false;
        var navBarOnly = opts.navBarOnly || false;
        
        // Use provided site URL or default
        var siteUrl = _buildSiteUrl(siteName || _defaultSiteUrl);
        if (!siteUrl) {
            return Promise.reject({
                message: "No site name provided and no default set"
            });
        }
        
        // Check cache if not forcing refresh
        var cacheKey = siteUrl + "_" + includeHidden + "_" + navBarOnly;
        if (!forceRefresh && _cache.lists[cacheKey]) {
            return Promise.resolve(_cache.lists[cacheKey]);
        }
        
        // Build API URL
        var apiUrl = siteUrl + "/_api/web/lists?$select=Title,Id,Hidden,ItemCount,BaseTemplate,Description";
        
        // Make request and process data
        return _makeRequest(apiUrl)
            .then(function(data) {
                try {
                    // Filter lists based on options
                    var lists = data.d.results.filter(function(list) {
                        // Filter hidden lists if needed
                        if (!includeHidden && list.Hidden) {
                            return false;
                        }
                        
                        // Filter for NavBar lists if needed
                        if (navBarOnly && !list.Title.includes("Nav")) {
                            return false;
                        }
                        
                        return true;
                    });
                    
                    // Map to simplified objects
                    var result = lists.map(function(list) {
                        return {
                            title: list.Title,
                            id: list.Id,
                            guid: list.Id, // Alias for clarity
                            hidden: list.Hidden,
                            itemCount: list.ItemCount,
                            description: list.Description || '',
                            isDocumentLibrary: list.BaseTemplate === 101,
                            siteUrl: siteUrl
                        };
                    });
                    
                    // Cache results
                    _cache.lists[cacheKey] = result;
                    
                    return result;
                } catch (error) {
                    throw {
                        message: "Error processing lists data",
                        details: error.message
                    };
                }
            });
    }
    
    /**
     * Gets all subsites of a SharePoint site
     * @param {string} siteName - Name or URL of the SharePoint site
     * @returns {Promise} Promise that resolves with subsite data
     * @public
     */
    function getSubsites(siteName) {
        // Build site URL
        var siteUrl = _buildSiteUrl(siteName || _defaultSiteUrl);
        if (!siteUrl) {
            return Promise.reject({
                message: "No site name provided and no default set"
            });
        }
        
        // Build API URL
        var apiUrl = siteUrl + "/_api/web/GetSubwebsFilteredForCurrentUser(nWebTemplateFilter=-1)";
        
        // Make request and process data
        return _makeRequest(apiUrl)
            .then(function(data) {
                try {
                    // Map to simplified objects
                    var result = data.d.results.map(function(site) {
                        var url = site.ServerRelativeUrl.startsWith('/') ? 
                            window.location.protocol + "//" + window.location.host + site.ServerRelativeUrl : 
                            site.ServerRelativeUrl;
                        
                        return {
                            title: site.Title,
                            url: url,
                            description: site.Description || '',
                            serverRelativeUrl: site.ServerRelativeUrl
                        };
                    });
                    
                    return result;
                } catch (error) {
                    throw {
                        message: "Error processing subsites data",
                        details: error.message
                    };
                }
            });
    }
    
    /**
     * Gets all lists from a SharePoint site and its subsites
     * @param {string} siteName - Name or URL of the SharePoint site
     * @param {Object} [options] - Additional options
     * @returns {Promise} Promise that resolves with combined list data
     * @public
     */
    function getListsFromSiteAndSubsites(siteName, options) {
        var siteUrl = _buildSiteUrl(siteName || _defaultSiteUrl);
        
        // First get the main site lists
        return getLists(siteUrl, options)
            .then(function(mainSiteLists) {
                // Add site information to each list
                mainSiteLists.forEach(function(list) {
                    list.siteTitle = "Main Site";
                });
                
                // Then get all subsites
                return getSubsites(siteUrl)
                    .then(function(subsites) {
                        // Create array of promises for loading lists from each subsite
                        var promises = subsites.map(function(site) {
                            return getLists(site.url, options)
                                .then(function(lists) {
                                    // Add site information to each list
                                    lists.forEach(function(list) {
                                        list.siteTitle = site.title;
                                        list.siteUrl = site.url;
                                    });
                                    return lists;
                                })
                                .catch(function(error) {
                                    console.warn(`Error loading lists from ${site.url}:`, error);
                                    return []; // Return empty array on error
                                });
                        });
                        
                        // Wait for all promises to resolve
                        return Promise.all(promises)
                            .then(function(listsArrays) {
                                // Flatten arrays and combine with main site lists
                                return mainSiteLists.concat([].concat.apply([], listsArrays));
                            });
                    });
            });
    }
    
    /**
     * Gets items from a SharePoint list
     * @param {string} siteName - Name or URL of the SharePoint site
     * @param {string} listId - GUID of the list
     * @param {Object} [options] - Additional options
     * @param {string} [options.select] - Fields to select (comma-separated)
     * @param {string} [options.filter] - OData filter string
     * @param {string} [options.orderby] - OData orderby string
     * @param {number} [options.top] - Maximum number of items to retrieve
     * @param {number} [options.skip] - Number of items to skip
     * @param {boolean} [options.forceRefresh=false] - Whether to bypass cache
     * @returns {Promise} Promise that resolves with list items
     * @public
     */
    function getListItems(siteName, listId, options) {
        var opts = options || {};
        var forceRefresh = opts.forceRefresh || false;
        
        // Build site URL
        var siteUrl = _buildSiteUrl(siteName || _defaultSiteUrl);
        if (!siteUrl) {
            return Promise.reject({
                message: "No site name provided and no default set"
            });
        }
        
        // Check if it's a valid GUID
        if (!listId || !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(listId)) {
            return Promise.reject({
                message: "Invalid list GUID"
            });
        }
        
        // Check cache if not forcing refresh
        var cacheKey = siteUrl + "_" + listId + "_" + JSON.stringify(opts);
        if (!forceRefresh && _cache.items[cacheKey]) {
            return Promise.resolve(_cache.items[cacheKey]);
        }
        
        // Build API URL
        var apiUrl = `${siteUrl}/_api/web/lists(guid'${listId}')/items`;
        var queryParams = [];
        
        if (opts.select) {
            queryParams.push("$select=" + opts.select);
        }
        
        if (opts.filter) {
            queryParams.push("$filter=" + opts.filter);
        }
        
        if (opts.orderby) {
            queryParams.push("$orderby=" + opts.orderby);
        }
        
        if (opts.top) {
            queryParams.push("$top=" + opts.top);
        }
        
        if (opts.skip) {
            queryParams.push("$skip=" + opts.skip);
        }
        
        if (queryParams.length > 0) {
            apiUrl += "?" + queryParams.join("&");
        }
        
        // Make request and process data
        return _makeRequest(apiUrl)
            .then(function(data) {
                try {
                    var items = data.d.results || [];
                    
                    // Cache results
                    _cache.items[cacheKey] = items;
                    
                    return items;
                } catch (error) {
                    throw {
                        message: "Error processing list items",
                        details: error.message
                    };
                }
            });
    }
    
    /**
     * Gets NavBar items from a list
     * @param {string} siteName - Name or URL of the SharePoint site
     * @param {string} listId - GUID of the list
     * @param {boolean} [forceRefresh=false] - Whether to bypass cache
     * @returns {Promise} Promise that resolves with NavBar items
     * @public
     */
    function getNavBarItems(siteName, listId, forceRefresh) {
        return getListItems(siteName, listId, {
            select: "Id,Title,URL,ParentID1,VolgordeID,Icon",
            orderby: "VolgordeID asc,Title asc",
            top: 5000,
            forceRefresh: forceRefresh
        });
    }
    
    /**
     * Creates a new NavBar item
     * @param {string} siteName - Name or URL of the SharePoint site
     * @param {string} listId - GUID of the list
     * @param {Object} itemData - Item data
     * @returns {Promise} Promise that resolves when the item is created
     * @public
     */
    function createNavBarItem(siteName, listId, itemData) {
        var siteUrl = _buildSiteUrl(siteName || _defaultSiteUrl);
        
        // Prepare item data
        var formData = {
            __metadata: { type: 'SP.Data.NavBarListItem' },
            Title: itemData.Title || "",
            Icon: itemData.Icon || ""
        };
        
        // Add optional fields
        if (itemData.ParentID1) {
            formData.ParentID1 = parseInt(itemData.ParentID1);
        }
        
        if (itemData.VolgordeID) {
            formData.VolgordeID = parseInt(itemData.VolgordeID);
        }
        
        if (itemData.URL) {
            formData.URL = {
                __metadata: { type: 'SP.FieldUrlValue' },
                Url: itemData.URL,
                Description: itemData.Title || ""
            };
        }
        
        // Get request digest and create item
        return getRequestDigest(siteUrl)
            .then(function(digest) {
                // API endpoint
                var apiUrl = `${siteUrl}/_api/web/lists(guid'${listId}')/items`;
                
                // Make request
                return _makeWriteRequest(apiUrl, "POST", formData, digest);
            })
            .then(function(response) {
                // Clear cache for this list
                Object.keys(_cache.items).forEach(function(key) {
                    if (key.includes(listId)) {
                        delete _cache.items[key];
                    }
                });
                
                return response.d;
            });
    }
    
    /**
     * Updates an existing NavBar item
     * @param {string} siteName - Name or URL of the SharePoint site
     * @param {string} listId - GUID of the list
     * @param {number} itemId - ID of the item to update
     * @param {Object} itemData - Item data
     * @returns {Promise} Promise that resolves when the item is updated
     * @public
     */
    function updateNavBarItem(siteName, listId, itemId, itemData) {
        var siteUrl = _buildSiteUrl(siteName || _defaultSiteUrl);
        
        // Prepare item data
        var formData = {
            __metadata: { type: 'SP.Data.NavBarListItem' },
            Title: itemData.Title || "",
            Icon: itemData.Icon || ""
        };
        
        // Add optional fields
        if (itemData.ParentID1 !== undefined) {
            formData.ParentID1 = itemData.ParentID1 ? parseInt(itemData.ParentID1) : null;
        }
        
        if (itemData.VolgordeID !== undefined) {
            formData.VolgordeID = itemData.VolgordeID ? parseInt(itemData.VolgordeID) : null;
        }
        
        if (itemData.URL !== undefined) {
            if (itemData.URL) {
                formData.URL = {
                    __metadata: { type: 'SP.FieldUrlValue' },
                    Url: itemData.URL,
                    Description: itemData.Title || ""
                };
            } else {
                formData.URL = null;
            }
        }
        
        // Get request digest and update item
        return getRequestDigest(siteUrl)
            .then(function(digest) {
                // API endpoint
                var apiUrl = `${siteUrl}/_api/web/lists(guid'${listId}')/items(${itemId})`;
                
                // Make request
                return _makeWriteRequest(apiUrl, "PATCH", formData, digest, {
                    "IF-MATCH": "*",
                    "X-HTTP-Method": "MERGE"
                });
            })
            .then(function() {
                // Clear cache for this list
                Object.keys(_cache.items).forEach(function(key) {
                    if (key.includes(listId)) {
                        delete _cache.items[key];
                    }
                });
                
                return true; // PATCH doesn't return data
            });
    }
    
    /**
     * Deletes a NavBar item
     * @param {string} siteName - Name or URL of the SharePoint site
     * @param {string} listId - GUID of the list
     * @param {number} itemId - ID of the item to delete
     * @returns {Promise} Promise that resolves when the item is deleted
     * @public
     */
    function deleteNavBarItem(siteName, listId, itemId) {
        var siteUrl = _buildSiteUrl(siteName || _defaultSiteUrl);
        
        // Get request digest and delete item
        return getRequestDigest(siteUrl)
            .then(function(digest) {
                // API endpoint
                var apiUrl = `${siteUrl}/_api/web/lists(guid'${listId}')/items(${itemId})`;
                
                // Make request
                return _makeWriteRequest(apiUrl, "POST", null, digest, {
                    "IF-MATCH": "*",
                    "X-HTTP-Method": "DELETE"
                });
            })
            .then(function() {
                // Clear cache for this list
                Object.keys(_cache.items).forEach(function(key) {
                    if (key.includes(listId)) {
                        delete _cache.items[key];
                    }
                });
                
                return true; // DELETE doesn't return data
            });
    }
    
    /**
     * Sets the default site name or URL for future calls
     * @param {string} siteName - Name or URL to use as default
     * @public
     */
    function setDefaultSiteUrl(siteName) {
        if (siteName) {
            _defaultSiteUrl = siteName;
        }
    }
    
    /**
     * Sets the base URL for SharePoint sites
     * @param {string} baseUrl - Base URL for SharePoint sites
     * @public
     */
    function setBaseUrl(baseUrl) {
        if (baseUrl) {
            _baseUrl = baseUrl;
        }
    }
    
    /**
     * Clears all caches
     * @public
     */
    function clearCache() {
        _cache = {
            lists: {},
            items: {},
            digests: {}
        };
    }
    
    /**
     * Clears specific cache by type
     * @param {string} cacheType - Type of cache to clear ('lists', 'items', 'digests')
     * @public
     */
    function clearCacheByType(cacheType) {
        if (_cache[cacheType]) {
            _cache[cacheType] = {};
        }
    }
    
    // Public API
    return {
        getLists: getLists,
        getSubsites: getSubsites,
        getListsFromSiteAndSubsites: getListsFromSiteAndSubsites,
        getListItems: getListItems,
        getNavBarItems: getNavBarItems,
        createNavBarItem: createNavBarItem,
        updateNavBarItem: updateNavBarItem,
        deleteNavBarItem: deleteNavBarItem,
        getRequestDigest: getRequestDigest,
        setDefaultSiteUrl: setDefaultSiteUrl,
        setBaseUrl: setBaseUrl,
        clearCache: clearCache,
        clearCacheByType: clearCacheByType
    };
})();

// Auto-initialize when loaded
$(document).ready(function() {
    // Set the default base URL
    SPHelper.Lists.setBaseUrl("https://som.org.om.local/sites/");
    
    // Try to detect current site URL
    var pathParts = window.location.pathname.split('/');
    var sitesIndex = pathParts.indexOf('sites');
    
    if (sitesIndex !== -1 && pathParts.length > sitesIndex + 1) {
        // Extract site name
        var siteName = pathParts[sitesIndex + 1];
        
        // Set as default
        SPHelper.Lists.setDefaultSiteUrl(siteName);
    }
});