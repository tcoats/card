// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['inject', 'boid'], function(inject, Boid) {
    var AI;
    AI = (function() {
      function AI() {
        this.step = __bind(this.step, this);
        var _, _i, _j;
        this.boids = [];
        for (_ = _i = 0; _i <= 90; _ = ++_i) {
          this.boids.push(new Boid(createVector(random(width), random(height)), p5.Vector.random2D(), createVector(0, 0), 'boid'));
        }
        for (_ = _j = 0; _j <= 10; _ = ++_j) {
          this.boids.push(new Boid(createVector(random(width), random(height)), p5.Vector.random2D(), createVector(0, 0), 'boid2'));
        }
        inject.bind('step', this.step);
      }

      AI.prototype.step = function() {
        var boid, _i, _len, _ref, _results;
        _ref = this.boids;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          boid = _ref[_i];
          _results.push(boid.step(this.boids));
        }
        return _results;
      };

      return AI;

    })();
    return new AI();
  });

}).call(this);
