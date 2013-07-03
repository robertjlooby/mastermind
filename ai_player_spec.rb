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

    it "initially has no stored decisions" do
        @ai.stored_decisions.should == []
    end

    it "calls all stored decisions when told to" do
        l1 = lambda { @ai.instance_variable_set(:@s1, 1) }
        l2 = lambda { @ai.instance_variable_set(:@s2, 2) }
        @ai.stored_decisions = [l1, l2]

        @ai.call_stored_decisions

        @ai.instance_variable_get(:@s1).should == 1
        @ai.instance_variable_get(:@s2).should == 2
    end

    it "removes stored decisions that return true" do
        l1 = lambda { true }
        l2 = lambda { false }
        l3 = lambda { true }
        l4 = lambda { false }
        @ai.stored_decisions = [l1, l2, l3, l4]

        @ai.call_stored_decisions
        
        @ai.stored_decisions.should == [l2, l4]
    end

    it "repeatedly calls all stored decisions until all return false" do
        l1 = lambda { false }
        l2 = lambda { if @ai.instance_variables.include?(:@v3) then
                         true 
                      else 
                         false 
                      end }
        l3 = lambda { if @ai.instance_variables.include?(:@v2) then
                         @ai.instance_variable_set(:@v3, 3)
                         true
                      else 
                         false 
                      end }
        l4 = lambda { if @ai.instance_variables.include?(:@v1) then
                         @ai.instance_variable_set(:@v2, 2)
                         true
                      else 
                         false 
                      end }
        l5 = lambda { @ai.instance_variable_set(:@v1, 1)
                      true}
        @ai.stored_decisions = [l1, l2, l3, l4, l5]

        @ai.call_stored_decisions

        @ai.stored_decisions.should == [l1]
        @ai.instance_variable_get(:@v1).should == 1
        @ai.instance_variable_get(:@v2).should == 2
        @ai.instance_variable_get(:@v3).should == 3
    end
    
    it "calls all stored decisions after updating possible values" do
        l1 = lambda { @ai.instance_variable_set(:@s1, 1) }
        l2 = lambda { @ai.instance_variable_set(:@s2, 2) }
        @ai.stored_decisions = [l1, l2]

        @ai.update_possible_values("WWWW", [0, 0])

        @ai.instance_variable_get(:@s1).should == 1
        @ai.instance_variable_get(:@s2).should == 2
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

    it "eliminates possible values if no pins are returned with guess of WWWW" do
        expected = Array.new(4){"RGBYO"} 
        @i_stream.puts [0, 0].to_s
        @i_stream.rewind

        @ai.guess
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if no pins are returned with guess of GBYY" do
        @ai.next_guess = "GBYY"
        expected = Array.new(4){"RWO"} 
        @i_stream.puts [0, 0].to_s
        @i_stream.rewind

        @ai.guess
        
        @ai.possible_values.should == expected
    end

    it "has the solution if [4, 0] is returned with a guess of WWWW" do
        expected = %w(W W W W) 
        @i_stream.puts [4, 0].to_s
        @i_stream.rewind

        @ai.guess
        
        @ai.possible_values.should == expected
    end

    it "has the solution if [4, 0] is returned with a guess of GBYY" do
        @ai.next_guess = "GBYY"
        expected = %w(G B Y Y) 
        @i_stream.puts [4, 0].to_s
        @i_stream.rewind

        @ai.guess
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [3, 0] is returned with a guess of WGRB and later possible_values[0] is found not to be W" do
        #if pv[0] :does_not_include "W" then pv[1..3] = ["G", "R", "B"] end x4
        @ai.next_guess = "WGRB"
        expected = %w(RGBYO G R B) 
        @i_stream.puts [3, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.delete_from_positions "W", [0]
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [3, 0] is returned with a guess of WGRB and later possible_values[1] is found not to be G" do
        #if pv[0] :does_not_include "W" then pv[1..3] = ["G", "R", "B"] end x4
        @ai.next_guess = "WGRB"
        expected = %w(W RBWYO R B) 
        @i_stream.puts [3, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.delete_from_positions "G", [1]
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [3, 0] is returned with a guess of WGRB and later possible_values[3] is found not to be R" do
        #if pv[0] :does_not_include "W" then pv[1..3] = ["G", "R", "B"] end x4
        @ai.next_guess = "WGRB"
        expected = %w(W G GBWYO B) 
        @i_stream.puts [3, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.delete_from_positions "R", [2]
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [3, 0] is returned with a guess of WGRB and later possible_values[0, 1, 2] is found to be [W, G, R]" do
        #if pv[0..2] == ["W", "G", "R"] then pv[3].delete "B" end x4
        @ai.next_guess = "WGRB"
        expected = %w(W G R RGWYO) 
        @i_stream.puts [3, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values[0] = "W"
        @ai.possible_values[1] = "G"
        @ai.possible_values[2] = "R"
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [3, 0] is returned with a guess of WGRB and later possible_values[0, 2, 3] is found to be [W, R, B]" do
        #if pv[0..2] == ["W", "G", "R"] then pv[3].delete "B" end x4
        @ai.next_guess = "WGRB"
        expected = %w(W RBWYO R B) 
        @i_stream.puts [3, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values[0] = "W"
        @ai.possible_values[2] = "R"
        @ai.possible_values[3] = "B"
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [2, 0] is returned with a guess of WGRB and later possible_values[0, 1] are found not to be W, G" do
        #if pv[0] :does_not_include "W" && pv[1] :does_not_include "G" then pv[2..3] = ["R", "B"] end x6
        @ai.next_guess = "WGRB"
        expected = %w(RBYO RBYO R B) 
        @i_stream.puts [2, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.delete_from_positions "W", [0]
        @ai.delete_from_positions "G", [1]
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [2, 0] is returned with a guess of WGRB and later possible_values[0, 2] are found not to be W, R" do
        #if pv[0] :does_not_include "W" && pv[1] :does_not_include "G" then pv[2..3] = ["R", "B"] end x6
        @ai.next_guess = "WGRB"
        expected = %w(GBYO G GBYO B) 
        @i_stream.puts [2, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.delete_from_positions "W", [0]
        @ai.delete_from_positions "R", [2]
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [2, 0] is returned with a guess of WGRB and later possible_values[2, 3] are found not to be R, B" do
        #if pv[0] :does_not_include "W" && pv[1] :does_not_include "G" then pv[2..3] = ["R", "B"] end x6
        @ai.next_guess = "WGRB"
        expected = %w(W G GWYO GWYO) 
        @i_stream.puts [2, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.delete_from_positions "R", [2]
        @ai.delete_from_positions "B", [3]
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [2, 0] is returned with a guess of WGRB and later possible_values[0, 1] is found to be [W, G]" do
        #if pv[0..1] == ["W", "G"] then pv[3..4].delete "RB" end x6
        @ai.next_guess = "WGRB"
        expected = %w(W G GWYO GWYO) 
        @i_stream.puts [2, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values[0] = "W"
        @ai.possible_values[1] = "G"
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [1, 0] is returned with a guess of WGRB and later possible_values[0, 1, 2] are found not to be W, G, R" do
        #if pv[0] :does_not_include "W" && pv[1] :does_not_include "G" && pv[2] :does_not_include "R" then pv[3] = "B" end x4
        @ai.next_guess = "WGRB"
        expected = %w(BYO BYO BYO B) 
        @i_stream.puts [1, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.delete_from_positions "W", [0]
        @ai.delete_from_positions "G", [1]
        @ai.delete_from_positions "R", [2]
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [1, 0] is returned with a guess of WGRB and later possible_values[0, 2, 3] are found not to be W,  R, B" do
        #if pv[0] :does_not_include "W" && pv[1] :does_not_include "G" && pv[2] :does_not_include "R" then pv[3] = "B" end x4
        @ai.next_guess = "WGRB"
        expected = %w(GYO G GYO GYO) 
        @i_stream.puts [1, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.delete_from_positions "W", [0]
        @ai.delete_from_positions "R", [2]
        @ai.delete_from_positions "B", [3]
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [1, 0] is returned with a guess of WGRB and later possible_values[1, 2, 3] are found not to be G,  R, B" do
        #if pv[0] :does_not_include "W" && pv[1] :does_not_include "G" && pv[2] :does_not_include "R" then pv[3] = "B" end x4
        @ai.next_guess = "WGRB"
        expected = %w(W WYO WYO WYO) 
        @i_stream.puts [1, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.delete_from_positions "G", [1]
        @ai.delete_from_positions "R", [2]
        @ai.delete_from_positions "B", [3]
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [1, 0] is returned with a guess of WGRB and later possible_values[1] is found to be G" do
        #if pv[0] == "W" then pv[1..3].delete "GRB" end x4
        @ai.next_guess = "WGRB"
        expected = %w(GYO G GYO GYO) 
        @i_stream.puts [1, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values[1] = "G"
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [1, 0] is returned with a guess of WGRB and later possible_values[2] is found to be W" do
        #if pv[0] == "W" then pv[1..3].delete "GRB" end x4
        @ai.next_guess = "WGRB"
        expected = %w(W WYO WYO WYO) 
        @i_stream.puts [1, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values[0] = "W"
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if [1, 0] is returned with a guess of WGRB and later possible_values[3] is found to be B" do
        #if pv[0] == "W" then pv[1..3].delete "GRB" end x4
        @ai.next_guess = "WGRB"
        expected = %w(BYO BYO BYO B) 
        @i_stream.puts [1, 0].to_s
        @i_stream.rewind

        @ai.guess
        @ai.possible_values[3] = "B"
        @ai.call_stored_decisions
        
        @ai.possible_values.should == expected
    end
end
