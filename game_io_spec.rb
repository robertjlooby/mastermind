require 'rspec'
require 'stringio'
require_relative 'game_io'

describe GameIO do
    before do
        @o_stream = StringIO.new
        @writer = GameIO::Writer.new(@o_stream)
    end

    it "exists" do
    end

    it "has writer" do
        @writer.class.should == GameIO::Writer
    end

    it "writer asks for guess" do
        @writer.ask_for_guess
        @o_stream.rewind
        @o_stream.gets.should =~ /your guess/
    end

    it "writer writes response" do 
        @writer.write_response([3, 0])
        @o_stream.rewind
        @o_stream.gets.should =~ /3 red pins, 0 white pins/
    end

    it "has reader" do
        @i_stream = StringIO.new
        @reader = GameIO::Reader.new(@i_stream)

        @reader.class.should == GameIO::Reader
    end

    it "reader reads guess" do
        @i_stream = StringIO.new("WWGB")
        @reader = GameIO::Reader.new(@i_stream)
        guess = @reader.read_guess
        guess.should == "WWGB"
    end

    it "reader strips whitespace from response" do
        @i_stream = StringIO.new("   \tWWGB   \t\n")
        @reader = GameIO::Reader.new(@i_stream)
        guess = @reader.read_guess
        guess.should == "WWGB"
    end

    it "reader upcases result" do
        @i_stream = StringIO.new("wwgb")
        @reader = GameIO::Reader.new(@i_stream)
        guess = @reader.read_guess
        guess.should == "WWGB"
    end

    it "reader prompts again for long responses" do
        @i_stream = StringIO.new("wwgbww\nwwww")
        @reader = GameIO::Reader.new(@i_stream)
        guess = @reader.read_guess
        guess.should == "WWWW"
    end

    it "reader prompts again for invalid responses" do
        @i_stream = StringIO.new("hello.98\nwwww")
        @reader = GameIO::Reader.new(@i_stream)
        guess = @reader.read_guess
        guess.should == "WWWW"
    end
end
