require_relative 'game_logic'
require_relative 'ai_player'
require_relative 'ai_game_io'

if ARGV[0].nil?
    code = "WWWW"
else
    code = ARGV[0].strip.upcase.match(/[RGBWYO]*/).to_s
    code = "WWWW" unless code.length == 4
end

ai = AIPlayer.new
GameLogic.game(code, 10, AIGameIO::Reader.new(ai), AIGameIO::Writer.new(ai))
