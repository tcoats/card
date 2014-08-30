// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['inject'], function(inject) {
    var Coordinates;
    Coordinates = (function() {
      function Coordinates() {
        this.eachbydistance = __bind(this.eachbydistance, this);
        this.delta = __bind(this.delta, this);
        this.register = __bind(this.register, this);
        this.step = __bind(this.step, this);
        this.entities = [];
        inject.bind('step', this.step);
        inject.bind('register coordinates', this.register);
        inject.bind('delta position', this.delta);
        inject.bind('each by distance', this.eachbydistance);
      }

      Coordinates.prototype.step = function() {
        var entity, _i, _len, _ref, _results;
        _ref = this.entities;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          entity = _ref[_i];
          if (entity.p.x < -10) {
            entity.p.x = width + 10;
          }
          if (entity.p.x > width + 10) {
            entity.p.x = -10;
          }
          if (entity.p.y < -10) {
            entity.p.y = height + 10;
          }
          if (entity.p.y > height + 10) {
            _results.push(entity.p.y = -10);
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      Coordinates.prototype.register = function(entity, p) {
        entity.coord = {
          p: p,
          e: function() {
            return entity;
          }
        };
        return this.entities.push(entity.coord);
      };

      Coordinates.prototype.delta = function(entity, d) {
        return entity.coord.p.add(d);
      };

      Coordinates.prototype.eachbydistance = function(p, r, cb) {
        var distance, entity, _i, _len, _ref, _results;
        _ref = this.entities;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          entity = _ref[_i];
          distance = p5.Vector.dist(p, entity.p);
          if (distance > r) {
            continue;
          }
          _results.push(cb(distance, entity.e()));
        }
        return _results;
      };

      return Coordinates;

    })();
    return new Coordinates();
  });

}).call(this);
