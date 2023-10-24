# frozen_string_literal: true

require_relative 'round'

# This class implements a chess game.
class Chess
  attr_accessor :args

  def initialize(args)
    @args = args
  end

  def play_chess
    start_message
    game_args = start_game
    round = create_round(game_args)
    round.print_board

    loop do
      break if round.play == true
    end
  end

  private

  def start_message
    puts <<~MESSAGE
      Welcome to the game of chess.
      Chess is a board game for two players, called White and Black,
      each controlling an army of chess pieces in their color,
      with the objective to checkmate the opponent's king.
    MESSAGE
  end

  def choose_mode
    input = ''

    until /[new]|[save]/.match?(input)
      puts "\nType 'new' to start a new game.\nType 'load' to load your saved game."
      input = gets.chomp
    end
    input
  end

  def start_game
    input = choose_mode

    case input
    when 'new'
      args
    when 'load'
      return args if no_save_files?

      load_save
    end
  end

  def create_round(arguments)
    Round.new(arguments)
  end

  def no_save_files?
    return false unless Dir.empty?('./save_files')

    puts "You doesn't have save files! Begining a new game!"
    true
  end

  def process_save_file(name_file)
    save_file = File.open("./save_files/#{name_file}", 'r')
    save_data = save_file.read
    save_file.close
    Marshal.load(save_data)
  end

  def load_save
    puts "\nSelect the save file and enter its name.\n\n"

    files = Dir.glob('save_files/*', base: '.').map { |name| name.delete_prefix('save_files/') }

    puts files

    name_file = gets.chomp
    raise InvalidInputError, "\nYou are entering an invalid file name" unless files.any? { |name| name == name_file }
  rescue InvalidInputError => e
    puts e
    retry
  else
    process_save_file(name_file)
  end
end

class InvalidInputError < StandardError; end
