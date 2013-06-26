require 'rspec'
require 'stringio'
require_relative 'ai_player'
require_relative 'game_logic'

describe AIPlayer do
    before do
        @o_stream = StringIO.new
        @i_stream = StringIO.new
        @ai = AIPlayer.new(@o_stream, @i_stream)
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
        @i_stream.puts "[2, 0]"
        @i_stream.rewind

        @ai.guess
        @ai.past_guesses.should == expected

        @o_stream.rewind
        @o_stream.gets.chomp.should == "WWWW"
    end

    it "eliminates possible values if no pins are returned" do
        expected = Array.new(4){"RGBYO"} 
        @i_stream.puts "[0, 0]"
        @i_stream.rewind

        @ai.guess
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if no red pins are returned" do
        expected = ["RGBYO", "RGBYO", "GBWYO", "GBWYO"] 
        @ai.next_guess = "WWRR"
        @i_stream.puts "[0, 2]"
        @i_stream.rewind

        @ai.guess
        @ai.possible_values.should == expected
    end
end
