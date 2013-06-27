require 'rspec'
require_relative 'ai_game_io'

describe AIGameIO do
    before do
        @player = AIPlayerMock.new
        @writer = AIGameIO::Writer.new(@player)
        @reader = AIGameIO::Reader.new(@player)
    end

    it 'exists' do
    end

    it 'has a Writer module' do
        @writer.class.should == AIGameIO::Writer
    end

    it "writer responds to ask_for_guess" do
        @writer.respond_to?(:ask_for_guess).should == true
    end

    it "writer writes a response to the player" do
        @writer.write_response [0, 0].to_s
        @player.times_read_response.should == 1
    end

    it "has a Reader module" do
        @reader.class.should == AIGameIO::Reader
    end

    it "reader reads a guess from the player" do
        guess = @reader.read_guess
        @player.times_wrote_guess.should == 1
    end
end

class AIPlayerMock
    attr_reader :times_wrote_guess, :times_read_response
    def initialize
        @times_wrote_guess = 0
        @times_read_response = 0
    end

    def write_guess
        @times_wrote_guess += 1
    end

    def read_response(response)
        @times_read_response += 1
    end
end
