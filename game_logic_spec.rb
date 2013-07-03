require 'rspec'
require 'stringio'
require_relative 'game_logic'

describe GameLogic do
    before do
        @p2l_reader = StringIO.new
        @l2p_writer = StringIO.new
        @code = "WBRG"
        @logic = GameLogic.new @code, @p2l_reader, @l2p_writer
    end

    it "module exists" do
    end

    it "has an initial code of WBRG" do
        @logic.code.should == "WBRG"
    end

    it "returns no pegs when no colors are correct" do
        @logic.code = "WWWW"
        @p2l_reader.puts("RRRR")
        @p2l_reader.rewind

        @logic.respond.should == [0, 0]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [0, 0].to_s
    end

    it "returns a red peg when one peg is correct in position and color" do
        @logic.code = "WWWW"
        @p2l_reader.puts("WRRR")
        @p2l_reader.rewind

        @logic.respond.should == [1, 0]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [1, 0].to_s
    end

    it "returns two red pegs when two pegs are correct in position and color" do
        @logic.code = "WWWW"
        @p2l_reader.puts("WWRR")
        @p2l_reader.rewind

        @logic.respond.should == [2, 0]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [2, 0].to_s
    end

    it "returns three red pegs when three pegs are correct in position and color" do
        @logic.code = "WWWW"
        @p2l_reader.puts("WWWR")
        @p2l_reader.rewind

        @logic.respond.should == [3, 0]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [3, 0].to_s
    end

    it "returns one white peg when one peg is correct in color but not position" do
        @logic.code = "RRRW"
        @p2l_reader.puts("WBBB")
        @p2l_reader.rewind

        @logic.respond.should == [0, 1]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [0, 1].to_s
    end

    it "returns two white pegs when two pegs are correct in color but not position" do 
        @logic.code = "RRWW"
        @p2l_reader.puts("WWBB")
        @p2l_reader.rewind

        @logic.respond.should == [0, 2]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [0, 2].to_s
    end

    it "returns one white peg when two pegs of a color are present in the guess but only one is in the solution" do
        @logic.code = "RRRW"
        @p2l_reader.puts("WWBB")
        @p2l_reader.rewind

        @logic.respond.should == [0,1]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [0, 1].to_s
    end
    it "returns two red pegs when guess is four of same color but only two pegs are correct in color and position" do
        @logic.code = "WWBB"
        @p2l_reader.puts("WWWW")
        @p2l_reader.rewind

        @logic.respond.should == [2, 0]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [2, 0].to_s
    end

    it "returns four red pegs when guess is same as actual" do
        @logic.code = "WBRB"
        @p2l_reader.puts("WBRB")
        @p2l_reader.rewind

        @logic.respond.should == [4, 0]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [4, 0].to_s
    end

    it "returns four white pegs when guess is correct in colors but not positions" do
        @logic.code = "BWBR"
        @p2l_reader.puts("WBRB")
        @p2l_reader.rewind

        @logic.respond.should == [0, 4]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [0, 4].to_s
    end

    it "returns two white and two red pegs when two pegs are correct in color and position and two pegs are correct in color" do
        @logic.code = "WBBR"
        @p2l_reader.puts("WBRB")
        @p2l_reader.rewind

        @logic.respond.should == [2, 2]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [2, 2].to_s
    end

    it "returns one white and two red pegs when two pegs are correct in color and position and one peg are correct in color" do
        @logic.code = "WBBR"
        @p2l_reader.puts("WBYB")
        @p2l_reader.rewind

        @logic.respond.should == [2, 1]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [2, 1].to_s
    end

    it "returns two white and one red pegs when one peg is correct in color and position and two pegs are correct in color" do
        @logic.code = "WBBR"
        @p2l_reader.puts("WYRB")
        @p2l_reader.rewind

        @logic.respond.should == [1, 2]
		@l2p_writer.rewind
		@l2p_writer.gets.chomp.should == [1, 2].to_s
    end
end
