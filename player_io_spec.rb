require 'rspec'
require 'stringio'
require_relative 'player_io'

describe PlayerIO do
    before do
        @i_stream = StringIO.new
        @o_stream = StringIO.new
        @player_io = PlayerIO.new MockPlayer, @i_stream, @o_stream, MockGameLogic
    end

    it "exists" do
    end

    it "has an instance of player" do
        @player_io.player.should be_an_instance_of(MockPlayer)
    end

    it "has an instance of player that has a game logic" do
        @player_io.player.game_logic.should be_an_instance_of(MockGameLogic)
    end

    it "has the passed in i/o streams" do
        @player_io.i_stream.should == @i_stream
        @player_io.o_stream.should == @o_stream
    end

    it "asks the player for a guess when it is asked for a guess" do
        @i_stream.puts [2, 2].to_s
        @i_stream.rewind
        @player_io.guess

        @player_io.player.times_called_get_guess.should == 1
        @player_io.player.times_called_return_response.should == 1
    end

    it "asks the player for a guess when it is asked for a guess" do
        3.times { @i_stream.puts [2, 2].to_s }
        @i_stream.rewind
        @player_io.guess
        @player_io.guess
        @player_io.guess

        @player_io.player.times_called_get_guess.should == 3
        @player_io.player.times_called_return_response.should == 3
    end

    it "writes the player's guess to the o_stream, and reads the response" do
        @i_stream.puts [0, 2].to_s
        @i_stream.rewind
        @player_io.guess

        @o_stream.rewind
        @o_stream.gets.chomp.should == "WWWW"
        @player_io.player.last_response.should == "[0, 2]"
    end

    it "writes the player's guess to the o_stream, and reads the response" do
        @player_io.player.guess = "GRWB"
        @i_stream.puts [2, 2].to_s
        @i_stream.rewind
        @player_io.guess

        @o_stream.rewind
        @o_stream.gets.chomp.should == "GRWB"
        @player_io.player.last_response.should == "[2, 2]"
    end
end

class MockPlayer
    attr_reader :times_called_get_guess, :times_called_return_response, :last_response, :game_logic
    attr_accessor :guess
    def initialize(game_logic_class)
        @game_logic = game_logic_class.new
        @times_called_return_response = 0
        @times_called_get_guess = 0
        @guess = "WWWW"
    end

    def get_guess
        @times_called_get_guess += 1
        @guess
    end
    def return_response(response)
        @times_called_return_response += 1
        @last_response = response
    end
end

class MockGameLogic
end
