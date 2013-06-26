require 'rspec'
require_relative 'game_logic'

describe GameLogic do
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
end
