# frozen_string_literal: true

# This class saves the game table.
class SaveGame
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def save
    save = Marshal.dump(data)
    dirname = 'save_files'
    puts "\nEnter a save file name."
    file_name = gets.chomp
    save_file = File.open("./#{dirname}/#{file_name}", 'w')
    save_file.write(save)
    save_file.close
    puts "\nYour game has been saved."
  end
end
