class AIPlayer
    attr_reader :past_guesses
    attr_accessor :next_guess, :possible_values
    def initialize
        @past_guesses = {}
        @next_guess = "WWWW"
        @possible_values = Array.new(4){"RGBWYO"}
    end

    def figured_out_positions
        figured_out_positions = []
        (0..3).each do |i|
            figured_out_positions.push i if @possible_values[i].length == 1
        end
        figured_out_positions
    end

    def not_figured_out_positions
        [0, 1, 2, 3] - figured_out_positions
    end

    def num_figured_out
        figured_out_positions.length
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
        case result.to_s
        when /\[0, 0\]/
            @possible_values.each { |possibilities| possibilities.delete! guess }
        when /\[0, [1-4]\]/
            @possible_values.each_with_index do |possibilities, index|
                possibilities.delete! guess[index]
            end
        when /\[#{num_figured_out}, 0\]/
            values_not_in_answer = ""
            not_figured_out_positions.each do |bad_position|
                values_not_in_answer += guess[bad_position]
            end
            not_figured_out_positions.each do |bad_position|
                @possible_values[bad_position].delete! values_not_in_answer
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
