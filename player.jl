
mutable struct Player
        checker::Char
        moves::Int64
end

function Player(checker::Char)
	return Player(checker, 0)
end

function Base.show(io::IO, p::Player)
	print("Player $(p.checker)")
end


function opponent_checker(p::Player)
	if p.checker == 'X'
		return 'O'
	end
	return 'X'
end

function next_move_human(b::Board, p::Player)
	p.moves += 1

	while true
		c = readline()
		try
			c = parse(Int64, c)
			if c > 0 && c <= b.width && can_add_to(b, c)
				return c
			elseif !can_add_to(b, c)
				println("Column is full, try another column")
			else
				println("Value outside range, try again")
			end
		catch ArgumentError
			println("Invalid value, try again")
		end
	end
end

function next_move_random(b::Board, p::Player)
        p.moves += 1
	return rand(available_cols(b))

end
