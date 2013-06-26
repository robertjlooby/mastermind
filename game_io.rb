module GameIO
    class Writer
        def initialize(o_stream = $stdout)
            @o_stream = o_stream
        end

        def ask_for_guess
            @o_stream.puts "Please enter your guess: (as a string of 4 letters, RGBWYO)"
        end

        def write_response(response)
            @o_stream.puts "The result is #{response[0]} red pins, #{response[1]} white pins"
        end
    end

    class Reader
        def initialize(i_stream = $stdin)
            @i_stream = i_stream
        end
        
        def read_guess
            guess = @i_stream.gets.strip.upcase.match(/[RGBWYO]*/).to_s
            return read_guess unless guess.length == 4
            guess
        end
    end
end
