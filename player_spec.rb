require 'rspec'
require 'stringio'
require_relative 'player'

describe Player do
    before do
        @i_stream = StringIO.new
        @o_stream = StringIO.new
        @player = Player.new(@i_stream, @o_stream)
    end

    it "exists" do
    end

    it "returns a guess" do
        @player.next_guess = "WBRG"
        @i_stream.puts [0, 0].to_s
        @i_stream.rewind

        @player.guess
        @o_stream.rewind
        @o_stream.gets.chomp.should == "WBRG"
    end

    it "returns a guess" do
        @player.next_guess = "GRWB"
        @i_stream.puts [0, 0].to_s
        @i_stream.rewind

        @player.guess
        @o_stream.rewind
        @o_stream.gets.chomp.should == "GRWB"
    end

    it "reads the response" do
        @player.next_guess = "WBRG"
        @i_stream.puts [0, 0].to_s
        @i_stream.rewind

        @player.guess
        @player.response.should == [0, 0].to_s
    end

    it "reads the response" do
        @player.next_guess = "WBRG"
        @i_stream.puts [3, 0].to_s
        @i_stream.rewind

        @player.guess
        @player.response.should == [3, 0].to_s
    end
end
