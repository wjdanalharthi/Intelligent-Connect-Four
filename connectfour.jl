"""
FILE NAME: connectfour.jl

DESCRIBTION: this file holds the core of the Connect Four game. Here is
	     where the game is initiated, and players alternate, and moves
	     are made on the board.
"""

include("structs.jl")
include("board.jl")
include("player.jl")
include("eval.jl")
include("globals.jl")

function process_move(p::Player, b::Board, isRandom::Bool)
	""" this function takes care of processing the move
	    for player p and checking for a win or a tie
	"""
	println()
	print("$p's turn:")

	# if the current player is forced to play randomly
	# by the previous move of the opponent, then make a 
	# random move.
	# Otherwise, it will get a move based on the algorithm
	# the player is using.
	p_move = nothing
	if isRandom
		isRandom = false
		print(" (forced)")
		p_move = next_move_random(b, p)
	else	
		if p.type == 'm'
			p_move = next_move_minimax(b, p)
		elseif p.type == 'c'
			p_move = next_move_monteCarlo(b, p)
		elseif p.type == 'r'
			p_move, isRandom = next_move_expectiminimax(b, p)
		else
			p_move = next_move_human(b, p)
		end
	end

	# place the checker at the chosen column
	println(" at $p_move")
	add_checker(b, p_move, p.checker)
	println(b)

	# check for winning or a tie
        if is_win_for(b, p_move, p.checker)
		println()
		println("==================================================")
		print("WINNER: ")
		println("$p has won with $(p.moves) moves!")
		println("==================================================")
		println()
		return true, isRandom
        elseif is_full(b)
                println()
                println("==================================================")
                println("IT IS A TIE")
                println("==================================================")
                println()
		return true, isRandom
        else 
                return false, isRandom
        end
end

function prepareARGS(args::Array)
	""" this function prepares the command line arguments passed 
	    from the Game script by the user. 
	    It prepares the board dimensions, player types algorithms,
	    and the number of lookaheads chosen.
	    If none are provided, we use defaults from globals.jl
	"""

        height = width = player1 = player2 = lookahead1 = lookahead2 = 0
	
	# if none were provided, get defaults from globals.jl
	if length(args) == 0
		height, width = DEFAULT_DIM
		player1, player2 = DEFAULT_TYPES
		lookahead1 = looahead2 = parse(Int64, DEFAULT_LOOKAHEAD)
		return (height, width), (player1, player2), (lookahead1, lookahead2)
	end

	# prepare user board dimension input with error checking
	try
		height = parse(Int64, args[1][1])
		width = parse(Int64, args[1][2])
	catch
                println("ERROR: You entered invalid board dimensions")
                return 0
        end

	# prepare user player types input with error checking
        player1 = args[2][1]
        player2 = args[2][2]
        if (!(player1 in keys(PLAYERS_TYPES)) ||
            !(player2 in keys(PLAYERS_TYPES)))
                println("ERROR: You entered invalid players types. Check the README.txt for valid types")
                return 0
        end

	# prepare user lookahead inputs with error checking
        lookahead1 = lookahead2 = DEFAULT_LOOKAHEAD
	if length(args) == 3
		if length(args[3]) == 1
                	lookahead1 = args[3][1]
                	lookahead2 = args[3][1]
        	elseif length(args[3]) == 2
                	lookahead1 = args[3][1]
                	lookahead2 = args[3][2]
        	end
	end

        try
                lookahead1 = parse(Int64, lookahead1)
                lookahead2 = parse(Int64, lookahead2)
	catch
                println("ERROR: You entered invalid lookaheads")
                return 0
        end

	return (height, width), (player1, player2), (lookahead1, lookahead2)
end

function main(args::Array)
	""" this function starts the game. Gets arguments and prepares them first,
	    then initiate the board and players. Finally it alternates moves until
	    the game terminates by process_move() 
	"""

	# prepare arguments
	arguments = prepareARGS(args)
	if arguments == 0
		return 0
	end
	(height, width), (player1, player2), (lookahead1, lookahead2) = arguments

	# start the game
	println()
	println("==================================================")
	println("Welcome to Connect Four (size  $(height)x$(width))")
	print("Player X: $(PLAYERS_TYPES[player1]), ")
	println("Player O: $(PLAYERS_TYPES[player2])")
	println("==================================================")

	# create the board and players
	board = Board(height, width)
	p1 = Player('X', lookahead1,
                           PLAYERS_TYPES[player1], player1)
	p2 = Player('O', lookahead2,
                            PLAYERS_TYPES[player2], player2)
	
	# alternate turns between players until termination (win or tie)
	isRandom = false
	while true
		isOver, isRandom = process_move(p1, board, isRandom)
		if isOver return board end

                isOver, isRandom = process_move(p2, board, isRandom)
                if isOver return board end
	end
end

# call to main() with command line arguments ARGS
main(ARGS)
