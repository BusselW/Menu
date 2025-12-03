/**
 * Menu Engine Module
 * 
 * Purpose: Core functionality for rendering and managing the menu.
 * This is the main orchestrator that brings together configuration, 
 * data retrieval, and DOM manipulation.
 * 
 * Features:
 * - Menu rendering from data
 * - Event handling (click, hover, keyboard)
 * - Accessibility support
 * - Mobile responsive behavior
 * - State management
 */

(function(global) {
    'use strict';

    /**
     * MenuEngine class - Main menu controller
     */
    class MenuEngine {
        /**
         * Create a new MenuEngine instance
         * @param {string|HTMLElement} container - Container element or selector
         * @param {Object} options - Configuration options
         */
        constructor(container, options = {}) {
            // Get container element
            this.container = typeof container === 'string' 
                ? document.querySelector(container) 
                : container;

            if (!this.container) {
                throw new Error('Menu container not found');
            }

            // Initialize configuration
            this.config = new SPMenu.MenuConfig(options);
            
            // Initialize data retrieval
            this.dataRetrieval = new SPMenu.DataRetrieval(this.config);

            // State
            this.isInitialized = false;
            this.isLoading = false;
            this.menuData = [];
            this.openMenus = new Set();
            this.hoverTimeout = null;
            this.closeTimeout = null;

            // Bind methods
            this.handleDocumentClick = this.handleDocumentClick.bind(this);
            this.handleKeyDown = this.handleKeyDown.bind(this);
            this.handleResize = this.handleResize.bind(this);
        }

        /**
         * Initialize the menu
         * @returns {Promise<void>}
         */
        async init() {
            if (this.isInitialized) {
                console.warn('Menu is already initialized');
                return;
            }

            try {
                this.setLoading(true);
                
                // Load menu data
                this.menuData = await this.dataRetrieval.getData();
                
                // Render the menu
                this.render();
                
                // Attach event listeners
                this.attachEventListeners();
                
                // Apply CSS variables
                this.applyCssVariables();
                
                this.isInitialized = true;
                
                // Trigger init callback
                const onMenuInit = this.config.get('onMenuInit');
                if (typeof onMenuInit === 'function') {
                    onMenuInit(this);
                }
            } catch (error) {
                this.renderError(error.message);
                throw error;
            } finally {
                this.setLoading(false);
            }
        }

        /**
         * Set loading state
         * @param {boolean} loading - Loading state
         */
        setLoading(loading) {
            this.isLoading = loading;
            this.container.classList.toggle('sp-menu--loading', loading);
        }

        /**
         * Apply CSS variables from configuration
         */
        applyCssVariables() {
            const cssVars = this.config.getCssVariables();
            for (const [key, value] of Object.entries(cssVars)) {
                this.container.style.setProperty(key, value);
            }
        }

        /**
         * Render the complete menu
         */
        render() {
            this.container.innerHTML = '';
            this.container.className = 'sp-menu';
            
            // Create mobile toggle button
            const toggleButton = this.createMobileToggle();
            
            // Create primary navigation
            const primaryNav = this.createPrimaryNav();
            
            this.container.appendChild(toggleButton);
            this.container.appendChild(primaryNav);
        }

        /**
         * Create mobile toggle button
         * @returns {HTMLElement}
         */
        createMobileToggle() {
            const button = document.createElement('button');
            button.className = 'sp-menu__toggle';
            button.setAttribute('aria-expanded', 'false');
            button.setAttribute('aria-controls', 'sp-menu-primary');
            button.innerHTML = `
                <span class="sp-menu__sr-only">Toggle menu</span>
                <svg class="sp-menu__toggle-icon" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M3 6h18v2H3V6zm0 5h18v2H3v-2zm0 5h18v2H3v-2z"/>
                </svg>
            `;
            
            button.addEventListener('click', () => {
                const primaryList = this.container.querySelector('.sp-menu__primary-list');
                const isOpen = primaryList.classList.toggle('sp-menu__primary-list--open');
                button.setAttribute('aria-expanded', isOpen.toString());
            });
            
            return button;
        }

        /**
         * Create primary navigation (Layer 1)
         * @returns {HTMLElement}
         */
        createPrimaryNav() {
            const nav = document.createElement('nav');
            nav.className = 'sp-menu__primary';
            nav.setAttribute('role', 'navigation');
            nav.setAttribute('aria-label', 'Main navigation');
            
            const ul = document.createElement('ul');
            ul.className = 'sp-menu__primary-list';
            ul.id = 'sp-menu-primary';
            ul.setAttribute('role', 'menubar');
            
            this.menuData.forEach((item, index) => {
                const li = this.createPrimaryItem(item, index);
                ul.appendChild(li);
            });
            
            nav.appendChild(ul);
            return nav;
        }

        /**
         * Create a primary menu item
         * @param {Object} item - Menu item data
         * @param {number} index - Item index
         * @returns {HTMLElement}
         */
        createPrimaryItem(item, index) {
            const li = document.createElement('li');
            li.className = 'sp-menu__primary-item';
            li.setAttribute('role', 'none');
            
            const hasChildren = item.children && item.children.length > 0;
            
            const link = document.createElement('a');
            link.className = 'sp-menu__primary-link';
            link.href = item.url;
            link.textContent = item.title;
            link.setAttribute('role', 'menuitem');
            link.setAttribute('tabindex', index === 0 ? '0' : '-1');
            
            if (item.openInNewTab) {
                link.setAttribute('target', '_blank');
                link.setAttribute('rel', 'noopener noreferrer');
            }
            
            if (item.icon) {
                const icon = document.createElement('span');
                icon.className = `sp-menu__icon ${item.icon}`;
                link.insertBefore(icon, link.firstChild);
            }
            
            if (hasChildren) {
                link.classList.add('sp-menu__primary-link--has-children');
                link.setAttribute('aria-haspopup', 'true');
                link.setAttribute('aria-expanded', 'false');
                
                // Create secondary menu
                const submenu = this.createSecondaryNav(item.children, item.id);
                li.appendChild(link);
                li.appendChild(submenu);
                
                // Add hover/click handlers
                this.attachSubmenuHandlers(li, link, submenu);
            } else {
                li.appendChild(link);
            }
            
            if (item.cssClass) {
                li.classList.add(item.cssClass);
            }
            
            return li;
        }

        /**
         * Create secondary navigation (Layer 2)
         * @param {Array} items - Child items
         * @param {string} parentId - Parent item ID
         * @returns {HTMLElement}
         */
        createSecondaryNav(items, parentId) {
            const ul = document.createElement('ul');
            ul.className = 'sp-menu__secondary';
            ul.id = `sp-menu-secondary-${parentId}`;
            ul.setAttribute('role', 'menu');
            ul.setAttribute('aria-label', 'Submenu');
            
            items.forEach(item => {
                const li = this.createSecondaryItem(item);
                ul.appendChild(li);
            });
            
            return ul;
        }

        /**
         * Create a secondary menu item
         * @param {Object} item - Menu item data
         * @returns {HTMLElement}
         */
        createSecondaryItem(item) {
            const li = document.createElement('li');
            li.className = 'sp-menu__secondary-item';
            li.setAttribute('role', 'none');
            
            const hasChildren = item.children && item.children.length > 0 && 
                               this.config.get('layers') >= 3;
            
            const link = document.createElement('a');
            link.className = 'sp-menu__secondary-link';
            link.href = item.url;
            link.textContent = item.title;
            link.setAttribute('role', 'menuitem');
            link.setAttribute('tabindex', '-1');
            
            if (item.openInNewTab) {
                link.setAttribute('target', '_blank');
                link.setAttribute('rel', 'noopener noreferrer');
            }
            
            if (hasChildren) {
                link.classList.add('sp-menu__secondary-link--has-children');
                link.setAttribute('aria-haspopup', 'true');
                link.setAttribute('aria-expanded', 'false');
                
                // Create tertiary menu
                const submenu = this.createTertiaryNav(item.children, item.id);
                li.appendChild(link);
                li.appendChild(submenu);
                
                // Add hover/click handlers
                this.attachSubmenuHandlers(li, link, submenu);
            } else {
                li.appendChild(link);
            }
            
            if (item.cssClass) {
                li.classList.add(item.cssClass);
            }
            
            return li;
        }

        /**
         * Create tertiary navigation (Layer 3)
         * @param {Array} items - Child items
         * @param {string} parentId - Parent item ID
         * @returns {HTMLElement}
         */
        createTertiaryNav(items, parentId) {
            const ul = document.createElement('ul');
            ul.className = 'sp-menu__tertiary';
            ul.id = `sp-menu-tertiary-${parentId}`;
            ul.setAttribute('role', 'menu');
            ul.setAttribute('aria-label', 'Submenu');
            
            items.forEach(item => {
                const li = this.createTertiaryItem(item);
                ul.appendChild(li);
            });
            
            return ul;
        }

        /**
         * Create a tertiary menu item
         * @param {Object} item - Menu item data
         * @returns {HTMLElement}
         */
        createTertiaryItem(item) {
            const li = document.createElement('li');
            li.className = 'sp-menu__tertiary-item';
            li.setAttribute('role', 'none');
            
            const link = document.createElement('a');
            link.className = 'sp-menu__tertiary-link';
            link.href = item.url;
            link.textContent = item.title;
            link.setAttribute('role', 'menuitem');
            link.setAttribute('tabindex', '-1');
            
            if (item.openInNewTab) {
                link.setAttribute('target', '_blank');
                link.setAttribute('rel', 'noopener noreferrer');
            }
            
            li.appendChild(link);
            
            if (item.cssClass) {
                li.classList.add(item.cssClass);
            }
            
            return li;
        }

        /**
         * Attach hover/click handlers to submenu triggers
         * @param {HTMLElement} parentLi - Parent list item
         * @param {HTMLElement} trigger - Trigger link element
         * @param {HTMLElement} submenu - Submenu element
         */
        attachSubmenuHandlers(parentLi, trigger, submenu) {
            const triggerType = this.config.get('triggerType');
            const hoverDelay = this.config.get('hoverDelay');
            const closeDelay = this.config.get('closeDelay');
            
            if (triggerType === 'hover') {
                // Mouse enter - open with delay
                parentLi.addEventListener('mouseenter', () => {
                    clearTimeout(this.closeTimeout);
                    this.hoverTimeout = setTimeout(() => {
                        this.openSubmenu(trigger, submenu);
                    }, hoverDelay);
                });
                
                // Mouse leave - close with delay
                parentLi.addEventListener('mouseleave', () => {
                    clearTimeout(this.hoverTimeout);
                    this.closeTimeout = setTimeout(() => {
                        this.closeSubmenu(trigger, submenu);
                    }, closeDelay);
                });
            }
            
            // Click handler (for both click and hover modes)
            trigger.addEventListener('click', (e) => {
                if (triggerType === 'click' || window.innerWidth <= this.config.get('mobileBreakpoint')) {
                    e.preventDefault();
                    const isOpen = trigger.getAttribute('aria-expanded') === 'true';
                    
                    if (isOpen) {
                        this.closeSubmenu(trigger, submenu);
                    } else {
                        this.closeAllSubmenus();
                        this.openSubmenu(trigger, submenu);
                    }
                }
                
                // Trigger callback
                const onItemClick = this.config.get('onItemClick');
                if (typeof onItemClick === 'function') {
                    onItemClick({ trigger, submenu, item: parentLi });
                }
            });
        }

        /**
         * Open a submenu
         * @param {HTMLElement} trigger - Trigger element
         * @param {HTMLElement} submenu - Submenu element
         */
        openSubmenu(trigger, submenu) {
            trigger.setAttribute('aria-expanded', 'true');
            submenu.classList.add('sp-menu__secondary--visible', 'sp-menu__tertiary--visible');
            this.openMenus.add(submenu);
            
            // Trigger callback
            const onMenuOpen = this.config.get('onMenuOpen');
            if (typeof onMenuOpen === 'function') {
                onMenuOpen({ trigger, submenu });
            }
        }

        /**
         * Close a submenu
         * @param {HTMLElement} trigger - Trigger element
         * @param {HTMLElement} submenu - Submenu element
         */
        closeSubmenu(trigger, submenu) {
            trigger.setAttribute('aria-expanded', 'false');
            submenu.classList.remove('sp-menu__secondary--visible', 'sp-menu__tertiary--visible');
            this.openMenus.delete(submenu);
            
            // Trigger callback
            const onMenuClose = this.config.get('onMenuClose');
            if (typeof onMenuClose === 'function') {
                onMenuClose({ trigger, submenu });
            }
        }

        /**
         * Close all open submenus
         */
        closeAllSubmenus() {
            const triggers = this.container.querySelectorAll('[aria-expanded="true"]');
            triggers.forEach(trigger => {
                trigger.setAttribute('aria-expanded', 'false');
            });
            
            const submenus = this.container.querySelectorAll('.sp-menu__secondary--visible, .sp-menu__tertiary--visible');
            submenus.forEach(submenu => {
                submenu.classList.remove('sp-menu__secondary--visible', 'sp-menu__tertiary--visible');
            });
            
            this.openMenus.clear();
        }

        /**
         * Attach global event listeners
         */
        attachEventListeners() {
            // Close on outside click
            if (this.config.get('closeOnOutsideClick')) {
                document.addEventListener('click', this.handleDocumentClick);
            }
            
            // Keyboard navigation
            if (this.config.get('enableKeyboardNavigation')) {
                this.container.addEventListener('keydown', this.handleKeyDown);
            }
            
            // Handle escape key
            if (this.config.get('closeOnEscape')) {
                document.addEventListener('keydown', (e) => {
                    if (e.key === 'Escape') {
                        this.closeAllSubmenus();
                    }
                });
            }
            
            // Handle resize
            window.addEventListener('resize', this.handleResize);
        }

        /**
         * Handle document click for closing menus
         * @param {Event} e - Click event
         */
        handleDocumentClick(e) {
            if (!this.container.contains(e.target)) {
                this.closeAllSubmenus();
            }
        }

        /**
         * Handle keyboard navigation
         * @param {KeyboardEvent} e - Keyboard event
         */
        handleKeyDown(e) {
            const currentItem = document.activeElement;
            
            if (!this.container.contains(currentItem)) return;
            
            let handled = false;
            
            switch (e.key) {
                case 'ArrowRight':
                    this.focusNextItem(currentItem);
                    handled = true;
                    break;
                case 'ArrowLeft':
                    this.focusPreviousItem(currentItem);
                    handled = true;
                    break;
                case 'ArrowDown':
                    this.focusFirstSubmenuItem(currentItem);
                    handled = true;
                    break;
                case 'ArrowUp':
                    this.focusParentItem(currentItem);
                    handled = true;
                    break;
                case 'Enter':
                case ' ':
                    if (currentItem.getAttribute('aria-haspopup') === 'true') {
                        currentItem.click();
                        handled = true;
                    }
                    break;
                case 'Home':
                    this.focusFirstItem();
                    handled = true;
                    break;
                case 'End':
                    this.focusLastItem();
                    handled = true;
                    break;
            }
            
            if (handled) {
                e.preventDefault();
            }
        }

        /**
         * Focus next menu item
         * @param {HTMLElement} current - Current focused element
         */
        focusNextItem(current) {
            const items = this.getFocusableItems(current.closest('ul'));
            const currentIndex = items.indexOf(current);
            const nextIndex = (currentIndex + 1) % items.length;
            items[nextIndex]?.focus();
        }

        /**
         * Focus previous menu item
         * @param {HTMLElement} current - Current focused element
         */
        focusPreviousItem(current) {
            const items = this.getFocusableItems(current.closest('ul'));
            const currentIndex = items.indexOf(current);
            const prevIndex = (currentIndex - 1 + items.length) % items.length;
            items[prevIndex]?.focus();
        }

        /**
         * Focus first item in submenu
         * @param {HTMLElement} current - Current focused element
         */
        focusFirstSubmenuItem(current) {
            const submenu = current.parentElement.querySelector('.sp-menu__secondary, .sp-menu__tertiary');
            if (submenu) {
                const items = this.getFocusableItems(submenu);
                items[0]?.focus();
            }
        }

        /**
         * Focus parent menu item
         * @param {HTMLElement} current - Current focused element
         */
        focusParentItem(current) {
            const parentLi = current.closest('.sp-menu__secondary-item, .sp-menu__tertiary-item')
                            ?.parentElement?.closest('li');
            if (parentLi) {
                const link = parentLi.querySelector('a');
                link?.focus();
            }
        }

        /**
         * Focus first primary item
         */
        focusFirstItem() {
            const items = this.container.querySelectorAll('.sp-menu__primary-link');
            items[0]?.focus();
        }

        /**
         * Focus last primary item
         */
        focusLastItem() {
            const items = this.container.querySelectorAll('.sp-menu__primary-link');
            items[items.length - 1]?.focus();
        }

        /**
         * Get focusable items in a list
         * @param {HTMLElement} list - List element
         * @returns {Array} Array of focusable items
         */
        getFocusableItems(list) {
            if (!list) return [];
            return Array.from(list.querySelectorAll(':scope > li > a'));
        }

        /**
         * Handle window resize
         */
        handleResize() {
            const mobileBreakpoint = this.config.get('mobileBreakpoint');
            
            if (window.innerWidth > mobileBreakpoint) {
                // Reset mobile menu state
                const primaryList = this.container.querySelector('.sp-menu__primary-list');
                primaryList?.classList.remove('sp-menu__primary-list--open');
                
                const toggle = this.container.querySelector('.sp-menu__toggle');
                toggle?.setAttribute('aria-expanded', 'false');
            }
        }

        /**
         * Render error message
         * @param {string} message - Error message
         */
        renderError(message) {
            this.container.innerHTML = `
                <div class="sp-menu__error" role="alert">
                    <strong>Menu Error:</strong> ${this.escapeHtml(message)}
                </div>
            `;
        }

        /**
         * Escape HTML to prevent XSS
         * @param {string} text - Text to escape
         * @returns {string} Escaped text
         */
        escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        /**
         * Refresh menu data and re-render
         * @returns {Promise<void>}
         */
        async refresh() {
            this.menuData = await this.dataRetrieval.refreshData();
            this.render();
            this.attachEventListeners();
        }

        /**
         * Destroy the menu instance
         */
        destroy() {
            // Remove event listeners
            document.removeEventListener('click', this.handleDocumentClick);
            this.container.removeEventListener('keydown', this.handleKeyDown);
            window.removeEventListener('resize', this.handleResize);
            
            // Clear content
            this.container.innerHTML = '';
            this.container.className = '';
            
            // Clear state
            this.isInitialized = false;
            this.menuData = [];
            this.openMenus.clear();
        }

        /**
         * Update menu configuration
         * @param {Object} options - New options
         */
        updateConfig(options) {
            this.config = new SPMenu.MenuConfig({
                ...this.config.getAll(),
                ...options
            });
        }
    }

    // Export for different module systems
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = { MenuEngine };
    } else {
        global.SPMenu = global.SPMenu || {};
        global.SPMenu.MenuEngine = MenuEngine;
    }

})(typeof window !== 'undefined' ? window : this);
