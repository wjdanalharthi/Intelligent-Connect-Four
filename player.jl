"""
FILE NAME: board.jl

DESCRIBTION: this file holds functions applied to Player struct objects
	     including deciding next moves for different AI algorithms.
"""

include("structs.jl")
include("eval.jl")
include("expectiminimax.jl")
include("minimax.jl")
include("monteCarlo.jl")

function opponent_checker(p::Player)
	""" given a player object, returns 
	    the opponent's checker """
	if p.checker == 'X' return 'O' end
	return 'X'
end

function next_move_human(b::Board, p::Player)
	""" decides next move for a Human player by
	    prompting the user """

	p.moves += 1
	while true
		c = readline()
		try
			# error checking for input
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
	""" completely randomized next moves """
        p.moves += 1
	return rand(available_cols(b))
end

function next_move_minimax(b::Board, p::Player)
	""" obtains the move and score from Minimax alg """
	p.moves += 1
	(score, move) = minimax(b, p, p.lookahead, p.checker==Maximizer)
	return move
end

function next_move_expectiminimax(b::Board, p::Player)
	""" obtains the move ans score for Minimax with Random move alg.
	    It returns a flag along with the move. The flag determines
	    if the player chose to play randomly. If yes, it will force
	    the opponent to play randomly too.
	"""
        
	p.moves += 1
	isRandom = false
	isMaximizer = p.checker==Maximizer

	# obtain scores and moves from Minimax, and Expectiminimax
        (score, move) = minimax(b, p, p.lookahead, isMaximizer)
        (scoreRandom, moveRandom) = expectiminimax(b, p, p.lookahead, isMaximizer)

	# compare the two scores, if we chose Expectiminimax, we will
	# set the flag isRandom to true, otherwise stick with Minimax
        toPlay =  (score, move)
	if ((isMaximizer && scoreRandom > score) ||
		(!isMaximizer && scoreRandom < score))
		isRandom = true
		toPlay = (scoreRandom, moveRandom)
	end

	# if we set the flag to true, we get a random available column
	if isRandom
		move = rand(available_cols(b))
	end

	return move, isRandom
end


function next_move_monteCarlo(b::Board, p::Player)
	""" obtains move from Monte Carlo algorithm """
	p.moves += 1
	move = monte_carlo_search(b, p, Simulations)
	return move
end


function state_eval(b::Board, checker::Char, isMaximizer::Bool)
	""" obtains evaluation scores from the eval functions.
	    It gets 4 scores, and chooses the minimum """

	# obtain the scores per direction
	vertical_seq = vertical_eval(b, checker)
	horizontal_seq = horizontal_eval(b, checker)
	diagonalUp_seq = diagonal_up_eval(b, checker)
	diagonalDown_seq = diagonal_down_eval(b, checker)

	# get the minimum score  
	(score, move) = min([vertical_seq,
		    horizontal_seq,
		    diagonalUp_seq, 
		    diagonalDown_seq]...)

	# since we have minimizers and maximizers, we multiply
	# the score for maximizers by -1
	if isMaximizer
		return (score*-1, move)
	else
		return (score, move)
	end
end

function isOver(b::Board, p::Player, depth::Int64, isMaximizer::Bool)
        """ helper function for the implementations to check if the
            game is over (full or wins)
        """

	# if it is a win for current player and he's a maximizer
	# we return the most maximum number to insure he will choose
	# the current move
	# If, however, he's a minimizer, we give him the most minimum 
	# number to insure he chooses the current move
	#
	# on the other hand, if the player's opponent is winning,
	# and he is a maximizer, we giveh im the most minimum number to
	# insure he will block the opponent, and vice-versa
        if is_win_for_anywhere(b, p.checker)
                if isMaximizer
                        return (typemax(Int32), nothing)
                else
                        return (typemin(Int32), nothing)
                end
        elseif is_win_for_anywhere(b, opponent_checker(p))
                if isMaximizer
                        return (typemin(Int32), nothing)
                else
                        return (typemax(Int32), nothing)
                end
        end

	# if the board is full or the depth is zero, we evaluate and return
        if depth == 0 || is_full(b)
                (move, score) = state_eval(b, p.checker, isMaximizer)
                return (move, score)
        end

        return (false, false)
end
