"""
FILE NAME: eval.jl

DESCRIBTION: this file contains the evaluation functions of the board.
	     It contains 4 functions, one per direction. It also includes
	     helper functions.
"""

function overheads_eval(b::Board, row::Int64, col::Int64)
	""" this function calculates the overheads. For more
	    information check the README.txt """

	overheads = 0
        i = row + 1
	j = col
        while i <= b.height
		if b.slots[i, j] == ' '
			overheads += 1
		else
			break
		end
		i += 1
	end
	return overheads
end

function heighest_row(b::Board, c::Int64)
        """ this function gets the # of the higest
	    available row
	"""

	i = 1
        for i = 1:b.height
                if b.slots[i, c] != ' '
                        return i
                end
        end
        return b.height
end

function get_minimum(scores::Array)
        if length(scores) == 0
                return (100, -1)
        elseif length(scores) == 1
                return scores[1]
        else
                return min(scores...)
        end
end

function vertical_eval(b::Board, checker::Char)
	""" this function gets scores of vertical
	    directions throughout the board
	"""

	scores = []	
	for col = 1:b.width
		row = b.height
		count = 0
		while row > 0
			current = b.slots[row,col]
			if current == checker count += 1
			elseif current == ' '
				remaining = 4 - count
				if row <= remaining break end
				overheads = 1
				score = remaining + overheads
				append!(scores, [(score, col)])
				break
			else count = 0 end
			row -= 1
		end
	end
	return get_minimum(scores)
end


function horizontal_eval(b::Board, checker::Char)
        """ this function gets scores of horizontal
            directions throughout the board
        """

	scores = []
	for row = 1:b.height
		col = 1
		count = 0
		while col <= b.width
                        current = b.slots[row,col]
                        if current == checker count += 1
                        elseif current == ' ' && count != 0
                                remaining = 4 - count
				overheads = overheads_eval(b, row, col)
                                score = remaining + overheads
				append!(scores, [(score, col)])
                                break
			else count = 0 end
			col += 1
		end
	end

        for row = 1:b.height
                col = b.width
                count = 0
                while col > 0
                        current = b.slots[row,col]
                        if current == checker count += 1
                        elseif current == ' ' && count != 0
                                remaining = 4 - count
				overheads = overheads_eval(b, row, col)
                                score = remaining + overheads
				append!(scores, [(score, col)])
                                break
			else count = 0 end
                        col -= 1
                end
        end
        return get_minimum(scores)
end

function diagonal_up_eval(b::Board, checker::Char)
        """ this function gets scores of diagonal up 
	    (from left to right) directions throughout the board
        """
	
	scores = []
	row = b.height
	col = 1
	count = 0

	rows = b.height
	cols = 1
	while rows > 0
		row = rows
		cols = 1
		while cols <= b.width
			col = cols
			row = rows
			count = 0
			while row > 0 && col <= b.width
                        	current = b.slots[row, col]
                        	if current == checker count += 1
                        	elseif current == ' ' && count != 0
                                	remaining = 4 - count
                                	overheads = overheads_eval(b, row, col)
                                	score = remaining + overheads
					append!(scores, [(score, col)])
                                	break
				else count = 0 end
				col += 1
				row -= 1
			end
			cols += 1
		end
		rows -= 1
	end

        row = 1
        col = b.width
        count = 0

        rows = 1
        cols = b.width
        while rows <= b.height
                row = rows
                cols = b.width
                while cols > 0
                        col = cols
                        row = rows
                        count = 0
                        while row <= b.height && col > 0
                                current = b.slots[row, col]
                                if current == checker count += 1
                                elseif current == ' ' && count != 0
                                        remaining = 4 - count
					overheads = overheads_eval(b, row, col)
                                        score = remaining + overheads
					append!(scores, [(score, col)])
                                        break
				else count = 0 end
                                col -= 1
                                row += 1
                        end
                        cols -= 1
                end
                rows += 1
        end
	return get_minimum(scores)
end


function diagonal_down_eval(b::Board, checker::Char)
        """ this function gets scores of diagonal down 
            (from left to right) directions throughout the board
        """
	scores  = []
        
	row = b.height
        col = b.width
        count = 0

        rows = b.height
        cols = b.width
        while rows > 0
                row = rows
                cols = b.width
                while cols > 0
                        col = cols
                        row = rows
                        count = 0
                        while row > 0 && col > 0
                                current = b.slots[row, col]
                                if current == checker count += 1
                                elseif current == ' ' && count != 0
                                        remaining = 4 - count
                                        overheads = overheads_eval(b, row, col)
                                        score = remaining + overheads
					append!(scores, [(score, col)])
                                        break
				else count = 0 end
                                col -= 1
                                row -= 1
                        end
                        cols -= 1
                end
                rows -= 1
        end

        row = 1
        col = 1
        count = 0

        rows = 1
        cols = 1
        while rows <= b.height
                row = rows
                cols = 1
                while cols <= b.width
                        col = cols
                        row = rows
                        count = 0
                        while row <= b.height && col <= b.width
                                current = b.slots[row, col]
                                if current == checker count += 1
                                elseif current == ' ' && count != 0
                                        remaining = 4 - count
                                        overheads = overheads_eval(b, row, col)
                                        score = remaining + overheads
					append!(scores, [(score, col)])
                                        break
				else count = 0 end
                                col += 1
                                row += 1
                        end
                        cols += 1
                end
                rows += 1
        end
        return get_minimum(scores)
end
