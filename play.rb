require_relative 'game_io'
require_relative 'game_logic'

if ARGV[0].nil?
    code = "WWWW"
else
    code = ARGV[0].strip.upcase.match(/[RGBWYO]*/).to_s
    code = "WWWW" unless code.length == 4
end
outcome = GameLogic.game(code, 10, GameIO::Reader.new, GameIO::Writer.new)

puts "You #{outcome}!"
