require_relative 'game_logic'
require_relative 'game_logic_io'
require_relative 'player_io'
require_relative 'human_player'
require_relative 'game'

if ARGV[0].nil?
    code = "RGBWYO".split("").repeated_permutation(4).to_a.sample.join
else
    code = ARGV[0].strip.upcase.match(/[RGBWYO]*/).to_s
    code = "WWWW" unless code.length == 4
end

p2l_read, p2l_write = IO.pipe
l2p_read, l2p_write = IO.pipe

game = Game.new(10, code, 
                PlayerIO, HumanPlayer, 
                GameLogicIO, GameLogic, 
                p2l_read, p2l_write, 
                l2p_read, l2p_write)
outcome = game.play_game

puts "You #{outcome}!"
puts "Code was #{code}"
