class AIPlayer
    attr_reader :past_guesses, :possible_values
    attr_accessor :next_guess
    def initialize
        @past_guesses = {}
        @next_guess = "WWWW"
        @possible_values = Array.new(4){"RGBWYO"}
    end


    def write_guess
        @next_guess
    end
    
    def read_response(response)
        @past_guesses[@next_guess] = response
        
        update_possible_values(@next_guess, response)
        determine_next_guess
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

    def determine_next_guess
        next_guess = ""
        @possible_values.each do |possible_value_string|
            next_guess += possible_value_string.split("").sample
        end
        @next_guess = next_guess
    end
end
