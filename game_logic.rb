class GameLogic
    def respond(guess, code)
        red = white = 0
        guess = guess.split("")
        actual = code.split("")

        guess.each_with_index do |guess_color, index|
            if guess_color == actual[index]
                red += 1 
                guess[index] = actual[index] = nil
            end
        end
        guess.compact!
        actual.compact!

        guess.each do |c|
            if actual.include? c
                white += 1
                actual.delete_at actual.index(c)
            end
        end

        [red, white]
    end
end
