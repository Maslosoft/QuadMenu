(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if (!this.Maslosoft) {
    this.Maslosoft = {};
  }

  if (!this.Maslosoft.QuadMenu) {
    this.Maslosoft.QuadMenu = {};
  }

  this.Maslosoft.QuadMenu.Options = (function() {
    var browserContext;

    Options.prototype.region = 'document';

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

  this.Maslosoft.QuadMenu.Item = (function() {
    function Item() {}

    Item.prototype.getTitle = function() {};

    return Item;

  })();

  this.Maslosoft.QuadMenu.Quad = (function() {
    function Quad() {}

    Quad.prototype.title = '';

    Quad.prototype.items = [];

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

    Quad.prototype.isVisible = function() {
      return true;
    };

    Quad.prototype.inRegion = function() {
      return null;
    };

    return Quad;

  })();

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
      this.container = jQuery('<div class="maslosoft-quad-menu"></div>');
      for (id = i = 0; i < 4; id = ++i) {
        quad = jQuery("<ul class='quad-" + id + "' />");
        this.quads.push(quad);
        this.container.append(quad);
      }
      jQuery('body').append(this.container);
    }

    Renderer.prototype.open = function(x, y) {
      this.container.css('left', x);
      this.container.css('top', y);
      return this.container.show();
    };

    Renderer.prototype.close = function() {
      return this.container.hide();
    };

    Renderer.prototype.add = function(id, quad) {
      if (quad.getTitle()) {
        this.quads[id].append("<li class='quad-title'>" + (quad.getTitle()) + "</li>");
      }
      return console.log(this.quads);
    };

    return Renderer;

  })();

  this.Maslosoft.QuadMenu.Menu = (function() {
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
      this.stop = bind(this.stop, this);
      this.preventContext = bind(this.preventContext, this);
      this.onClick = bind(this.onClick, this);
      this.options = new Maslosoft.QuadMenu.Options(options);
      this.renderer = new Maslosoft.QuadMenu.Renderer(this);
      console.log(this.options);
      ref = this.options.quads;
      for (i = 0, len = ref.length; i < len; i++) {
        quad = ref[i];
        this.add(quad);
      }
      console.log(this.options.region);
      if (this.options.region === 'document') {
        jQuery(document).on(this.options.event, this.onClick);
        jQuery(document).on('contextmenu', this.preventContext);
      } else {
        jQuery(document).on(this.options.event, this.options.region, this.onClick);
        jQuery(document).on('contextmenu', this.options.region, this.preventContext);
      }
      this.renderer.container.on(this.options.event, this.stop);
      jQuery(document).on('keydown', (function(_this) {
        return function(e) {
          if (e.keyCode === 27) {
            return _this.close();
          }
        };
      })(this));
    }

    Menu.prototype.onClick = function(e) {
      if (e.which === 3) {
        this.open(e.clientX, e.clientY);
        if (!this.options.browserContext) {
          return e.preventDefault();
        }
      } else {
        return this.close();
      }
    };

    Menu.prototype.preventContext = function(e) {
      e.preventDefault();
      if (!this.options.browserContext) {
        return e.preventDefault();
      }
    };

    Menu.prototype.stop = function(e) {
      return e.stopPropagation();
    };

    Menu.prototype.open = function(x, y) {
      return this.renderer.open(x, y);
    };

    Menu.prototype.close = function() {
      return this.renderer.close();
    };

    Menu.prototype.add = function(quad) {
      var i, id, j, len, preferred, quads, ref, size;
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
          console.log(quad);
          if (quads.length === size) {
            quads.push(quad);
            this.renderer.add(id, quad);
            return;
          }
        }
      }
    };

    return Menu;

  })();

}).call(this);

//# sourceMappingURL=quad-menu.js.map
