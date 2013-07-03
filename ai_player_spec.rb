require 'rspec'
require 'stringio'
require_relative 'ai_player'

describe AIPlayer do
    before do
        @o_stream = StringIO.new
        @i_stream = StringIO.new
        @ai = AIPlayer.new @i_stream, @o_stream
    end

    it "exists" do
    end

    it "has made no guesses and gotten no responses when initialized" do
        @ai.past_guesses.should == {}
    end
    
    it "has a default next guess of WWWW" do
        @ai.next_guess.should == "WWWW"
    end

    it "has a default possible array of all values" do
        expected = Array.new(4){"RGBWYO"} 
        @ai.possible_values.should == expected
    end

    it "stores the guess/response after making a guess" do
        expected = {"WWWW" => [2, 0]}
        @i_stream.puts [2, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.past_guesses.should == expected

        @o_stream.rewind
        @o_stream.gets.chomp.should == "WWWW"
    end
    
    it "has figured out no positions initially" do
        @ai.figured_out_positions.should == []
    end

    it "has figured out position 0 when the first possible_values is 1 element" do
        @ai.possible_values = %w(W GB GB GB)
        @ai.figured_out_positions.should == [0]
    end

    it "has figured out position 1 when the second possible_values is 1 element" do
        @ai.possible_values = %w(WB B GB GB)
        @ai.figured_out_positions.should == [1]
    end

    it "has figured out position 3 when the last possible_values is 1 element" do
        @ai.possible_values = %w(WB GB GB G)
        @ai.figured_out_positions.should == [3]
    end

    it "has figured out positions 0,3 when the first and last possible_values are 1 element" do
        @ai.possible_values = %w(W GB GB G)
        @ai.figured_out_positions.should == [0, 3]
    end

    it "has figured out positions 1,2 when the middle possible_values are 1 element" do
        @ai.possible_values = %w(WB G G GB)
        @ai.figured_out_positions.should == [1, 2]
    end

    it "has figured out positions 0,1,2 when the the first three possible_values are 1 element" do
        @ai.possible_values = %w(W G G GB)
        @ai.figured_out_positions.should == [0, 1, 2]
    end

    it "has not figured out any positions initially" do
        @ai.not_figured_out_positions.should == [0, 1, 2, 3]
    end

    it "has not figured out positions 1,2,3 when the first possible_values is 1 element" do
        @ai.possible_values = %w(W GB GB GB)
        @ai.not_figured_out_positions.should == [1, 2, 3]
    end

    it "has not figured out position 0,1,2 when the last possible_values is 1 element" do
        @ai.possible_values = %w(WB GB GB G)
        @ai.not_figured_out_positions.should == [0, 1, 2]
    end

    it "has not figured out positions 0,3 when the middle possible_values are 1 element" do
        @ai.possible_values = %w(WB G G GB)
        @ai.not_figured_out_positions.should == [0, 3]
    end

    it "has not figured out positions 1,2 when the first and last possible_values are 1 element" do
        @ai.possible_values = %w(W GB GB G)
        @ai.not_figured_out_positions.should == [1, 2]
    end

    it "has figured out zero values initially" do
        @ai.num_figured_out.should == 0
    end

    it "has figured out one value when one possible_value is 1 element" do
        @ai.possible_values = %w(W GB GB GB)
        @ai.num_figured_out.should == 1
    end

    it "has figured out two values when two possible_value are 1 element" do
        @ai.possible_values = %w(W G GB GB)
        @ai.num_figured_out.should == 2
    end

    it "has figured out three values when three possible_value are 1 element" do
        @ai.possible_values = %w(W G B GB)
        @ai.num_figured_out.should == 3
    end

    it "deletes W from all positions when delete_from_positions(W, 0..3)" do
        expected = Array.new(4){"RGBYO"} 
        @ai.delete_from_positions("W", 0..3)
        @ai.possible_values.should == expected
    end

    it "deletes GRW from positions 1 and 2 when delete_from_positions('GRW', 1..2)" do
        expected = %w(RGBWYO BYO BYO RGBWYO) 
        @ai.delete_from_positions("GRW", 1..2)
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if no pins are returned" do
        expected = Array.new(4){"RGBYO"} 
        @i_stream.puts [0, 0].to_s
        @i_stream.rewind

        @ai.guess
        
        @o_stream.rewind
        @o_stream.gets.chomp.should == "WWWW"
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if no red pins are returned" do
        expected = %w(RGBYO RGBYO GBWYO GBWYO)
        @ai.next_guess = "WWRR"
        @i_stream.puts [0, 2].to_s
        @i_stream.rewind

        @ai.guess
        
        @o_stream.rewind
        @o_stream.gets.chomp.should == "WWRR"
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if 1 red pin returned and 1 figured out value, and no white pins" do
        @ai.possible_values = %w(W RGB RGB RGB)
        @ai.next_guess = "WRGG"
        expected = %w(W B B B)
        @i_stream.puts [1, 0].to_s
        @i_stream.rewind

        @ai.guess
        
        @o_stream.rewind
        @o_stream.gets.chomp.should == "WRGG"
        @ai.possible_values.should == expected
        @ai.next_guess.should == "WBBB"
    end

    it "eliminates possible values if 2 red pins returned and 2 figured out value, and no white pins" do
        @ai.possible_values = %w(W RGB R RGB)
        @ai.next_guess = "WRRG"
        expected = %w(W B R B)
        @i_stream.puts [2, 0].to_s
        @i_stream.rewind

        @ai.guess
        @o_stream.rewind
        @o_stream.gets.chomp.should == "WRRG"
        @ai.possible_values.should == expected
        @ai.next_guess.should == "WBRB"
    end

    it "eliminates possible values if 2 red pins, 2 figured out values, and 2 white pins" do
        @ai.possible_values = %w(W RGB R RGB)
        @ai.next_guess = "WRRG"
        expected = %w(W G R R)
        @i_stream.puts [2, 2].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values.should == expected
        @ai.next_guess.should == "WGRR"
    end

    it "eliminates possible values if 2 red pins, 2 figured out values, and 2 white pins" do
        @ai.possible_values = %w(WRG B R RGB)
        @ai.next_guess = "RBRG"
        expected = %w(G B R R)
        @i_stream.puts [2, 2].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values.should == expected
        @ai.next_guess.should == "GBRR"
    end

    it "eliminates possible values if 3 red pins, 3 figured out values, and 0 white pins" do
        @ai.possible_values = %w(W B R GB)
        @ai.next_guess = "WBRG"
        expected = %w(W B R B)
        @i_stream.puts [3, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values.should == expected
        @ai.next_guess.should == "WBRB"
    end

    it "eliminates possible values if 3 red pins, 3 figured out values, and 0 white pins" do
        @ai.possible_values = %w(W B R GB)
        @ai.next_guess = "WBRG"
        expected = %w(W B R B)
        @i_stream.puts [3, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values.should == expected
        @ai.next_guess.should == "WBRB"
    end

    it "stores is_to_is_not_decisions when 2 red pins, 2 white pins, no figured out values" do
        @ai.next_guess = "WBRG"
        @i_stream.puts [2, 2].to_s
        @i_stream.rewind
        expected_decisions = Hash.new
        expected_decisions[ [[0, "W"], [1, "B"]] ] = [[2, "R"], [3, "G"]]
        expected_decisions[ [[0, "W"], [2, "R"]] ] = [[1, "B"], [3, "G"]]
        expected_decisions[ [[0, "W"], [3, "G"]] ] = [[1, "B"], [2, "R"]]
        expected_decisions[ [[1, "B"], [2, "R"]] ] = [[0, "W"], [3, "G"]]
        expected_decisions[ [[1, "B"], [3, "G"]] ] = [[0, "W"], [2, "R"]]
        expected_decisions[ [[2, "R"], [3, "G"]] ] = [[0, "W"], [1, "B"]]

        @ai.guess
        expected_decisions.each do |conditions, actions|
            @ai.is_to_is_not_decisions[conditions].should == actions
        end
    end

    it "stores is_to_is_not_decisions when 1 red pin, 3 white pins, no figured out values" do
        @ai.next_guess = "WBRG"
        @i_stream.puts [1, 3].to_s
        @i_stream.rewind
        expected_decisions = Hash.new
        expected_decisions[ [[0, "W"]] ] = [[1, "B"], [2, "R"], [3, "G"]]
        expected_decisions[ [[1, "B"]] ] = [[0, "W"], [2, "R"], [3, "G"]]
        expected_decisions[ [[2, "R"]] ] = [[0, "W"], [1, "B"], [3, "G"]]
        expected_decisions[ [[3, "G"]] ] = [[0, "W"], [1, "B"], [2, "R"]]

        @ai.guess
        expected_decisions.each do |conditions, actions|
            @ai.is_to_is_not_decisions[conditions].should == actions
        end
    end

    it "can evaluate is_to_is_not_decisions" do
        @ai.next_guess = "WBRG"
        @i_stream.puts [2, 2].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values[0] = "W"
        @ai.possible_values[1] = "B"
        @ai.evaluate_is_to_is_not_decisions

        @ai.possible_values.should == %w(W B GBWYO RBWYO)
    end

    it "can evaluate is_to_is_not_decisions" do
        @ai.next_guess = "BWRG"
        @i_stream.puts [2, 2].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values[0] = "B"
        @ai.possible_values[1] = "W"
        @ai.evaluate_is_to_is_not_decisions

        @ai.possible_values.should == %w(B W GBWYO RBWYO)
    end

    it "evaluates is_to_is_not_decisions after making a guess" do
        @ai.next_guess = "BWRG"
        @i_stream.puts [1, 3].to_s
        @i_stream.rewind
        @ai.guess

        @ai.possible_values[0] = "B"
        @ai.next_guess = "BWRG"
        @i_stream.puts [1, 3].to_s
        @i_stream.rewind
        @ai.guess

        @ai.possible_values.should == %w(B RGBYO GBWYO RBWYO)
    end

    after(:each) do
        # doesn't repeat guesses
#       @ai.past_guesses.keys.include?(@ai.next_guess).should == false
        # only guesses values that are in the list of possible values
#       @ai.next_guess.split("").each_with_index do |guess_char, index|
#           @ai.possible_values[index].include?(guess_char).should == true
#       end
    end
end
