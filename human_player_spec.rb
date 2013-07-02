require 'rspec'
require 'stringio'
require_relative 'human_player'

describe HumanPlayer do
    before do
        @i_stream = StringIO.new
        @o_stream = StringIO.new
        @display_i_stream = StringIO.new
        @display_o_stream = StringIO.new
        @player = HumanPlayer.new(@i_stream, @o_stream, @display_i_stream, @display_o_stream)
        @display_i_stream.puts "WBRG"
        @display_i_stream.rewind
        @i_stream.puts [0, 0].to_s
        @i_stream.rewind
    end

    it "exists" do
    end

    it "prompts for a response" do
        @player.guess

        @display_o_stream.rewind
        @display_o_stream.gets.chomp.should =~ /enter your guess/
    end

    it "reads a guess from @display_i_stream and writes it to @o_stream" do
        @player.guess

        @o_stream.rewind
        @o_stream.gets.chomp.should == "WBRG"
    end

    it "reads the response from @i_stream and writes it to @display_o_stream" do
        @player.guess

        @display_o_stream.rewind
        @display_o_stream.gets.chomp.should =~ /enter your guess/
        @display_o_stream.gets.chomp.should == [0, 0].to_s
    end

    it "warns and reprompts if the guess is too short" do
        display_i_stream = StringIO.new
        player = HumanPlayer.new(@i_stream, @o_stream, display_i_stream, @display_o_stream)
        display_i_stream.puts "WBR\nWWWW"
        display_i_stream.rewind
        
        player.guess

        @display_o_stream.rewind
        @display_o_stream.gets.chomp.should =~ /enter your guess/
        @display_o_stream.gets.chomp.should =~ /not in the correct/
        @display_o_stream.gets.chomp.should =~ /enter your guess/
    end

    it "warns and reprompts if the guess is too long" do
        display_i_stream = StringIO.new
        player = HumanPlayer.new(@i_stream, @o_stream, display_i_stream, @display_o_stream)
        display_i_stream.puts "WBRWW\nWWWW"
        display_i_stream.rewind
        
        player.guess

        @display_o_stream.rewind
        @display_o_stream.gets.chomp.should =~ /enter your guess/
        @display_o_stream.gets.chomp.should =~ /not in the correct/
        @display_o_stream.gets.chomp.should =~ /enter your guess/
    end

    it "warns and reprompts if the guess contains bad chars" do
        display_i_stream = StringIO.new
        player = HumanPlayer.new(@i_stream, @o_stream, display_i_stream, @display_o_stream)
        display_i_stream.puts "WBRx\nWWWW"
        display_i_stream.rewind
        
        player.guess

        @display_o_stream.rewind
        @display_o_stream.gets.chomp.should =~ /enter your guess/
        @display_o_stream.gets.chomp.should =~ /not in the correct/
        @display_o_stream.gets.chomp.should =~ /enter your guess/
    end

    it "warns and reprompts if the guess contains bad chars" do
        display_i_stream = StringIO.new
        player = HumanPlayer.new(@i_stream, @o_stream, display_i_stream, @display_o_stream)
        display_i_stream.puts "WBRW..x\nWWWW"
        display_i_stream.rewind
        
        player.guess

        @display_o_stream.rewind
        @display_o_stream.gets.chomp.should =~ /enter your guess/
        @display_o_stream.gets.chomp.should =~ /not in the correct/
        @display_o_stream.gets.chomp.should =~ /enter your guess/
    end
end
