require_relative 'game_logic'
require_relative 'game_logic_io'
require_relative 'player_io'
require_relative 'ai_player'
require_relative 'game'

possible_codes = []
%w(R G B W Y O).repeated_permutation(4) do |perm|
    possible_codes << perm.join
end

outcomes = Hash.new(0)
possible_codes.each do |code|
    p2l_read, p2l_write = IO.pipe
    l2p_read, l2p_write = IO.pipe

    game = Game.new(10, code, 
                    PlayerIO, AIPlayer, 
                    GameLogicIO, GameLogic, 
                    p2l_read, p2l_write, 
                    l2p_read, l2p_write)
    _, turns = game.play_game
    outcomes[turns] += 1
end

outcomes = outcomes.to_a.sort_by { |turns, _| turns }
outcomes.each do |turns, count|
    puts "Won in #{turns}, #{count} times"
end
