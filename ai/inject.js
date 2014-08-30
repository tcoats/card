// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(function() {
    var Inject;
    Inject = (function() {
      function Inject() {
        this.clear = __bind(this.clear, this);
        this.many = __bind(this.many, this);
        this.firstornone = __bind(this.firstornone, this);
        this.first = __bind(this.first, this);
        this.oneornone = __bind(this.oneornone, this);
        this.one = __bind(this.one, this);
        this.bind = __bind(this.bind, this);
        this.bindings = {};
      }

      Inject.prototype.bind = function(key, item) {
        var i, k, _i, _len, _results;
        if (key === Object(key)) {
          for (k in key) {
            i = key[k];
            this.bind(k, i);
          }
          return;
        }
        if (this.bindings[key] == null) {
          this.bindings[key] = [];
        }
        if (Array.isArray(item)) {
          _results = [];
          for (_i = 0, _len = item.length; _i < _len; _i++) {
            i = item[_i];
            _results.push(this.bindings[key].push(i));
          }
          return _results;
        } else {
          return this.bindings[key].push(item);
        }
      };

      Inject.prototype.one = function(key) {
        var items;
        if (this.bindings[key] == null) {
          throw "[pminject] Nothing bound for '" + key + "'!";
        }
        items = this.bindings[key];
        if (items.length > 1) {
          throw "[pminject] '" + key + "' has too many bindings to inject one!";
        }
        return items[0];
      };

      Inject.prototype.oneornone = function(key) {
        var items;
        if (this.bindings[key] == null) {
          return null;
        }
        items = this.bindings[key];
        if (items.length > 1) {
          throw "[pminject] '" + key + "' has too many bindings to inject oneornone!";
        }
        return items[0];
      };

      Inject.prototype.first = function(key) {
        if (this.bindings[key] == null) {
          throw "[pminject] Nothing bound for '" + key + "'!";
        }
        return this.bindings[key][0];
      };

      Inject.prototype.firstornone = function(key) {
        if (this.bindings[key] == null) {
          return null;
        }
        return this.bindings[key][0];
      };

      Inject.prototype.many = function(key) {
        if (this.bindings[key] == null) {
          return [];
        }
        return this.bindings[key];
      };

      Inject.prototype.clear = function(key) {
        return delete this.bindings[key];
      };

      return Inject;

    })();
    return new Inject();
  });

}).call(this);
