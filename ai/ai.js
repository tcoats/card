// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['inject', 'hub', 'p2'], function(inject, hub, p2) {
    var AI;
    AI = (function() {
      function AI() {
        this.cohere = __bind(this.cohere, this);
        this.align = __bind(this.align, this);
        this.separate = __bind(this.separate, this);
        this.register = __bind(this.register, this);
        this.step = __bind(this.step, this);
        this.setup = __bind(this.setup, this);
        this.entities = [];
        inject.bind('setup', this.setup);
        inject.bind('step', this.step);
        inject.bind('register ai', this.register);
      }

      AI.prototype.setup = function() {
        return inject.one('stat notify')('istouched', (function(_this) {
          return function(entity, _, istouched) {
            if (istouched) {
              return inject.one('abs stat')(entity, {
                timesincetouch: 0
              });
            } else {
              return inject.one('rel stat')(entity, {
                timesincetouch: 1
              });
            }
          };
        })(this));
      };

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
        averagerepulsion = [0, 0];
        inject.one('each by distance')(entity.e().phys.b.position, 25, (function(_this) {
          return function(d, e) {
            var diff;
            if (e === entity.e() || (e.ai == null)) {
              return;
            }
            diff = [0, 0];
            p2.vec2.sub(diff, entity.e().phys.b.position, e.phys.b.position);
            p2.vec2.normalize(diff, diff);
            return p2.vec2.add(averagerepulsion, averagerepulsion, diff);
          };
        })(this));
        istouched = p2.vec2.len(averagerepulsion) !== 0;
        inject.one('abs stat')(entity.e(), {
          istouched: istouched
        });
        if (!istouched) {
          return;
        }
        inject.one('scale to max velocity')(averagerepulsion);
        force = inject.one('calculate steering')(entity.e().phys.b.velocity, averagerepulsion);
        p2.vec2.scale(force, force, 2);
        return inject.one('apply force')(entity.e(), force);
      };

      AI.prototype.align = function(entity) {
        var averagedirection, count, force;
        averagedirection = [0, 0];
        count = 0;
        inject.one('each by distance')(entity.e().phys.b.position, 50, (function(_this) {
          return function(d, e) {
            if (e === entity.e() || (e.ai == null)) {
              return;
            }
            p2.vec2.add(averagedirection, averagedirection, e.phys.b.velocity);
            return count++;
          };
        })(this));
        if (p2.vec2.len(averagedirection) === 0) {
          return;
        }
        inject.one('scale to max velocity')(averagedirection);
        force = inject.one('calculate steering')(entity.e().phys.b.velocity, averagedirection);
        p2.vec2.scale(force, force, 0.5);
        return inject.one('apply force')(entity.e(), force);
      };

      AI.prototype.cohere = function(entity) {
        var averageposition, count, force, iscommunity, targetvelocity;
        averageposition = [0, 0];
        count = 0;
        inject.one('each by distance')(entity.e().phys.b.position, 100, (function(_this) {
          return function(d, e) {
            if (e === entity.e() || (e.ai == null)) {
              return;
            }
            p2.vec2.add(averageposition, averageposition, e.phys.b.position);
            return count++;
          };
        })(this));
        inject.one('abs stat')(entity.e(), {
          iscommunity: count > 0
        });
        iscommunity = count > 0;
        if (p2.vec2.len(averageposition) === 0) {
          return;
        }
        p2.vec2.scale(averageposition, averageposition, 1 / count);
        targetvelocity = inject.one('calculate seeking')(entity.e().phys.b.position, averageposition);
        force = inject.one('calculate steering')(entity.e().phys.b.velocity, targetvelocity);
        p2.vec2.scale(force, force, 1);
        return inject.one('apply force')(entity.e(), force);
      };

      return AI;

    })();
    return new AI();
  });

}).call(this);
