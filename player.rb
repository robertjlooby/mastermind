class Player
    attr_accessor :next_guess, :response

    def initialize(i_stream, o_stream, input_i_stream = nil)
        @i_stream = i_stream
        @o_stream = o_stream
        @input_i_stream = input_i_stream
    end
    def guess
        @next_guess = @input_i_stream.gets unless @input_i_stream.nil?
        @o_stream.puts @next_guess
        @response = @i_stream.gets.chomp
    end
end
