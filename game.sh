#!/bin/bash
#================================== HEADER =====================================
#
#  DESCRIPTION: this is a script to be used to run the Connect Four game.
#		It will use the arguments passed by the user to pass to Julia.
#		In the case no arguments were passed, the defaults will be used.
#		Below is an explanation of how to pass arguments
#
#  ARGUMENTS: The arguments are optional, but that means the defaults will be 
#	      used. If you want specific board dimensions, player types, or
#	      lookaheads, you must pass arguments. The arguments format are 
#	      as follows
#	REQUIRED:
#		1) Board Dimensions: passed in the format `HW` where `H` is the
#		   height, and `W` is the width. For example, `67` means a board
#		   of size 6x7
#		2) Players Types: passed in the format `P1P2` where `P1`
#		   corresponds to Player1's type, and similarly for P2. The
#		   different possible types are explained below:
#			- `m`: a player using the Minimax Algorithm
#			- `r`: a player using the Expectiminimax (Minimax with
#			       random moves) Algorithm
#			- `c`: a player using Monte Carlo Search Tree Algorithm
#			- `h`: a Human player (promtes user for column choices)
#		For example, passing `mc` means Player1 is a Minimax player, while
#		Player2 is a Monte Carlo player.
#	OPTIONAL:
#		3) Lookaheads: passed in the format `P1P21` such thatr P1 is 
#		   Player1's lookahead, and similarly for Player2.
#		For example, passing `45` means Player 1 has lookahead of 4, 
#		while Player 2 has a lookahead of 5.
#		NOTE: Lookaheads are only used for Minimax and Expectiminimax
#		      players.
#	
#  EXAMPLES:
#	./game.sh 67 rc 	==> 	runs the game with a board of size 6x7
#					and Player 1 with Expectiminimax, and
#					Player 2 with Monte Carlo
#
#	./game.sh 67 mm 43	==> 	board of size 6x7, and two Minimax players
#					with lookaheads 4 and 3 respectively
#
#============================================================================

boardDimensions=$1
playersTypes=$2
lookaheads=$3

if [ -z $boardDimensions ] | [ -z $playersTypes ]
then
	echo "WARNING: you have not set the Board Dimensions or Players Types. The default will be used"
fi

if [[ ${playersTypes:0:1} == 'm' ]] || [[ ${playersTypes:0:1} == 'r' ]] ||
	[[ ${playersTypes:1:1} == 'm' ]] || [[ ${playersTypes:1:1} == 'r' ]]
then
	if [ -z $lookaheads ]
	then
		echo "WARNING: you have not set Lookaheads for your Minimax players. The defaults will be used"
	fi
fi

julia connectfour.jl $boardDimensions $playersTypes $lookaheads

