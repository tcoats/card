// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['inject', 'hub'], function(inject, hub) {
    var AI;
    AI = (function() {
      function AI() {
        this.cohere = __bind(this.cohere, this);
        this.align = __bind(this.align, this);
        this.separate = __bind(this.separate, this);
        this.register = __bind(this.register, this);
        this.step = __bind(this.step, this);
        this.entities = [];
        inject.bind('step', this.step);
        inject.bind('register ai', this.register);
      }

      AI.prototype.step = function() {
        var entity, _i, _len, _ref, _results;
        _ref = this.entities;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          entity = _ref[_i];
          this.separate(entity);
          this.align(entity);
          _results.push(this.cohere(entity));
        }
        return _results;
      };

      AI.prototype.register = function(entity, n) {
        entity.ai = {
          n: n,
          e: function() {
            return entity;
          }
        };
        return this.entities.push(entity.ai);
      };

      AI.prototype.separate = function(entity) {
        var averagerepulsion, force, istouched;
        averagerepulsion = createVector(0, 0);
        inject.one('each by distance')(entity.e().coord.p, 25, (function(_this) {
          return function(d, boid) {
            var diff;
            if (boid === entity.e() || (boid.ai == null)) {
              return;
            }
            diff = p5.Vector.sub(entity.e().coord.p, boid.coord.p);
            diff.div(diff.mag() * 2);
            return averagerepulsion.add(diff);
          };
        })(this));
        istouched = averagerepulsion.mag() !== 0;
        inject.one('absolute statistic')(entity.e(), {
          istouched: istouched
        });
        if (!istouched) {
          inject.one('relative statistic')(entity.e(), {
            timesincetouch: 1
          });
          return;
        }
        inject.one('absolute statistic')(entity.e(), {
          timesincetouch: 0
        });
        force = inject.one('calculate steering')(entity.e(), averagerepulsion);
        force.mult(4.5);
        return inject.one('apply force')(entity.e(), force);
      };

      AI.prototype.align = function(entity) {
        var averagedirection, forece;
        averagedirection = createVector(0, 0);
        inject.one('each by distance')(entity.e().coord.p, 50, (function(_this) {
          return function(d, boid) {
            if (boid === entity.e() || (boid.ai == null)) {
              return;
            }
            return averagedirection.add(boid.phys.v);
          };
        })(this));
        if (averagedirection.mag() === 0) {
          return;
        }
        forece = inject.one('calculate steering')(entity.e(), averagedirection);
        forece.mult(1.0);
        return inject.one('apply force')(entity.e(), forece);
      };

      AI.prototype.cohere = function(entity) {
        var averageposition, count, direction, force, iscommunity;
        averageposition = createVector(0, 0);
        count = 0;
        inject.one('each by distance')(entity.e().coord.p, 100, (function(_this) {
          return function(d, boid) {
            if (boid === entity.e() || (boid.ai == null)) {
              return;
            }
            averageposition.add(boid.coord.p);
            return count++;
          };
        })(this));
        inject.one('absolute statistic')(entity.e(), {
          iscommunity: count > 0
        });
        iscommunity = count > 0;
        if (averageposition.mag() === 0) {
          return;
        }
        averageposition.div(count);
        direction = p5.Vector.sub(averageposition, entity.e().coord.p);
        force = inject.one('calculate steering')(entity.e(), direction);
        force.mult(1.0);
        return inject.one('apply force')(entity.e(), force);
      };

      return AI;

    })();
    return new AI();
  });

}).call(this);
