# chess
Assignment:

 - Build a command line Chess game where two players can play against each other.
 - The game should be properly constrained – it should prevent players from making illegal moves and declare check or      check mate in the correct situations.
 - Make it so you can save the board at any time
 - Write tests for the important parts.

You'll be need a Ruby gem 'colorize'

To install, type: gem install colorize

To start a program, type: ruby lib/main.rb

To run tests, type: rspec spec/

To make a move, type 'piece position',a space, the position of target square.
Example: e2 e4

To castling, type 'Castling', a space, the king position, the position of target square.
Example: Castling e8 g8

To save a game, type: save.
Example: save
