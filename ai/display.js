// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['inject', 'colors'], function(inject, colors) {
    var Display;
    Display = (function() {
      function Display() {
        this.register = __bind(this.register, this);
        this.boid = __bind(this.boid, this);
        this.step = __bind(this.step, this);
        this.entities = [];
        inject.bind('step', this.step);
        inject.bind('register display', this.register);
      }

      Display.prototype.step = function() {
        var entity, _i, _len, _ref, _results;
        _ref = this.entities;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          entity = _ref[_i];
          _results.push(this[entity.n](entity.e()));
        }
        return _results;
      };

      Display.prototype.boid = function(e) {
        var color;
        fill(colors.bg);
        color = colors.blue;
        if (e.ai.iscommunity) {
          color = colors.gold;
        }
        if (e.ai.timesincetouch < 10) {
          color = colors.red;
        }
        stroke(color);
        return ellipse(e.coord.p.x, e.coord.p.y, 16, 16);
      };

      Display.prototype.register = function(entity, name) {
        entity.d = {
          n: name,
          e: function() {
            return entity;
          }
        };
        return this.entities.push(entity.d);
      };

      return Display;

    })();
    return new Display();
  });

}).call(this);
