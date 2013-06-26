module GameLogic
    def self.guess(guess, actual)
        red = white = 0
        guess = guess.split("")
        actual = actual.split("")

        (0 ... guess.length).each do |index|
            if guess[index] == actual[index]
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
