(function() {
  if (!this.Maslosoft) {
    this.Maslosoft = {};
  }

  if (!this.Maslosoft.QuadMenu) {
    this.Maslosoft.QuadMenu = {};
  }

  this.Maslosoft.QuadMenu.Options = (function() {
    function Options() {}

    Options.prototype.region = 'body';

    Options.prototype.quads = [];

    return Options;

  })();

  this.Maslosoft.QuadMenu.Menu = (function() {
    function Menu() {}

    Menu.prototype.getTitle = function() {};

    return Menu;

  })();

  this.Maslosoft.QuadMenu.Quad = (function() {
    function Quad() {}

    Quad.prototype.getTitle = function() {};

    Quad.prototype.getItems = function() {};

    Quad.prototype.getPreffered = function() {
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

  this.Maslosoft.QuadMenu.Menu = (function() {
    Menu.prototype.options = null;

    Menu.prototype.quads = [[], [], [], []];

    function Menu(options) {
      var i, len, quad, ref;
      this.options = options != null ? options : new Maslosoft.QuadMenu.Options;
      ref = this.options.quads;
      for (i = 0, len = ref.length; i < len; i++) {
        quad = ref[i];
        this.add(quad);
      }
    }

    Menu.prototype.add = function(quad) {
      var i, id, j, len, preferred, quads, ref, size;
      preferred = intVal(quad.getPreferred());
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
