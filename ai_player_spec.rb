require 'rspec'
require_relative 'ai_player'

describe AIPlayer do
    before do
        @ai = AIPlayer.new MockGameLogic
    end

    it "exists" do
    end
    
    it "has a default next guess of WYOO" do
        @ai.next_guess.should == "WYOO"
    end

    it "has a default possible array of all values" do
        expected = []
        %w(R G B W Y O).repeated_permutation(4) do |perm|
            expected << perm.join
        end
        @ai.possible_values.should == expected
    end

    it "will eliminate all possible values with W when WWWW is guessed and [0, 0] is returned" do
        @ai.next_guess = "WWWW"
        expected = []
        %w(R G B Y O).repeated_permutation(4) do |perm|
            expected << perm.join
        end
        @ai.return_response [0, 0].to_s

        @ai.possible_values.should == expected
    end

    it "will eliminate all possible values with G when GGGG is guessed and [0, 0] is returned" do
        @ai.next_guess = "GGGG"
        expected = []
        %w(R B W Y O).repeated_permutation(4) do |perm|
            expected << perm.join
        end
        @ai.return_response [0, 0].to_s

        @ai.possible_values.should == expected
    end

    it "will eliminate all possible values with G or W when WWGG is guessed and [0, 0] is returned" do
        @ai.next_guess = "WWGG"
        expected = []
        %w(R B Y O).repeated_permutation(4) do |perm|
            expected << perm.join
        end
        @ai.return_response [0, 0].to_s

        @ai.possible_values.should == expected
    end

    it "will eliminate all possible values with R, G, B, or W when WRGB is guessed and [0, 0] is returned" do
        @ai.next_guess = "WRGB"
        expected = []
        %w(Y O).repeated_permutation(4) do |perm|
            expected << perm.join
        end
        @ai.return_response [0, 0].to_s

        @ai.possible_values.should == expected
    end

    it "will eliminate all except permutations of RWGB (minus RWGB itself) when RWGB is guessed and [0, 4] is returned" do
        @ai.next_guess = "RWGB"
        expected = []
        %w(R G B W).permutation(4) do |perm|
            expected << perm.join
        end
        expected.delete "RWGB"
        @ai.return_response [0, 4].to_s

        @ai.possible_values.should == expected
    end

    it "will pick a next guess from the remaining values if WWWW is guessed and [0, 0] is returned" do
        @ai.next_guess = "WWWW"
        expected = []
        %w(R G B Y O).repeated_permutation(4) do |perm|
            expected << perm.join
        end
        @ai.return_response [0, 0].to_s

        expected.should include(@ai.next_guess)
    end

    it "will pick a next guess from the remaining values if GGGG is guessed and [0, 0] is returned" do
        @ai.next_guess = "GGGG"
        expected = []
        %w(R B W Y O).repeated_permutation(4) do |perm|
            expected << perm.join
        end
        @ai.return_response [0, 0].to_s

        expected.should include(@ai.next_guess)
    end
end

class MockGameLogic
    def respond(guess, code)
        case guess
        when "WWWW"
            return [0, 0] unless code.include? "W"
        when "GGGG"
            return [0, 0] unless code.include? "G"
        when "WWGG"
            return [0, 0] unless code.include?("W") ||
                                 code.include?("G")
        when "WRGB"
            return [0, 0] unless code.include?("W") ||
                                 code.include?("R") ||
                                 code.include?("G") ||
                                 code.include?("B")
        when "RWGB"
            return [0, 4] if code != "RWGB" &&
                                 %w(B G R W) == code.split("").sort
        end
        return [4, 0]
    end
end
