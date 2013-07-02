class HumanPlayer
    def initialize(i_stream, o_stream, display_i_stream = $stdin, display_o_stream = $stdout)
        @i_stream = i_stream
        @o_stream = o_stream
        @display_i_stream = display_i_stream
        @display_o_stream = display_o_stream
    end

    def guess
        @display_o_stream.puts "Please enter your guess: (as a string of 4 letters, RGBWYO)"
        guess_input = @display_i_stream.gets.chomp.upcase
        unless guess_input.match(/^[RGBWYO]{4}$/).to_s == guess_input
            @display_o_stream.puts "Your guess is not in the correct format, please try again"
            return guess
        end
        @o_stream.puts guess_input
        response = @i_stream.gets
        @display_o_stream.puts response
    end
end
