"""
FILE NAME: monteCarlo.jl

DESCRIBTION: this file contains the implementaion of Monte Carlo Search
	     tree algorithm, and its helper functions.
"""

# global data strcutures to keep track of states and 
# their statistics
plays = Dict()
wins = Dict()

function monte_carlo_search(b::Board, p::Player, simulationsNum::Int64)
        """ this is the implementation of Monte Carlo algorithm
	"""

	# obtains available columns. If there is only one
	# column left, it returns it
	valid_col = available_cols(b)
        if length(valid_col) == 1
                return valid_col[1]
        end

	# starts simulations until simulationsNum is reached
        gamesRan = 0
        while(gamesRan <= simulationsNum)
                gamesRan += 1
                runSimulation(b, p)
        end

	# after simulations are done, we calculate statistics
        play = nothing
        allMoves = []
        ratios = Dict()
       
	# we obtain all states and their children for available columns
	for i in valid_col
                nextMove = getNext(deepcopy(b), i, p.checker)
                append!(allMoves, [[i, nextMove]])
        end

	# then for each state, if visited, then we calculate the ratio
        for j=1:length(allMoves)
                play = [p.checker, allMoves[j][2]]
                if play in keys(wins)
                        ratios[allMoves[j][1]] = wins[play]/plays[play]
                else
                        ratios[allMoves[j][1]] = 0
                end
        end
        
	# we return the column number of the maximum ratio
	return findmax(ratios)[2]
end

function getNext(b::Board, c::Int64, checker::Char)
	""" obtains a new copy of the board successor """
        add_checker(b, c, checker)
        return b.slots
end

function find_winner(b::Board, p::Player)
	""" checks for winners in the board """
        if is_win_for_anywhere(b, p.checker)
                return p.checker
        elseif is_win_for_anywhere(b, opponent_checker(p))
                return opponent_checker(p)
        else
                return -1
        end
end

function UCT(w, n, c, N)
	""" calculates the UCT given 
	    w: # of wins of current state 
	    n: # of plays at current state
	    c: exploration parameter
	    N: total # of simulations 
	"""
	return (w/n) + c*sqrt(log(N)/n)
end

function runSimulation(b::Board, p::Player)
	""" we run the simulations here """ 
        visited = []
        checker = p.checker
        isExpand = true
        winnerChecker = -1
	state = deepcopy(b.slots)

	# will keep simulating until no columns are left
	# or a winner is found
        while true
		# obtains available cols, if none, break
                valid_col = available_cols(Board(state))
                if length(valid_col) == 0
                        break
                end

		# obtains all children of current state
                states = [(p, getNext(Board(state), p, checker)) for p in valid_col]

		# SELECTION
		# if we have explored all children, then calculate UCT scores
		# and choose the child with maximum UCT 
                # otherwise, randomly choose an unexpanded child
		if sum([haskey(plays, i) for i in states]) == length(states)
			w = wins[i]
			n = plays[i]
                        N = sum([plays[i] for i in states])

			all_scores = [UTC(w, n, C, N) for i in states]
                        value, move, state = max(all_scores)
                else
                        move, state = rand(states)
                end

		# EXPANSION
		# if we have not explored current child, initialize its stats
                if isExpand && !([checker, state] in keys(plays))
                        isExpand = false
                        plays[[checker, state]] = 0
                        wins[[checker, state]] = 0
                end

		# if we haven't visited the current state, add it to array
                if !([checker, state] in visited)
                        append!(visited, [[checker, state]])
                end

		# check for winners in current state
                possibe_winner = find_winner(Board(state), p)
                if possibe_winner != -1
                        winnerChecker = possibe_winner
                        break
                end

		# switch checkers
                checker = opponent_checker(p)
                p = deepcopy(p)
                p.checker = checker
        end

	# BACKPROPAGATION
        for i=1:length(visited)
                checker = visited[i][1]
                state = visited[i][2]

                if !([checker, state] in keys(plays))
                        continue
                end

                plays[[checker, state]] += 1
                if checker == winnerChecker
                        wins[[checker, state]] += 1
                end
        end
end

