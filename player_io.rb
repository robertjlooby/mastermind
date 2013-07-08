class PlayerIO
    attr_reader :player, :i_stream, :o_stream
    def initialize(player_class, i_stream, o_stream, game_logic_class)
        @player = player_class.new game_logic_class
        @i_stream = i_stream
        @o_stream = o_stream
    end

    def guess
        player_guess = @player.get_guess
        @o_stream.puts player_guess
        response = @i_stream.gets.chomp
        @player.return_response(response)
    end
end
