"""
FILE NAME: board.jl

DESCRIBTION: this file holds functions applied to a Board struct
	     object such as adding checkers, clearing the board, 
	     and checking for winners
"""

include("structs.jl")

function clear(b::Board)
	""" clears the board slots """
	b.slots = fill(' ', (b.height, b.width))
end

function can_add_to(b::Board, c::Int64)
	""" checkks if column c is not full """
        return b.slots[1,c] == ' '
end

function available_cols(b::Board)
	""" returns a list of available columns """
	return [i for i in range(1, stop=b.width) if can_add_to(b, i)]
end

function is_full(b::Board)
	""" checks if the board b is full """
	for i = 1:b.width
		if b.slots[1, i] == ' ' return false end
	end
	return true
end

function add_checker(x::Board, c::Int64, checker::Char)
	""" adds a checker to the board b at column c """

	# asserts whether the checker is legal
	@assert(checker in ['O', 'X'], "invalid checker")
	r = 0
	for i = 1:x.height
		if x.slots[i, c] == ' ' r+=1 else break end
	end

	if r == 0
		println("Column is full, try another value")
		return false
	else
		x.slots[r,c] = checker
		return true
	end
end

function add_checkers(b::Board, cols::String)
	""" takes a string of column numbers and alternates adding 
	     checkers to the columns 
	"""

	# assets the column numbers are correct before adding
	@assert(sum([true for x in cols if parse(Int64,x) <= b.width]) == length(cols), "invalid column")
	checker = 'O'
	for col in cols
		add_checker(b, parse(Int64, col), checker)
		
		if checker == 'X'
			checker = 'O'
		else 
			checker = 'X'
		end
	end
end

function remove_checker(b::Board, c::Int64)
	""" removes the top checker from column c """
	for i = 1:b.height
		if b.slots[i, c] != ' '
			b.slots[i, c] = ' '
			break
		end
	end
end

function heighest_row(b::Board, c::Int64)
	""" gets the top free row in column c """
	i = 1
	for i = 1:b.height
		if b.slots[i, c] != ' '
			return i
		end
	end
	return b.height
end 


# =========================== Winning Checks ===========================

function is_vertical_win(b::Board, c::Int64, checker::Char)
	""" looks for 4 consecutive checkers vertically at col c"""
	hr = heighest_row(b, c)
	@assert(hr <= b.height && hr != -1, "invalid highest row")

	count = i = 0
	while count < 4 && (hr + i) <= b.height
		if b.slots[hr+i, c] == checker
			count += 1
		else 
			break
		end
		i += 1
	end
        if count >= 4 return true end

	i = 1
	while count < 4 && (hr - i) > 0
		if b.slots[hr - i, c] == checker
			count += 1
		else
			break
		end 
		i += 1
	end
        if count >= 4 return true end

	return false
end

function is_horizontal_win(b::Board, c::Int64, checker::Char)
        """ looks for 4 consecutive checkers horizontally at col c"""
	hr = heighest_row(b, c)
        @assert(hr <= b.height && hr != -1, "invalid highest row")
	
	count = i = 0
        while count < 4 && (c + i) <= b.width
                if b.slots[hr, c+i] == checker
                        count += 1
                else
                        break
                end
                i += 1
        end
        if count >= 4 return true end

	i = 1
	while count < 4 && (c - i) > 0
                if b.slots[hr, c-i] == checker
                        count += 1
                else
                        break
                end
                i += 1
        end
        if count >= 4 return true end

	return false
end

function is_up_diagonal_win(b::Board, c::Int64, checker::Char)
        """ looks for 4 consecutive checkers up diagonally (from left to right
	    around col c
	"""
	hr = heighest_row(b, c)
        @assert(hr <= b.height && hr != -1, "invalid highest row")

	count = i = j = 0
	while count < 4 && (hr-i) > 0 && (c+j) <= b.width
		if b.slots[hr-i, c+j] == checker
			count += 1
		else 
			break
		end
		i += 1
		j += 1
	end
        if count >= 4 return true end

        i = j = 1
        while count < 4 && (hr+i) <= b.height && (c-j) > 0
                if b.slots[hr+i, c-j] == checker
                        count += 1
                else 
                        break
                end
                i += 1
                j += 1
        end
        if count >= 4 return true end

	return false
end

function is_down_diagonal_win(b::Board, c::Int64, checker::Char)
        """ looks for 4 consecutive checkers down diagonally (from 
	    left to right around col c
        """
	hr = heighest_row(b, c)
        @assert(hr <= b.height && hr != -1, "invalid highest row")

        count = i = j = 0
        while count < 4 && (hr+i) <= b.height && (c+j) <= b.width
                if b.slots[hr+i, c+j] == checker
                        count += 1
                else
                        break
                end
                i += 1
                j += 1
        end
        if count >= 4 return true end

        i = j = 1
        while count < 4 && (hr-i) > 0 && (c-j) > 0
                if b.slots[hr-i, c-j] == checker
                        count += 1
                else
                        break
                end
                i += 1
                j += 1
        end
        if count >= 4 return true end

        return false
end

function is_win_for(b::Board, c::Int64, checker::Char)
	""" checks if there are 4 consecutive chekcer around
	    column c in any direction
	"""
	return is_vertical_win(b, c, checker) ||
	is_horizontal_win(b, c, checker) ||
	is_up_diagonal_win(b, c, checker) ||
	is_down_diagonal_win(b, c, checker)
end


function is_win_for_anywhere(b::Board, checker::Char)
	""" looks for a win for checker anywhere on the board """
	
	for c = 1:b.width
		if is_vertical_win(b, c, checker) ||
			is_horizontal_win(b, c, checker) ||
			is_up_diagonal_win(b, c, checker) ||
			is_down_diagonal_win(b, c, checker)
			return true
		end
	end
	return false
end
