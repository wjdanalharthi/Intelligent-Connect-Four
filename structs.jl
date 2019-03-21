"""
FILE NAME: structs.jl

DESCRIBTION: this file contains struct definitions of Board and Player.
	     It also contains constructors for each type, as well as
	     custom print functions.
"""

# =============================== Board ============================
mutable struct Board
        height::Int64
        width::Int64
        slots::Array{Char, 2}
end

function Board(height, width)
	""" Board constructor 1 """
        slots = fill(' ', (height, width))
        return Board(height, width, slots)
end

function Board(arr::Array{Char,2})
	""" Board constructor 2 """
        slots = deepcopy(arr)
        height, width = size(slots)
        return Board(height, width, slots)
end

function Base.show(io::IO, b::Board)
	""" Custom print to override Base.show. It prints the board
	    nicely with column numbers 
	"""
	#println()
        output = ""
        for r = 1:b.height
		output *= " | "
                for c=1:b.width
                        output *= b.slots[r, c] * " | "
                end
                output *= "\n"
        end
        output *= repeat("-", b.width*4 + 3)
	output *= "\n"
	for c = 1:b.width
		output *= "   " * string(c)  
	end
	println(output)
end


# =============================== Player ============================
mutable struct Player
        checker::Char
        lookahead::Int64
        alg::String
        type::Char
        moves::Int64
end

function Player(checker::Char, lookahead::Int64, alg::String, type::Char)
	""" Player constructor """
        return Player(checker, lookahead, alg, type, 0)
end

function Base.show(io::IO, p::Player)
	""" Custom print function. Prints the player's checker 
	    with the algorithm is uses
	"""
        print("Player $(p.checker) ($(p.alg))")
end

