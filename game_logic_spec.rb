require 'rspec'
require_relative 'game_logic'

describe GameLogic do
    before do
        @reader = MockReader.new
        @writer = MockWriter.new
    end

    it "module exists" do
    end

    it "returns no pegs when no colors are correct" do
        GameLogic.guess("RRRR", "WWWW").should == [0, 0]
    end

    it "returns a red peg when one peg is correct in position and color" do
        GameLogic.guess("WRRR", "WWWW").should == [1, 0]
    end

    it "returns two red pegs when two pegs are correct in position and color" do
        GameLogic.guess("WWRR", "WWWW").should == [2, 0]
    end

    it "returns three red pegs when three pegs are correct in position and color" do
        GameLogic.guess("WWWR", "WWWW").should == [3, 0]
    end

    it "returns one white peg when one peg is correct in color but not position" do
        GameLogic.guess("WBBB", "RRRW").should == [0, 1]
    end

    it "returns two white pegs when two pegs are correct in color but not position" do 
        GameLogic.guess("WWBB", "RRWW").should == [0, 2]
    end

    it "returns one white peg when two pegs of a color are present in the guess but only one is in the solution" do
        GameLogic.guess("WWBB", "RRRW").should == [0, 1]
    end
    it "returns two red pegs when guess is four of same color but only two pegs are correct in color and position" do
        GameLogic.guess("WWWW", "WWBB").should == [2, 0]
    end

    it "returns four red pegs when guess is same as actual" do
        GameLogic.guess("WBRB", "WBRB").should == [4, 0]
    end

    it "returns four white pegs when guess is correct in colors but not positions" do
        GameLogic.guess("WBRB", "BWBR").should == [0, 4]
    end

    it "returns two white and two red pegs when two pegs are correct in color and position and two pegs are correct in color" do
        GameLogic.guess("WBRB", "WBBR").should == [2, 2]
    end

    it "returns one white and two red pegs when two pegs are correct in color and position and one peg are correct in color" do
        GameLogic.guess("WBYB", "WBBR").should == [2, 1]
    end

    it "returns two white and one red pegs when one peg is correct in color and position and two pegs are correct in color" do
        GameLogic.guess("WYRB", "WBBR").should == [1, 2]
    end

    it "for a single turn: reads once, asks for guess once, writes response once. response is correct" do
        @reader.responses = ["WBBG"]
        GameLogic.turn("WYRB", @reader, @writer)

        @writer.times_asked_for_guess.should == 1
        @writer.times_wrote_response.should == 1
        @reader.times_read.should == 1
        @writer.responses[0].should == [1, 1]
    end

    it "for three turns: asks for guess, reads, writes response three times each. responses are correct" do
        @reader.responses = ["WBBG", "WYBR", "YWRR"]
        GameLogic.turn("WYRB", @reader, @writer)
        GameLogic.turn("WYRB", @reader, @writer)
        GameLogic.turn("WYRB", @reader, @writer)

        @writer.times_asked_for_guess.should == 3
        @writer.times_wrote_response.should == 3
        @reader.times_read.should == 3
        @writer.responses[0].should == [1, 1]
        @writer.responses[1].should == [2, 2]
        @writer.responses[2].should == [1, 2]
    end

    it "for a ten turn game: asks for guess, reads, writes response ten times each. responses are correct" do
        @reader.responses = ["WBBG", "WYBR", "YWRR", 
                             "WBBG", "WYBR", "YWRR", 
                             "WBBG", "WYBR", "YWRR", 
                             "WYRB"]
        GameLogic.game("WYRB", 10, @reader, @writer)

        @writer.times_asked_for_guess.should == 10
        @writer.times_wrote_response.should == 10
        @reader.times_read.should == 10
        @writer.responses[0].should == [1, 1]
        @writer.responses[1].should == [2, 2]
        @writer.responses[2].should == [1, 2]
        @writer.responses[3].should == [1, 1]
        @writer.responses[4].should == [2, 2]
        @writer.responses[5].should == [1, 2]
        @writer.responses[6].should == [1, 1]
        @writer.responses[7].should == [2, 2]
        @writer.responses[8].should == [1, 2]
        @writer.responses[9].should == [4, 0]
    end

    it "returns :win when the game is won on the first turn" do
        @reader.responses = ["WYRB"]
        result = GameLogic.game("WYRB", 10, @reader, @writer)

        @writer.times_asked_for_guess.should == 1
        @writer.times_wrote_response.should == 1
        @reader.times_read.should == 1
        @writer.responses[0].should == [4, 0]
        result.should == :win
    end

    it "returns :win when the game is won on the last turn" do
        @reader.responses = ["WBBG", "WYBR", "YWRR", 
                             "WBBG", "WYBR", "YWRR", 
                             "WBBG", "WYBR", "YWRR", 
                             "WYRB"]
        result = GameLogic.game("WYRB", 10, @reader, @writer)

        result.should == :win
    end

    it "returns :lose when the game is not won" do
        @reader.responses = ["WBBG", "WYBR", "YWRR", 
                             "WBBG", "WYBR", "YWRR", 
                             "WBBG", "WYBR", "YWRR", 
                             "WBRB"]
        result = GameLogic.game("WYRB", 10, @reader, @writer)

        result.should == :lose
    end

end

class MockReader
    attr_accessor :times_read, :responses
    def initialize
        @times_read = 0
    end

    def read_guess
        @times_read += 1
        @responses.shift
    end
end

class MockWriter
    attr_accessor :times_asked_for_guess, :times_wrote_response, :responses
    def initialize
        @times_asked_for_guess = @times_wrote_response = 0
        @responses = []
    end

    def ask_for_guess
        @times_asked_for_guess += 1
    end

    def write_response(response)
        @responses.push response
        @times_wrote_response += 1
    end
end
