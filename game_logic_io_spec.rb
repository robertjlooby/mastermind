require 'rspec'
require 'stringio'
require_relative 'game_logic_io'

describe GameLogicIO do
    before do
        @code = "WWWW"
        @i_stream = StringIO.new
        @o_stream = StringIO.new
        @gl_io = GameLogicIO.new MockGameLogic, @code, @i_stream, @o_stream
    end

    it "exists" do
    end

    it "has an instance of game logic" do
        @gl_io.game_logic.should be_an_instance_of(MockGameLogic)
    end

    it "has the given i/o streams" do
        @gl_io.i_stream.should == @i_stream
        @gl_io.o_stream.should == @o_stream
    end

    it "has the given code" do
        @gl_io.code.should == @code
    end

    it "calls @game_logic#respond when it is asked to respond" do
        3.times { @i_stream.puts "WWWW" }
        @i_stream.rewind

        @gl_io.respond
        @gl_io.respond
        @gl_io.respond

        @gl_io.game_logic.times_called_respond.should == 3
    end

    it "calls @game_logic#respond when it is asked to respond" do
        5.times { @i_stream.puts "WWWW" }
        @i_stream.rewind

        @gl_io.respond
        @gl_io.respond
        @gl_io.respond
        @gl_io.respond
        @gl_io.respond

        @gl_io.game_logic.times_called_respond.should == 5
    end

    it "reads the i_stream to get the guess, and passes this and the code to the game_logic#respond" do
        @i_stream.puts "WWWW"
        @i_stream.rewind

        @gl_io.respond.should == [4, 0]
    end

    it "reads the i_stream to get the guess, and passes this and the code to the game_logic#respond" do
        @i_stream.puts "GGGG"
        @i_stream.rewind

        @gl_io.respond.should == [0, 0]
    end

    it "writes the response to the o_stream" do
        @i_stream.puts "GGGG"
        @i_stream.rewind

        @gl_io.respond
        @o_stream.rewind
        @o_stream.gets.chomp.should == [0, 0].to_s
    end

    it "writes the response to the o_stream" do
        @i_stream.puts "WWWW"
        @i_stream.rewind

        @gl_io.respond
        @o_stream.rewind
        @o_stream.gets.chomp.should == [4, 0].to_s
    end
end

class MockGameLogic
    attr_reader :times_called_respond
    def initialize
        @times_called_respond = 0
    end

    def respond(guess, code)
        @times_called_respond += 1
        return [4, 0] if guess == code
        return [0, 0]
    end
end
