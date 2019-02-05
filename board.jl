
mutable struct Board
	height::Int64
	width::Int64
	slots::Array{Char, 2}
end

function Board(height, width)
	slots = fill(' ', (height, width))
	return Board(height, width, slots)
end

function Base.show(io::IO, x::Board)
	Base.show(io, "text/plain", x.slots)
end

function clear(x::Board)
	x.slots = fill(' ', (x.height, x.width))
end

function can_add_to(x::Board, c::Int64)
        return x.slots[1,c] == ' '
end

function available_cols(b::Board)
	return [i for i in range(1, stop=b.width) if can_add_to(b, i)]
end

function is_full(b::Board)
	for i = 1:b.width
		if b.slots[1, i] == ' '
			return false
		end
	end
	return true
end

function add_checker(x::Board, c::Int64, checker::Char)
	@assert(checker in ['O', 'X'], "invalid checker")

	r = 0
	for i = 1:x.height
		#println("checking $i, $c")
		if x.slots[i, c] == ' '
			r+=1
		else
			break
		end
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

#remove checker?
function remove_checker() 
	println("Not Implemented Yet")
end

function heighest_row(b::Board, c::Int64)
	i = 1
	for i = 1:b.height
		if b.slots[i, c] != ' '
			return i
		end
	end
	return -1
end 

function is_vertical_win(b::Board, c::Int64, checker::Char)
	hr = heighest_row(b, c)
	@assert(hr <= b.height && hr != -1, "invalid highest row")

	count = 0
	i = 0
	while count < 4 && (hr + i) <= b.height
		#println("checking $(hr+i), $c")
		if b.slots[hr+i, c] == checker
			count += 1
		else 
			break
		end
		i += 1
	end

	#println("number of checker1 $count")
	if count >= 4 
		return true
	end

	i = 1
	while count < 4 && (hr - i) > 0
		#println("checking $(hr-i), $c")
		if b.slots[hr - i, c] == checker
			count += 1
		else
			break
		end 
		i += 1
	end

	#println("number of checker2 $count")
	if count >= 4 
		return true
	end

	return false
end

function is_horizontal_win(b::Board, c::Int64, checker::Char)
        hr = heighest_row(b, c)
        @assert(hr <= b.height && hr != -1, "invalid highest row")
	
	count = 0
        i = 0
        while count < 4 && (c + i) <= b.width
                #println("checking $(c+i), $c")
                if b.slots[hr, c+i] == checker
                        count += 1
                else
                        break
                end
                i += 1
        end

        #println("number of checker1 $count")
        if count >= 4
                return true
        end

	i = 1
	while count < 4 && (c - i) > 0
                #println("checking $(c-i), $c")
                if b.slots[hr, c-i] == checker
                        count += 1
                else
                        break
                end
                i += 1
        end

        #println("number of checker2 $count")
        if count >= 4
                return true
        end

	return false
end

function is_up_diagonal_win(b::Board, c::Int64, checker::Char)
        hr = heighest_row(b, c)
        @assert(hr <= b.height && hr != -1, "invalid highest row")

	count = 0
	i = 0
	j = 0
	while count < 4 && (hr-i) > 0 && (c+j) <= b.width
		if b.slots[hr-i, c+j] == checker
			count += 1
		else 
			break
		end
		i += 1
		j += 1
	end

        #println("number of checker1 $count")
        if count >= 4
                return true
        end

        i = 1
        j = 1
        while count < 4 && (hr+i) <= b.height && (c-j) > 0
                if b.slots[hr+i, c-j] == checker
                        count += 1
                else 
                        break
                end
                i += 1
                j += 1
        end

	#println("number of checker2 $count")
        if count >= 4
                return true
        end
	
	return false
end

function is_down_diagonal_win(b::Board, c::Int64, checker::Char)
        hr = heighest_row(b, c)
        @assert(hr <= b.height && hr != -1, "invalid highest row")

        count = 0
        i = 0
        j = 0
        while count < 4 && (hr+i) <= b.height && (c+j) <= b.width
                if b.slots[hr+i, c+j] == checker
                        count += 1
                else
                        break
                end
                i += 1
                j += 1
        end

        #println("number of checker1 $count")
        if count >= 4
                return true
        end

        i = 1
        j = 1
        while count < 4 && (hr-i) > 0 && (c-j) > 0
                if b.slots[hr-i, c-j] == checker
                        count += 1
                else
                        break
                end
                i += 1
                j += 1
        end

        #println("number of checker2 $count")
        if count >= 4
                return true
        end

        return false
end

function is_win_for(b::Board, c::Int64, checker::Char)
	return is_vertical_win(b, c, checker) ||
	is_horizontal_win(b, c, checker) ||
	is_up_diagonal_win(b, c, checker) ||
	is_down_diagonal_win(b, c, checker)
end

#b = Board(5,5)
#b.slots[1] = 'd'
#clear(b)
