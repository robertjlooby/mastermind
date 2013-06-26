class AIPlayer
    attr_reader :past_guesses, :possible_values
    attr_accessor :next_guess
    def initialize(o_stream, i_stream)
        @past_guesses = {}
        @next_guess = "WWWW"
        @possible_values = Array.new(4){"RGBWYO"}
        @o_stream = o_stream
        @i_stream = i_stream
    end


    def guess
        @o_stream.puts @next_guess
        response = @i_stream.gets.chomp
        result = [response[1].to_i, response[4].to_i]
        @past_guesses[@next_guess] = result
        
        update_possible_values(@next_guess, result)
    end

    def update_possible_values(guess, result)
        if result[0] == 0
            if result[1] == 0
                @possible_values.each { |possibilities| possibilities.delete! guess }
            else
                @possible_values.each_with_index do |possibilities, index|
                    possibilities.delete! guess[index]
                end
            end
        end
    end
end
