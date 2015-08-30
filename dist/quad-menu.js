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

    Quad.prototype.getTitle = function() {};

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
    Renderer.menu = null;

    Renderer.container = null;

    function Renderer(menu) {
      var i, id;
      this.menu = menu;
      this.add = bind(this.add, this);
      this.open = bind(this.open, this);
      this.container = jQuery('<div class="maslosoft-quad-menu"></div>');
      for (id = i = 0; i < 4; id = ++i) {
        this.container.append("<div class='quad-" + id + "' />");
      }
      jQuery('body').append(this.container);
    }

    Renderer.prototype.open = function(x, y) {
      this.container.css('left', x);
      this.container.css('top', y);
      return this.container.show();
    };

    Renderer.prototype.add = function(id, quad) {};

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
      this.open = bind(this.open, this);
      this.onContext = bind(this.onContext, this);
      this.onClick = bind(this.onClick, this);
      this.options = new Maslosoft.QuadMenu.Options(options);
      ref = this.options.quads;
      for (i = 0, len = ref.length; i < len; i++) {
        quad = ref[i];
        this.add(quad);
      }
      console.log(this.options.region);
      if (this.options.region === 'document') {
        jQuery(document).on(this.options.event, this.onClick);
        jQuery(document).on('contextmenu', this.onContext);
      } else {
        jQuery(document).on(this.options.event, this.options.region, this.onClick);
        jQuery(document).on('contextmenu', this.options.region, this.onContext);
      }
      this.renderer = new Maslosoft.QuadMenu.Renderer(this);
    }

    Menu.prototype.onClick = function(e) {
      console.log(e);
      return this.open(e.clientX, e.clientY);
    };

    Menu.prototype.onContext = function(e) {
      return e.preventDefault();
    };

    Menu.prototype.open = function(x, y) {
      return this.renderer.open(x, y);
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
        for (quads = j = 0, len = ref.length; j < len; quads = ++j) {
          id = ref[quads];
          if (quads.length === size) {
            this.quads[id].push(quad);
            return;
          }
        }
      }
    };

    return Menu;

  })();

}).call(this);

//# sourceMappingURL=quad-menu.js.map
