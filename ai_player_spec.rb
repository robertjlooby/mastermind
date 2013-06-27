require 'rspec'
require 'stringio'
require_relative 'ai_player'

describe AIPlayer do
    before do
        @ai = AIPlayer.new
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

        @ai.write_guess.should == "WWWW"
        @ai.read_response [2, 0]
        @ai.past_guesses.should == expected
    end

    it "eliminates possible values if no pins are returned" do
        expected = Array.new(4){"RGBYO"} 

        @ai.write_guess.should == "WWWW"
        @ai.read_response [0, 0]
        @ai.possible_values.should == expected
    end

    it "eliminates possible values if no red pins are returned" do
        expected = ["RGBYO", "RGBYO", "GBWYO", "GBWYO"] 
        @ai.next_guess = "WWRR"

        @ai.write_guess.should == "WWRR"
        @ai.read_response [0, 2]
        @ai.possible_values.should == expected
    end

    after(:each) do
        # doesn't repeat guesses
        @ai.past_guesses.keys.include?(@ai.next_guess).should == false
        # only guesses values that are in the list of possible values
        @ai.next_guess.split("").each_with_index do |guess_char, index|
            @ai.possible_values[index].include?(guess_char).should == true
        end
    end
end
