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

    Options.prototype.quads = [];

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
    function ItemBase() {}

    ItemBase.prototype.visible = true;

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

    Item.prototype.setMenu = function(menu) {
      this.menu = menu;
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

  this.Maslosoft.QuadMenu.Quad = (function(superClass) {
    extend(Quad, superClass);

    Quad.prototype.title = '';

    Quad.prototype.items = [];

    function Quad(options) {
      var name, value;
      if (options == null) {
        options = {};
      }
      for (name in options) {
        value = options[name];
        this[name] = value;
      }
    }

    Quad.prototype.setTitle = function(title) {
      this.title = title;
    };

    Quad.prototype.getTitle = function() {
      return this.title;
    };

    Quad.prototype.getItems = function() {};

    Quad.prototype.getPreferred = function() {
      return -1;
    };

    return Quad;

  })(this.Maslosoft.QuadMenu.ItemBase);

  this.Maslosoft.QuadMenu.Renderer = (function() {
    Renderer.prototype.menu = null;

    Renderer.prototype.container = null;

    Renderer.prototype.quads = [];

    function Renderer(menu) {
      var i, id, quad;
      this.menu = menu;
      this.add = bind(this.add, this);
      this.close = bind(this.close, this);
      this.open = bind(this.open, this);
      this.container = jQuery("<div class=\"maslosoft-quad-menu\"></div>");
      if (this.menu.options.showSpot) {
        this.container.append("<div class=\"quad-spot\" /> ");
      }
      for (id = i = 0; i < 4; id = ++i) {
        quad = jQuery("<div class='quad-" + id + "' />");
        this.quads.push(quad);
        this.container.append(quad);
      }
      jQuery('body').append(this.container);
    }

    Renderer.prototype.open = function(x, y) {
      var i, id, isVisible, len, quad, quadElement, ref, show;
      this.container.css('left', x);
      this.container.css('top', y);
      this.container.show();
      ref = this.menu.quads;
      for (id = i = 0, len = ref.length; i < len; id = ++i) {
        quad = ref[id];
        quadElement = this.container.find(".quad-" + id);
        show = true;
        isVisible = quadElement.is(":visible");
        if (show && !isVisible) {
          quadElement.show();
        }
        if (!show && isVisible) {
          quadElement.hide();
        }
      }
      return this.container.find('a').each((function(_this) {
        return function(index, element) {
          var item;
          element = jQuery(element);
          item = _this.menu.getItem(element.data());
          isVisible = element.is(":visible");
          show = item.isVisible();
          if (show && !isVisible) {
            element.show();
          }
          if (!show && isVisible) {
            element.hide();
          }
          return console.log(item);
        };
      })(this));
    };

    Renderer.prototype.close = function() {
      return this.container.hide();
    };

    Renderer.prototype.add = function(id, menuId, quad) {
      var item, itemElement, itemId, ref, results;
      if (quad.getTitle()) {
        this.quads[id].append("<li class=\"quad-title\"\n	data-menu-id=\"" + menuId + "\"\n	data-quad-id=\"" + id + "\"\n	>\n	" + (quad.getTitle()) + "\n</li>");
      }
      ref = quad.items;
      results = [];
      for (itemId in ref) {
        item = ref[itemId];
        item.setMenu(this.menu);
        itemElement = "<li>\n	<a href=\"" + (item.getHref()) + "\"\n		data-item-id=\"" + itemId + "\"\n		data-menu-id=\"" + menuId + "\"\n		data-quad-id=\"" + id + "\"\n		>\n		" + (item.getTitle()) + "\n	</a>\n</li>";
        if (id === 1 || id === 2) {
          results.push(this.quads[id].prepend(itemElement));
        } else {
          results.push(this.quads[id].append(itemElement));
        }
      }
      return results;
    };

    return Renderer;

  })();

  this.Maslosoft.QuadMenu.Menu = (function(superClass) {
    extend(Menu, superClass);

    Menu.prototype.options = null;

    Menu.prototype.quads = [[], [], [], []];

    Menu.prototype.menu = null;

    Menu.prototype.renderer = null;

    function Menu(options) {
      var i, len, quad, ref;
      if (options == null) {
        options = {};
      }
      this.close = bind(this.close, this);
      this.open = bind(this.open, this);
      this.preventContext = bind(this.preventContext, this);
      this.itemClick = bind(this.itemClick, this);
      this.regionClick = bind(this.regionClick, this);
      this.options = new Maslosoft.QuadMenu.Options(options);
      this.renderer = new Maslosoft.QuadMenu.Renderer(this);
      ref = this.options.quads;
      for (i = 0, len = ref.length; i < len; i++) {
        quad = ref[i];
        this.add(quad);
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

    Menu.prototype.regionClick = function(e) {
      if (e.which === 3) {
        this.open(e.clientX, e.clientY);
        if (!this.options.browserContext) {
          return e.preventDefault();
        }
      } else {
        return this.close();
      }
    };

    Menu.prototype.itemClick = function(e) {
      var data, item;
      data = jQuery(e.target).data();
      item = this.getItem(data);
      if (item) {
        item.onClick(e, item);
      }
      return e.stopPropagation();
    };

    Menu.prototype.preventContext = function(e) {
      e.preventDefault();
      if (!this.options.browserContext) {
        return e.preventDefault();
      }
    };

    Menu.prototype.prevent = function(e) {
      return e.preventDefault();
    };

    Menu.prototype.getItem = function(data) {
      var item, quad, quadItems;
      item = null;
      quadItems = this.quads[data.quadId];
      if (quadItems) {
        quad = quadItems[data.menuId];
      }
      if (quad) {
        item = quad.items[data.itemId];
      }
      return item;
    };

    Menu.prototype.getMenu = function(data) {};

    Menu.prototype.getQuad = function(data) {
      return this.quads[data.quadId];
    };

    Menu.prototype.open = function(x, y) {
      return this.renderer.open(x, y);
    };

    Menu.prototype.close = function() {
      return this.renderer.close();
    };

    Menu.prototype.add = function(quad) {
      var i, id, j, len, menuId, preferred, quads, ref, size;
      preferred = parseInt(quad.getPreferred());
      if (preferred < -1 || preferred > 3) {
        throw new Error('Preferred quad must be between -1 and 3');
      }
      if (preferred >= 0) {
        this.quads[preferred].push(quad);
      }
      for (size = i = 0; i < 4; size = ++i) {
        ref = this.quads;
        for (id = j = 0, len = ref.length; j < len; id = ++j) {
          quads = ref[id];
          if (quads.length === size) {
            menuId = quads.push(quad);
            this.renderer.add(id, menuId - 1, quad);
            return;
          }
        }
      }
    };

    return Menu;

  })(this.Maslosoft.QuadMenu.ItemBase);

}).call(this);

//# sourceMappingURL=quad-menu.js.map
