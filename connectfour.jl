
function process_move(p::Player, b::Board)
	println()
	
	println("$p's turn:")
	p_move = next_move_random(b, p)
        
	add_checker(b, p_move, p.checker)

	println(b)

        if is_win_for(b, p_move, p.checker)
                println("$p has won with $(p.moves) moves!")
		return true
        elseif is_full(b)
                println("board is full!")
		return true
        else 
                return false
        end
end

function main()
	println("Welcome to Connect Four")
	println("Enter the preferred board dimensions")

	#TODO add invalidity checks
	#TODO add quit option

	print("Height: ")
	height = readline()

	if is_quit(height)
		return
	end

	print("\nWidth: ")
	width = readline()

	if is_quit(width) return end

	board = Board(parse(Int64, height), parse(Int64, width))

	p1 = Player('X')
	p2 = Player('O')

	while true
		if process_move(p1, board)
			return board
		end
		if process_move(p2, board)
			return board
		end
	end
end

function is_quit(s::String)
        if s in ["q", "quit"]
		return true
        end
	return false
end

main()
