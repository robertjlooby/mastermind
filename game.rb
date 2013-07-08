class Game
    attr_reader :player_io, :logic_io, :code, :num_turns

    def initialize(num_turns, code, 
                   player_io_class, player_class, 
                   logic_io_class, logic_class, 
                   p2l_read, p2l_write, 
                   l2p_read, l2p_write)
        @num_turns = num_turns
        @code = code
        @player_io = player_io_class.new player_class, l2p_read, p2l_write, logic_class
        @logic_io = logic_io_class.new logic_class, code, p2l_read, l2p_write
    end

    def take_turn
        outcome = nil
        player_thread = Thread.new do
            @player_io.guess
        end
        logic_thread = Thread.new do
            outcome = @logic_io.respond
        end
        player_thread.join
        logic_thread.join
        outcome
    end

    def play_game
        turn = 0
        @num_turns.times do 
            turn += 1
            if take_turn == [4, 0]
                return [:win, turn]
            end
        end
        [:lose, turn]
    end
end
