load "colors.rb"
require "yaml"

class Game
  attr_accessor :word, :display_word, :guessed_letters, :wrong_guesses, :ww
  def initialize()
    @word = choose_word()
    @display_word = ''
    @guessed_letters = []
    @ww = false
  end

  def choose_word()
    s_word = "132123123123123"
    line = IO.readlines('dictionary.txt')
    while s_word.length > 13
      c = rand*line.length.to_i
      s_word = line[c-1]
    end
    self.word = s_word.downcase
  end

  def save_game()
    obj_to_save = self
    File.open("save.yml", "w") { |file| file.write(obj_to_save.to_yaml) }
  end

  def load_game()
    obj_to_load = YAML.load(File.read("save.yml"))
    self.guessed_letters = obj_to_load.guessed_letters
    self.word = obj_to_load.word
    self.display_word = obj_to_load.display_word
    self.wrong_guesses = obj_to_load.wrong_guesses
  end

  def get_guess(guessed_letters)
    puts "What is your guess? (You can also '$save' or '$load' your game"
    x = gets.chomp
    if x.length == 1 && !guessed_letters.include?(x)
      return x
    elsif guessed_letters.include?(x)
      puts "You already guessed that correctly."
      get_guess(guessed_letters)
    elsif x == "$save"
      save_game()
      return x
    elsif x == "$load"
      load_game()
      self.play_game(true)
      self.ww = true
    else
      puts "Wrong input. Please type in only one character."
      get_guess(guessed_letters)
    end
  end

  def put_array(array)
    array = array.uniq
    array.length.times do |x|
      print array[x] + ", "
    end
  end

  def introduction()
    puts "\nࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊ"
    puts "This is hangman game."
    puts "I randomly select a word and you must guess it by guessing one letter at a time"
    puts "You can guess incorrectly 5 times."
    puts "Have fun"
    puts "ࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊࢊ\n\n"
    puts "Press enter to continue".blink.reverse_color
    gets
  end

  def play_game(is_loaded = false)
    !is_loaded ? introduction() : true
    is_game_won = false
    !is_loaded ? self.display_word = "_" * (self.word.length-2) : true
    round_count = 5
    !is_loaded ? self.wrong_guesses = 0 : true
    !is_loaded ? self.guessed_letters = [] : true
    while self.wrong_guesses < round_count && !is_game_won
      is_guess_correct = false
      print "\nCorrectly guessed letters: ".italic
      put_array(self.guessed_letters)
      puts "\nIncorrect guesses: #{self.wrong_guesses}/#{round_count}\n".reverse_color
      puts self.display_word.bold
      puts "\n\n"
      guessed_char = self.get_guess(self.guessed_letters)
      if guessed_char ==  "$save" || guessed_char == "$load" || !defined?(guessed_char)
        return
      end
      self.word.each_char.with_index do |w_char, w_index|
        if guessed_char == w_char
          self.display_word[w_index] = guessed_char
          self.guessed_letters << guessed_char
          is_guess_correct = true        
        end
      end
      if defined?(guessed_char) && self.ww == false
        is_guess_correct ? puts("\nCorrect letter!\n".green) : puts("\nWrong letter\n".red)
      end
        self.display_word.include?("_") ? is_game_won = false : is_game_won = true
      is_guess_correct ? next : self.wrong_guesses += 1
    end
    if is_loaded || self.ww == false
      is_game_won ? puts("YOU WON. The word was ".bg_green + "#{self.word.chomp}".blink.reverse_color) : puts("YOU LOST. The word was ".bg_red + "#{self.word.chomp}".blink.reverse_color)
    end
  end

end

x = Game.new()
puts x.word
x.play_game()
