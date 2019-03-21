"""
FILE NAME: expectiminimax.jl

DESCRIBTION: this file holds the implementation of Expectiminimax (or 
	     Minimax with Random moves) alogrithm
"""

function expectiminimax(b::Board, p::Player, depth::Int64, isMaximizer::Bool)
	""" the implementation of Expectiminimax (Minimax with Random move).
	    It plays two levels of depth by averaging the scores of all successors,
	    and the remaining levels of depths are obtained from regular Minimax.
	    The scores of the first 2 layers are obtained iteratively, while
	    the remaining levels are recursive (with Minimax).
	"""
	move = score = 0
	
	# there will be two layers (two depths) with probabilistic scores 
	# obtained by averaging. 
	# the variable `layer1` will collect scores of children at depth
	# in addition to the variable `layer2` which collects scores of
	# children at depth-1
	layer1 = 0

	# available cols for layer 1 (depth=depth)
        layer1_cols = available_cols(b)
        for c1 in layer1_cols
		# add checker 
                add_checker(b, c1, p.checker)

		# if the game is over (full or win), remove the checker
		# add the score to layer1, and break to next child 
		(score, move) = isOver(b, p, depth, isMaximizer)
		if score != false
			move = c1
			layer1 += score
			remove_checker(b, c1)
			break
		end

		# if not over, evaluate state and add score to layer1
                (score, move) = state_eval(b, p.checker, isMaximizer)
                layer1 += score

		# starting layer 2
                layer2 = 0

		# available cols for layer 2 (depth=depth-1)
                layer2_cols = available_cols(b)
                for c2 in layer2_cols
			# get apponent's checker and add it at c2
                        opponent = opponent_checker(p)
                        add_checker(b, c2, opponent)
                
			# if the game is over (full or win), remove checker,
			# add score to layer2, then break to next child
			(score, move) = isOver(b, p, depth, !isMaximizer)
			if score != false
        	                move = c2
				layer2 += score
				remove_checker(b, c2)
                	        break 
                	end

			(score, move) = state_eval(b, opponent, !isMaximizer)
                        layer2 += score
        		
			# getting score for remaining levels (depth-2 .. 0) using
			# the Minimax algorithm, and add it to layer2
			score = 0
			if depth >= 2
                		score, move = minimax(b, p, depth-2, isMaximizer)
        		end
			layer2 += score
		
			# remove checker for layer2
			remove_checker(b, c2)
                end

		# average scores of layer2, and add it to layer1
                layer2 *= (1/length(layer2_cols))
                layer1 += layer2

		# remove checker for layer1
                remove_checker(b, c1)
        end

	# average scores of layer1
        layer1 *= (1/length(layer1_cols))

        return layer1, move
end
