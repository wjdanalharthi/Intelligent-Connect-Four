"""
FILE NAME: globals.jl

DESCRIBTION: this file holds global variables that are used commonly 
	     by other files
"""

# a map between player types and their algorithms
PLAYERS_TYPES = Dict([('h', "Human"),
                      ('m', "Minimax"),
                      ('c', "Monte Carlo"),
                      ('r', "Expectiminimax")])

# if not board dimensions are provided, use this default
DEFAULT_DIM = (6,7)

# if no player types are provided, use this default
DEFAULT_TYPES = ('r', 'm')

# if no lookahead is passed, this default is used
DEFAULT_LOOKAHEAD = '3'

# player X is always a maximizer
Maximizer = 'X'

# default number of Monte Carlo simulations
Simulations = 20000

# default exploration parameter
C = sqrt(2)
