module AIGameIO
    class Writer
        def initialize(player)
            @player = player
        end

        def ask_for_guess
        end

        def write_response(response)
            @player.read_response response
        end
    end

    class Reader
        def initialize(player)
            @player = player
        end

        def read_guess
            @player.write_guess
        end
    end
end
