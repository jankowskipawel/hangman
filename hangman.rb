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

end

x = Game.new()
puts x.word
x.choose_word()
puts x.word