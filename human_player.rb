class HumanPlayer
    def initialize(game_logic = nil, display_i_stream = $stdin, display_o_stream = $stdout)
        @display_i_stream = display_i_stream
        @display_o_stream = display_o_stream
    end

    def get_guess
        @display_o_stream.puts "Please enter your guess: (as a string of 4 letters, RGBWYO)"
        guess_input = @display_i_stream.gets.chomp.upcase
        unless guess_input.match(/^[RGBWYO]{4}$/).to_s == guess_input
            @display_o_stream.puts "Your guess is not in the correct format, please try again"
            return get_guess
        end
        guess_input
    end

    def return_response(response)
        @display_o_stream.puts response
    end
end
