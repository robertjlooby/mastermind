class AIPlayer
    attr_reader :past_guesses
    attr_accessor :next_guess, :possible_values, :is_to_is_not_decisions
    def initialize(i_stream, o_stream)
        @past_guesses = {}
        @next_guess = "WWWW"
        @possible_values = Array.new(4){"RGBWYO"}
        @is_to_is_not_decisions = Hash.new
        @i_stream = i_stream
        @o_stream = o_stream
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

    def guess
        @o_stream.puts next_guess
        response = @i_stream.gets.chomp.upcase
        /\[(?<red>\d+), (?<white>\d+)\]/ =~ response
        @past_guesses[@next_guess] = [red.to_i, white.to_i]
        
        update_possible_values(@next_guess, response)
        evaluate_is_to_is_not_decisions
        determine_next_guess
    end

    def delete_from_positions(str, positions)
        positions.each do |position|
            @possible_values[position].delete! str
        end
    end

    def update_possible_values(guess, result)
        result_str = result.to_s
        /\[(?<red>\d+), (?<white>\d+)\]/ =~ result_str
        
        case
        when red == 0 && white == 0
            delete_from_positions(guess, 0..3)
        when /\[0, [1-4]\]/ =~ result_str
            @possible_values.each_with_index do |possibilities, index|
                possibilities.delete! guess[index]
            end
        when /\[#{num_figured_out}, 0\]/ =~ result_str
            values_not_in_answer = ""
            not_figured_out_positions.each do |bad_position|
                values_not_in_answer += guess[bad_position]
            end
            not_figured_out_positions.each do |bad_position|
                @possible_values[bad_position].delete! values_not_in_answer
            end
        when num_figured_out == 2 && /\[2, 2\]/ =~ result_str
            pos1, pos2 = not_figured_out_positions
            @possible_values[pos1] = guess[pos2]
            @possible_values[pos2] = guess[pos1]
        when num_figured_out == 0 && /\[2, 2\]/ =~ result_str
            paired_array = [0, 1, 2, 3].zip(guess.split(""))
            paired_array.combination(2) do |conditions|
                actions = []
                paired_array.each do |possibility|
                    actions.push possibility unless conditions.include? possibility
                end
                @is_to_is_not_decisions[conditions] = actions
            end
        when /\[1, 3\]/ =~ result_str
            paired_array = [0, 1, 2, 3].zip(guess.split(""))
            paired_array.combination(1) do |condition|
                actions = []
                paired_array.each do |possibility|
                    actions.push possibility unless condition.include? possibility
                end
                @is_to_is_not_decisions[condition] = actions
            end
        end
    end

    def evaluate_is_to_is_not_decisions
        @is_to_is_not_decisions.each do |conditions, actions|
           truth_array = conditions.map do |position, value|
              @possible_values[position] == value
           end
           condition_true = truth_array.reduce { |bool1, bool2| bool1 && bool2 }
           if condition_true
               actions.each do |position, value|
                   @possible_values[position].delete! value
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
