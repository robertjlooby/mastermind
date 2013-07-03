class GameLogic
    attr_accessor :code
    def initialize(code, i_stream, o_stream)
        @code = code
        @i_stream = i_stream
        @o_stream = o_stream
    end

    def respond
        red = white = 0
        guess = @i_stream.gets.chomp.split("")
        actual = @code.split("")

        (0 ... guess.length).each do |index|
            if guess[index] == actual[index]
                red += 1 
                guess[index] = actual[index] = nil
            end
        end
        guess.compact!
        actual.compact!

        guess.each do |c|
            if actual.include? c
                white += 1
                actual.delete_at actual.index(c)
            end
        end

        @o_stream.puts [red, white].to_s
        [red, white]
    end
end
