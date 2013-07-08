class GameLogicIO
    attr_reader :game_logic, :code, :i_stream, :o_stream
    def initialize(game_logic_class, code, i_stream, o_stream)
        @game_logic = game_logic_class.new
        @code = code
        @i_stream = i_stream
        @o_stream = o_stream
    end

    def respond
        guess = @i_stream.gets.chomp
        response = @game_logic.respond(guess, @code)
        @o_stream.puts response.to_s
        response
    end
end
