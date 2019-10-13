
## Project Name: Connect Four Game
## Project Description
	This project implements the game of Connect Four wih different types of players. The players can be Humanor AI. The AI players can use different algorithms, including Minimax and Monte Carlo Search Tree. 

## How to Run
	1) make sure you give execution privliges to the script game.sh using `chmod u+x game.sh`
	2) follow the instructions in game.sh to learn more about the arguments needed. You can set 	      parameters such as Board Dimensions, and Player Types (AI algorithm), and Lookaheads.
	   Below are a couple of examples of how to run the game with different parameters
	
	./game.sh      		 	==>	runs the game with default board dimensions and 
						player types and lookaheads (found in globals.jl) 

	./game.sh 67 rc         ==>     runs the game with a board of size 6x7
                                        and Player 1 with Expectiminimax, and
                                        Player 2 with Monte Carlo

	./game.sh 67 mm 43      ==>     board of size 6x7, and two Minimax players

                                        with lookaheads 4 and 3 respectively
## Project Structure
	- questions.txt: contains short answers to the handout questions 1 and 3
	- discussion.pdf: short report and discussions of the game players performance using
			  different algorithms

	- game.sh: a script used to run the game with custom arguments
	- structs.jl: contains definitions of Board and Player structs with constructors
	- globals.jl: global constants used by different files in the project
	- board.jl: board-specific functions such as adding checkers and checking for winners
	- player.jl: player-specific functions including obtaining next moves for players from different algorithms
	- eval.jl: contains the evaluation functions used for Minimax and Expectiminimax
	- minimax.jl: implementation of Minimax
	- expectiminimax.jl: implementation of Expectiminmax (Minimax with random moves) 
	- monteCarlo.jl: implementation of Monte Carlo Search Tree with UCT
	- connectfour.jl: where the game is initiated, and players take turn. Announces winners and ties at the end of the game.
	- tests.jl: few tests to test the board winning functions 

