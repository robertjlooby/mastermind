class AIPlayer
    attr_reader :past_guesses
    attr_accessor :next_guess, :possible_values, :stored_decisions
    def initialize(i_stream, o_stream)
        @past_guesses = {}
        @stored_decisions = []
        @next_guess = "WWWW"
        @possible_values = Array.new(4){"RGBWYO"}
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
        response_arr = [red.to_i, white.to_i]
        @past_guesses[@next_guess] = response_arr
        
        update_possible_values(@next_guess, response_arr)
        determine_next_guess
    end

    def delete_from_positions(str, positions)
        positions.each do |position|
            @possible_values[position].delete! str
        end
    end

    def update_possible_values(guess, response)
        guess_arr = guess.split("")
        case response
        when [4, 0]
            @possible_values = guess_arr
        when [3, 0]
            (0..3).each do |position|
                @stored_decisions.push lambda {
                    
                    return false if @possible_values[position].include? guess_arr[position]
                    other_positions = (0..3).to_a
                    other_positions.delete(position)
                    other_positions.each do |other_position|
                        @possible_values[other_position] = guess_arr[other_position]
                    end
                    true
                }
            end
            (0..3).each do |position|
                @stored_decisions.push lambda {
                    other_positions = (0..3).to_a - [position]
                    other_positions.each do |other_position|
                        return false unless @possible_values[other_position] == guess_arr[other_position]
                    end
                    delete_from_positions(guess_arr[position], [position])
                    false
                }
            end
        when [2, 0]
            (0..3).to_a.combination(2) do |positions|
                @stored_decisions.push lambda {
                    positions.each do |position|
                        return false if @possible_values[position].include? guess_arr[position]
                    end
                    other_positions = (0..3).to_a - positions
                    other_positions.each do |other_position|
                        @possible_values[other_position] = guess_arr[other_position]
                    end
                    true
                }
            end
            (0..3).to_a.combination(2) do |positions|
                @stored_decisions.push lambda {
                    positions.each do |position|
                        return false unless @possible_values[position] == guess_arr[position]
                    end
                    bad_letters = ""
                    other_positions = (0..3).to_a - positions
                    other_positions.each do |other_position|
                        bad_letters += guess_arr[other_position]
                    end
                    delete_from_positions(bad_letters, other_positions)
                }
            end
        when [0, 0]
            delete_from_positions guess, (0..3)
        end
        call_stored_decisions
    end

    def call_stored_decisions
        stored_decisions_changed = false
        stored_decisions.delete_if do |stored_decision|
            stored_decisions_changed = true if stored_decision.call
        end
        call_stored_decisions if stored_decisions_changed
    end

    def determine_next_guess
        next_guess = ""
        @possible_values.each do |possible_value_string|
            next_guess += possible_value_string.split("").sample
        end
        @next_guess = next_guess
    end
end
