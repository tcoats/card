// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['inject'], function(inject) {
    var Statistics;
    Statistics = (function() {
      function Statistics() {
        this.register = __bind(this.register, this);
        this.step = __bind(this.step, this);
        this.entities = [];
        inject.bind('step', this.step);
        inject.bind('register statistics', this.register);
      }

      Statistics.prototype.step = function() {};

      Statistics.prototype.register = function(entity, n) {
        entity.stats = {
          n: n,
          e: function() {
            return entity;
          }
        };
        return this.entities.push(entity.stats);
      };

      return Statistics;

    })();
    return new Statistics;
  });

}).call(this);
