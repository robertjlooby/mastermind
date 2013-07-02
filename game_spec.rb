require 'rspec'
require_relative 'game'

describe Game do
    before do
        p2l_read, p2l_write = IO.pipe
        l2p_read, l2p_write = IO.pipe
        @game = Game.new 10, "WGRB", 
                         MockPlayer, MockLogic, 
                         p2l_read, p2l_write,
                         l2p_read, l2p_write
        @game.player.o_stream.puts "WGRB"
    end

    it "exists" do
    end

    it "creates a player" do
        @game.player.is_a?(MockPlayer).should == true
    end

    it "creates a logic controller" do
        @game.logic.is_a?(MockLogic).should == true
    end

    it "can write to a pipe from player to logic" do
        @game.logic.i_stream.gets.chomp.should == "WGRB"
    end
 
    it "can write to a pipe from logic to player" do
        @game.logic.o_stream.puts "test string"

        @game.player.i_stream.gets.chomp.should == "test string"
    end

    it "has a code of 'WGRB'" do
        @game.code.should == 'WGRB'
    end

    it "has a logic controller with a code of 'WGRB'" do
        @game.logic.code.should == 'WGRB'
    end

    it "has 10 turns" do
        @game.num_turns.should == 10
    end

    it "initially has not prompted for a guess" do
        @game.player.number_of_times_prompted_for_a_guess.should == 0
    end

    it "initially has not prompted for a response" do
        @game.logic.number_of_times_prompted_for_a_response.should == 0
    end

    it "will prompt for a guess each turn" do
        @game.take_turn
        @game.player.number_of_times_prompted_for_a_guess.should == 1
    end

    it "will prompt for a guess each turn" do
        @game.take_turn
        @game.take_turn
        @game.player.number_of_times_prompted_for_a_guess.should == 2
    end

    it "will prompt the logic for a response each turn" do
        @game.take_turn
        @game.logic.number_of_times_prompted_for_a_response.should == 1
    end

    it "will prompt the logic for a response each turn" do
        @game.take_turn
        @game.take_turn
        @game.logic.number_of_times_prompted_for_a_response.should == 2
    end

    it "will take 10 turns for a game" do
        @game.logic.i_stream.gets
        @game.player.o_stream.puts "WWWW"
        @game.play_game
        @game.player.number_of_times_prompted_for_a_guess.should == 10
        @game.logic.number_of_times_prompted_for_a_response.should == 10
    end

    it "will return [4, 0] when a turn's guess is correct" do
        @game.take_turn.should == [4, 0]
    end

    it "will return [0, 0] when a turn's guess is incorrect" do
        @game.logic.i_stream.gets
        @game.player.o_stream.puts "WWWW"

        @game.take_turn.should == [0, 0]
    end

    it "will return :win if the outcome of a turn in the game is [4, 0]" do
        @game.play_game.should == :win
    end

    it "will return :lose if the outcome of a turn in the game is not [4, 0]" do
        @game.logic.i_stream.gets
        @game.player.o_stream.puts "WWWW"

        @game.play_game.should == :lose
    end
end

class MockPlayer
    attr_accessor :o_stream, :i_stream, :number_of_times_prompted_for_a_guess
    def initialize(i_stream, o_stream)
        @i_stream = i_stream
        @o_stream = o_stream
        @number_of_times_prompted_for_a_guess = 0
    end

    def guess
        @number_of_times_prompted_for_a_guess += 1
    end
end

class MockLogic
    attr_accessor :code, :o_stream, :i_stream, :number_of_times_prompted_for_a_response
    def initialize(code, i_stream, o_stream)
        @code = code
        @i_stream = i_stream
        @o_stream = o_stream
        @number_of_times_prompted_for_a_response = 0
    end

    def respond
        @number_of_times_prompted_for_a_response += 1
        output = [0, 0]
        unless @i_stream.closed?
            if @i_stream.gets.chomp == @code
                output = [4, 0] 
            end
            @i_stream.close
        end
        output
    end
end
