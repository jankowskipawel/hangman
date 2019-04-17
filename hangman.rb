load "colors.rb"

class Game
  attr_accessor :word
  def initialize()
    @word = choose_word()
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

  def get_guess(guessed_letters)
    puts "What is your guess?"
    x = gets.chomp
    if x.length == 1 && !guessed_letters.include?(x)
      return x
    elsif guessed_letters.include?(x)
      puts "You already guessed that correctly."
      get_guess(guessed_letters)
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

  def play_game()
    introduction()
    is_game_won = false
    display_word = "_" * (self.word.length-2)
    round_count = 5
    i = 0
    guessed_letters = []
    while i < round_count && !is_game_won
      is_guess_correct = false
      print "\nCorrectly guessed letters: ".italic
      put_array(guessed_letters)
      puts "\nIncorrect guesses: #{i}/#{round_count}\n".reverse_color
      puts display_word.bold
      puts "\n\n"
      guessed_char = self.get_guess(guessed_letters)
      self.word.each_char.with_index do |w_char, w_index|
        if guessed_char == w_char
          display_word[w_index] = guessed_char
          guessed_letters << guessed_char
          is_guess_correct = true        
        end
      end
      is_guess_correct ? puts("\nCorrect letter!\n".green) : puts("\nWrong letter\n".red)
      display_word.include?("_") ? is_game_won = false : is_game_won = true
      is_guess_correct ? next : i += 1
    end

    is_game_won ? puts("YOU WON".bg_green) : puts("YOU LOST. The word was ".bg_red + "#{self.word.chomp}".blink.reverse_color)
    
  end

end

x = Game.new()
puts x.word
x.play_game()


#to save file, i, guessed_letters, display_word, word, 