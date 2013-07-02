class Game
    attr_reader :player, :logic, :code, :num_turns

    def initialize(num_turns, code, player_class, logic_class, p2l_read, p2l_write, l2p_read, l2p_write)
        @num_turns = num_turns
        @code = code
        @player = player_class.new l2p_read, p2l_write
        @logic = logic_class.new code, p2l_read, l2p_write
    end

    def take_turn
        outcome = nil
        player_thread = Thread.new do
            @player.guess
        end
        logic_thread = Thread.new do
            outcome = @logic.respond
        end
        player_thread.join
        logic_thread.join
        outcome
    end

    def play_game
        @num_turns.times { return :win if take_turn == [4, 0] }
        :lose
    end
end
