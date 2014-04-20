// Generated by CoffeeScript 1.7.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['infra/hub', 'infra/delay'], function(hub, delay) {
    var Input;
    Input = (function() {
      function Input() {
        this.randomlySelectStartingPlayer = __bind(this.randomlySelectStartingPlayer, this);
        this.player2ChooseDeck = __bind(this.player2ChooseDeck, this);
        this.player1ChooseDeck = __bind(this.player1ChooseDeck, this);
        hub.on('Player 1 choose deck', this.player1ChooseDeck);
        hub.on('Player 2 choose deck', this.player2ChooseDeck);
        hub.on('Randomly select starting player', this.randomlySelectStartingPlayer);
      }

      Input.prototype.player1ChooseDeck = function() {
        return delay(500, function() {
          return hub.emit('Player 1 has chosen {deck} deck', {
            deck: 'Aggro'
          });
        });
      };

      Input.prototype.player2ChooseDeck = function() {
        return delay(500, function() {
          return hub.emit('Player 2 has chosen {deck} deck', {
            deck: 'Control'
          });
        });
      };

      Input.prototype.randomlySelectStartingPlayer = function() {
        return delay(500, function() {
          return hub.emit('Player 2 will start');
        });
      };

      return Input;

    })();
    return new Input();
  });

}).call(this);
