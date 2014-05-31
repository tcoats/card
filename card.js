// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  requirejs.config({
    paths: {
      jquery: 'bower_components/jquery/jquery.min',
      fontawesome: 'bower_components/font-awesome/css/font-awesome.min',
      uuid: 'bower_components/node-uuid/uuid',
      q: 'bower_components/q/q',
      humanize: 'bower_components/humanize/public/dist/humanize.min',
      moment: 'bower_components/momentjs/min/moment.min',
      interact: 'bower_components/interact/interact.min',
      screenfull: 'bower_components/screenfull/dist/screenfull.min',
      bootstrap: 'bower_components/bootstrap/dist/js/bootstrap.min',
      bootstrapcss: 'bower_components/bootstrap/dist/css/bootstrap',
      velocity: 'bower_components/velocity/jquery.velocity.min',
      hammer: 'bower_components/hammerjs/hammer.min'
    },
    map: {
      '*': {
        css: 'bower_components/require-css/css.min'
      }
    },
    shim: {
      bootstrap: {
        deps: ['jquery']
      },
      velocity: {
        deps: ['jquery']
      },
      humanize: {
        exports: 'Humanize'
      },
      interact: {
        exports: 'interact'
      },
      screenfull: {
        exports: 'screenfull'
      }
    },
    urlArgs: 'v=' + (new Date()).getTime()
  });

  define(['jquery', 'interact', 'screenfull', 'hammer', 'bootstrap', 'velocity', 'css!bootstrapcss', 'css!fontawesome', 'css!card'], function($, interact, screenfull, Hammer) {
    var $board, Card, cards, delay;
    $.fn.velocity = function() {
      var options, propertiesMap, _velocity;
      _velocity = $.velocity || Zepto.velocity || window.velocity;
      if (arguments[0].properties != null) {
        propertiesMap = arguments[0].properties;
        options = arguments[0].options;
        return _velocity.animate.call(this, propertiesMap, options);
      } else {
        return _velocity.animate.apply(this, arguments);
      }
    };
    Card = (function() {
      function Card(container) {
        this.animate = __bind(this.animate, this);
        this.hide = __bind(this.hide, this);
        this._ondragend = __bind(this._ondragend, this);
        this._ondragmove = __bind(this._ondragmove, this);
        this._ondragstart = __bind(this._ondragstart, this);
        this.x = 0;
        this.y = 0;
        this.elcc = $('<div />').addClass('card-c');
        this.elc = $('<div />').addClass('card').appendTo(this.elcc);
        $('<h3>Ion Cannon</h3>').appendTo(this.elc);
        $('<p>Ion Cannon is online, requesting firing coodinates</p>').appendTo(this.elc);
        $('<span class="action">6</span>').appendTo(this.elc);
        $('<span class="attack">10</span>').appendTo(this.elc);
        $('<span class="armour">1</span>').appendTo(this.elc);
        container.append(this.elcc);
        interact(this.elc[0]).draggable({
          onstart: this._ondragstart,
          onmove: this._ondragmove,
          onend: this._ondragend
        });
        this.elc.velocity({
          properties: {
            translateZ: 0
          },
          options: {
            duration: 0
          }
        });
      }

      Card.prototype._ondragstart = function(e) {
        this.elcc.css('z-index', 1);
        return this.elc.velocity('stop').velocity({
          properties: {
            translateZ: 100
          },
          options: {
            duration: 100
          }
        });
      };

      Card.prototype._ondragmove = function(e) {
        var dx, dy;
        this.x += e.dx;
        this.y += e.dy;
        dx = Math.max(Math.min(e.dx * 1.5, 45), -45);
        dy = Math.max(Math.min(e.dy * 1.5, 45), -45);
        this.elcc.velocity({
          properties: {
            translateX: this.x,
            translateY: this.y
          },
          options: {
            duration: 0
          }
        });
        return this.elc.velocity('stop').velocity({
          properties: {
            rotateY: dx,
            rotateX: -dy
          },
          options: {
            duration: 0
          }
        });
      };

      Card.prototype._ondragend = function(e) {
        return this.elc.velocity({
          properties: {
            rotateY: 0,
            rotateX: 0
          },
          options: {
            duration: 100
          }
        }).velocity({
          properties: {
            translateZ: 0
          },
          options: {
            duration: 100,
            complete: (function(_this) {
              return function() {
                return _this.elcc.css('z-index', 0);
              };
            })(this)
          }
        });
      };

      Card.prototype.hide = function() {
        return this.elcc.hide();
      };

      Card.prototype.animate = function(done) {
        return this.elcc.show().velocity({
          properties: {
            translateY: [this.y, 0],
            translateX: [this.x, 'easeOutSine', 1000],
            rotateZ: [0, 'easeOutSine', 90],
            rotateY: [0, 'easeInSine', -90]
          },
          options: {
            complete: done
          }
        });
      };

      return Card;

    })();
    $board = $('#board');
    cards = [new Card($board), new Card($board), new Card($board), new Card($board)];
    delay = function(func, time) {
      return setTimeout(func, time);
    };
    return $board.find('button').on('click', function() {
      var card, wait, _i, _len, _results;
      wait = 0;
      _results = [];
      for (_i = 0, _len = cards.length; _i < _len; _i++) {
        card = cards[_i];
        card.hide();
        delay(card.animate, wait);
        _results.push(wait += 200);
      }
      return _results;
    });
  });

}).call(this);