# frozen_string_literal: true

require 'json'

# This class saves the game table.
class SaveGame
  def initialize(data)
    @data = data
  end

  def save
    save = to_json
    dirname = 'save_files'
    puts "\nEnter a save file name."
    file_name = gets.chomp
    save_file = File.open("./#{dirname}/#{file_name}.json", 'w')
    save_file.write(save)
    save_file.close
    puts "\nYour game has been saved."
  end

  private

  def to_json(*args)
    {
      'json_class' => self.class.name,
      'data' => @data
    }.to_json(*args)
  end
end

