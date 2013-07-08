class AIPlayer
    attr_accessor :next_guess, :possible_values
    def initialize(logic_class)
        @next_guess = "WYOO"
        @possible_values = []
        %w(R G B W Y O).repeated_permutation(4) do |perm|
            @possible_values << perm.join
        end
        @game_logic = logic_class.new
    end

    def get_guess
        next_guess
    end

    def return_response(response)
        response = response.upcase
        /\[(?<red>\d+), (?<white>\d+)\]/ =~ response
        response_arr = [red.to_i, white.to_i]
        
        update_possible_values(@next_guess, response_arr)
        determine_next_guess
    end

    def update_possible_values(guess, response)
        @possible_values.delete_if do |possible_value| 
            @game_logic.respond(guess, possible_value) != response
        end
    end

    def determine_next_guess
        @next_guess = @possible_values.first
    end
end
