"""
FILE NAME: minimax.jl

DESCRIBTION: this file holds the implementation of Minimax algorithm
"""

function minimax(b::Board, p::Player, depth::Int64, isMaximizer::Bool)
        """ implementation of the Minimax algorithm
	"""

	# start with large minimum-1 number for Maximizer, and large 
	# positive number+1 for Minimizer. 
	if isMaximizer
                best = (typemin(Int32)-1, nothing)
	else
                best = (typemax(Int32)+1, nothing)
        end

	# if the game is over (win or full board), return the scores 
	(score, move) = isOver(b, p, depth, isMaximizer)
	if score != false return (score, move) end

	# get al available columns
        valid_col = available_cols(b)
        for valid_move in valid_col

		# add a checker 
		add_checker(b, valid_move, p.checker)

		# create an apponent, and get his Minimax scores 
                opponent_player = Player(opponent_checker(p), p.lookahead, p.alg, p.type)
                (score, move) = minimax(b, opponent_player, depth-1, !isMaximizer)
                remove_checker(b, valid_move)
              
		# update the best scores depending if the player is
		# a maximizer or a minimizer
                if isMaximizer && score > best[1]
                        best = (score, valid_move)
                elseif !isMaximizer && score < best[1]
                        best = (score, valid_move)
                end
        end

        return best
end
