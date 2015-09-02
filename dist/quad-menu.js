(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if (!this.Maslosoft) {
    this.Maslosoft = {};
  }

  if (!this.Maslosoft.QuadMenu) {
    this.Maslosoft.QuadMenu = {};
  }

  this.Maslosoft.QuadMenu.Options = (function() {
    var browserContext;

    Options.prototype.region = 'document';

    Options.prototype.showSpot = true;

    Options.prototype.event = 'mousedown';

    browserContext = false;

    Options.prototype.menus = [];

    function Options(options) {
      var name, value;
      if (options == null) {
        options = {};
      }
      for (name in options) {
        value = options[name];
        this[name] = value;
      }
    }

    return Options;

  })();

  this.Maslosoft.QuadMenu.ItemBase = (function() {
    ItemBase.prototype.id = 0;

    ItemBase.prototype.parent = null;

    ItemBase.prototype.length = 0;

    ItemBase.prototype.visible = true;

    ItemBase.prototype.items = [];

    function ItemBase(options) {
      var name, value;
      if (options == null) {
        options = {};
      }
      this.reset();
      for (name in options) {
        value = options[name];
        this[name] = value;
      }
    }

    ItemBase.prototype.add = function(item) {
      var id;
      this.length++;
      this.items.push(item);
      id = this.length - 1;
      item.id = id;
      item.parent = this;
      return id;
    };

    ItemBase.prototype.reset = function() {
      this.parent = null;
      this.length = 0;
      return this.items = new Array;
    };

    ItemBase.prototype.get = function(itemId) {
      if (this.items[itemId]) {
        return this.items[itemId];
      }
      return null;
    };

    ItemBase.prototype.getItems = function() {
      return this.items;
    };

    ItemBase.prototype.isVisible = function(visible) {
      if (visible == null) {
        visible = null;
      }
      if (visible !== null) {
        this.visible = visible;
      }
      return this.visible;
    };

    ItemBase.prototype.inRegion = function() {
      return null;
    };

    return ItemBase;

  })();

  this.Maslosoft.QuadMenu.Item = (function(superClass) {
    extend(Item, superClass);

    Item.prototype.title = '';

    Item.prototype.href = '';

    Item.prototype.menu = '';

    function Item(options) {
      var name, value;
      if (options == null) {
        options = {};
      }
      for (name in options) {
        value = options[name];
        this[name] = value;
      }
    }

    Item.prototype.setMenu = function(menu1) {
      this.menu = menu1;
    };

    Item.prototype.onClick = function() {
      return this.click;
    };

    Item.prototype.getTitle = function() {
      return this.title;
    };

    Item.prototype.setTitle = function(title) {
      this.title = title;
    };

    Item.prototype.getHref = function() {
      return '#';
    };

    return Item;

  })(this.Maslosoft.QuadMenu.ItemBase);

  this.Maslosoft.QuadMenu.Menu = (function(superClass) {
    extend(Menu, superClass);

    function Menu(options) {
      var i, id, item, len, ref;
      if (options == null) {
        options = {};
      }
      Menu.__super__.constructor.call(this, options);
      if (options.items) {
        this.reset();
        ref = options.items;
        for (id = i = 0, len = ref.length; i < len; id = ++i) {
          item = ref[id];
          item = new Maslosoft.QuadMenu.Item(item);
          this.add(item);
        }
      }
    }

    Menu.prototype.title = '';

    Menu.prototype.setTitle = function(title) {
      this.title = title;
    };

    Menu.prototype.getTitle = function() {
      return this.title;
    };

    Menu.prototype.getPreferred = function() {
      return -1;
    };

    return Menu;

  })(this.Maslosoft.QuadMenu.ItemBase);

  this.Maslosoft.QuadMenu.Quad = (function(superClass) {
    extend(Quad, superClass);

    function Quad() {
      return Quad.__super__.constructor.apply(this, arguments);
    }

    return Quad;

  })(this.Maslosoft.QuadMenu.ItemBase);

  this.Maslosoft.QuadMenu.QuadMenu = (function() {
    QuadMenu.prototype.options = null;

    QuadMenu.prototype.quads = [];

    QuadMenu.prototype.menu = null;

    QuadMenu.prototype.renderer = null;

    function QuadMenu(options) {
      var i, id, j, len, menu, ref;
      if (options == null) {
        options = {};
      }
      this.close = bind(this.close, this);
      this.open = bind(this.open, this);
      this.preventContext = bind(this.preventContext, this);
      this.itemClick = bind(this.itemClick, this);
      this.regionClick = bind(this.regionClick, this);
      this.quads = new Array;
      this.options = new Maslosoft.QuadMenu.Options(options);
      this.renderer = new Maslosoft.QuadMenu.Renderer(this);
      for (id = i = 0; i < 4; id = ++i) {
        this.quads[id] = new Maslosoft.QuadMenu.Quad({
          id: id
        });
      }
      ref = this.options.menus;
      for (j = 0, len = ref.length; j < len; j++) {
        menu = ref[j];
        this.add(menu);
      }
      if (this.options.region === 'document') {
        jQuery(document).on(this.options.event, this.regionClick);
        jQuery(document).on('contextmenu', this.preventContext);
      } else {
        jQuery(document).on(this.options.event, this.options.region, this.regionClick);
        jQuery(document).on('contextmenu', this.options.region, this.preventContext);
      }
      this.renderer.container.on(this.options.event, this.itemClick);
      this.renderer.container.on('click', this.prevent);
      jQuery(document).on('keydown', (function(_this) {
        return function(e) {
          if (e.keyCode === 27) {
            return _this.close();
          }
        };
      })(this));
    }

    QuadMenu.prototype.regionClick = function(e) {
      if (e.which === 3) {
        this.open(e.clientX, e.clientY);
        if (!this.options.browserContext) {
          return e.preventDefault();
        }
      } else {
        return this.close();
      }
    };

    QuadMenu.prototype.itemClick = function(e) {
      var data, item;
      data = jQuery(e.target).data();
      item = this.getItem(data);
      if (item) {
        item.onClick(e, item);
      }
      return e.stopPropagation();
    };

    QuadMenu.prototype.preventContext = function(e) {
      e.preventDefault();
      if (!this.options.browserContext) {
        return e.preventDefault();
      }
    };

    QuadMenu.prototype.prevent = function(e) {
      return e.preventDefault();
    };

    QuadMenu.prototype.getItem = function(data) {
      var menu;
      menu = this.getMenu(data);
      if (menu) {
        return menu.get(data.itemId);
      }
      return null;
    };

    QuadMenu.prototype.getMenu = function(data) {
      var quad;
      quad = this.getQuad(data);
      if (quad) {
        return quad.get(data.menuId);
      }
      return null;
    };

    QuadMenu.prototype.getQuad = function(data) {
      if (this.quads[data.quadId]) {
        return this.quads[data.quadId];
      }
      return null;
    };

    QuadMenu.prototype.open = function(x, y) {
      return this.renderer.open(x, y);
    };

    QuadMenu.prototype.close = function() {
      return this.renderer.close();
    };

    QuadMenu.prototype.add = function(menu, preferred) {
      var i, j, len, quad, ref, size;
      if (preferred == null) {
        preferred = -1;
      }
      if (preferred >= 0) {
        preferred = parseInt(menu.getPreferred());
      }
      if (preferred < -1 || preferred > 3) {
        throw new Error('Preferred quad must be between `-1` and `3`');
      }
      if (preferred >= 0) {
        this.quads[preferred].items.push(menu);
      }
      for (size = i = 0; i < 4; size = ++i) {
        ref = this.quads;
        for (j = 0, len = ref.length; j < len; j++) {
          quad = ref[j];
          if (quad.length === size) {
            quad.add(menu);
            this.renderer.add(quad, menu);
            return;
          }
        }
      }
    };

    return QuadMenu;

  })();

  this.Maslosoft.QuadMenu.Renderer = (function() {
    Renderer.prototype.menu = null;

    Renderer.prototype.container = null;

    Renderer.prototype.quads = [];

    Renderer.prototype.menus = [];

    Renderer.prototype.items = [];

    function Renderer(menu1) {
      var i, quad, quadId;
      this.menu = menu1;
      this.add = bind(this.add, this);
      this.close = bind(this.close, this);
      this.open = bind(this.open, this);
      this.quads = new Array;
      this.menus = new Array;
      this.items = new Array;
      this.container = jQuery("<div class=\"maslosoft-quad-menu\"></div>");
      if (this.menu.options.showSpot) {
        this.container.append("<div class=\"quad-spot\" /> ");
      }
      for (quadId = i = 0; i < 4; quadId = ++i) {
        quad = jQuery("<div class='quad-" + quadId + "' />");
        this.quads[quadId] = quad;
        this.menus[quadId] = new Array;
        this.items[quadId] = new Array;
        this.container.append(quad);
      }
      jQuery('body').append(this.container);
    }

    Renderer.prototype.open = function(x, y) {
      var i, item, itemElement, itemId, j, k, len, len1, len2, menu, menuElement, menuId, quad, quadElement, quadId, ref, ref1, ref2, results, visibleItems, visibleMenus;
      this.container.css('left', x);
      this.container.css('top', y);
      this.container.show();
      ref = this.menu.quads;
      results = [];
      for (quadId = i = 0, len = ref.length; i < len; quadId = ++i) {
        quad = ref[quadId];
        quadElement = this.getQuad(quadId);
        visibleMenus = 0;
        ref1 = quad.items;
        for (menuId = j = 0, len1 = ref1.length; j < len1; menuId = ++j) {
          menu = ref1[menuId];
          menuElement = this.getMenu(quadId, menuId);
          visibleItems = 0;
          ref2 = menu.items;
          for (itemId = k = 0, len2 = ref2.length; k < len2; itemId = ++k) {
            item = ref2[itemId];
            itemElement = this.getItem(quadId, menuId, itemId);
            visibleItems += this.setVisibilityOf(item, itemElement);
          }
          if (visibleItems === 0) {
            menuElement.hide();
          } else {
            visibleMenus += this.setVisibilityOf(menu, menuElement);
          }
        }
        if (visibleMenus === 0) {
          quadElement.hide();
        }
        results.push(this.setVisibilityOf(quad, quadElement));
      }
      return results;
    };

    Renderer.prototype.setVisibilityOf = function(item, element, parent, perentElement) {
      var isVisible, show;
      if (parent == null) {
        parent = null;
      }
      if (perentElement == null) {
        perentElement = null;
      }
      show = item.isVisible();
      isVisible = element.is(":visible");
      if (show) {
        element.show();
        return 1;
      }
      if (!show) {
        element.hide();
        return 0;
      }
    };

    Renderer.prototype.close = function() {
      return this.container.hide();
    };

    Renderer.prototype.getItem = function(quadId, menuId, itemId) {
      if (quadId > 3 || quadId < 0) {
        throw new Error("Bad quad id must be in `0 ... 3` however `" + quadId + "` given");
      }
      return this.items[quadId][menuId][itemId];
    };

    Renderer.prototype.getMenu = function(quadId, menuId) {
      if (quadId > 3 || quadId < 0) {
        throw new Error("Bad quad id must be in `0 ... 3` however `" + quadId + "` given");
      }
      return this.menus[quadId][menuId];
    };

    Renderer.prototype.getQuad = function(quadId) {
      if (quadId > 3 || quadId < 0) {
        throw new Error("Bad quad id must be in `0 ... 3` however `" + quadId + "` given");
      }
      return this.quads[quadId];
    };

    Renderer.prototype.add = function(quad, menu) {
      var item, itemElement, itemId, menuElement, menuId, quadId, ref, results;
      quadId = quad.id;
      menuId = menu.id;
      if (!this.items[quadId][menuId]) {
        this.items[quadId][menuId] = [];
      }
      menuElement = jQuery("<ul data-menu-id=\"" + menuId + "\" /> ");
      this.menus[quadId][menuId] = menuElement;
      if (menu.getTitle()) {
        menuElement.append("<li class=\"menu-title\"\n	data-menu-id=\"" + menuId + "\"\n	data-quad-id=\"" + quadId + "\"\n	>\n	" + (menu.getTitle()) + "\n</li>");
      }
      ref = menu.items;
      results = [];
      for (itemId in ref) {
        item = ref[itemId];
        item.setMenu(this.menu);
        itemElement = jQuery("<li>\n	<a href=\"" + (item.getHref()) + "\"\n		data-item-id=\"" + itemId + "\"\n		data-menu-id=\"" + menuId + "\"\n		data-quad-id=\"" + quadId + "\"\n		>\n		" + (item.getTitle()) + "\n	</a>\n</li>");
        menuElement.append(itemElement);
        this.items[quadId][menuId][itemId] = itemElement;
        if (quadId === 1 || quadId === 2) {
          results.push(this.quads[quadId].prepend(menuElement));
        } else {
          results.push(this.quads[quadId].append(menuElement));
        }
      }
      return results;
    };

    return Renderer;

  })();

}).call(this);

//# sourceMappingURL=quad-menu.js.map
