
function test_board()
	b = Board(7, 7)

	add_checkers(b, "1121314")
	println(b)
	println("horizontal O: $(is_horizontal_win(b, 4, 'O'))\n")
	
	add_checker(b, 1, 'X') 
	println(b)
	println("vertical X: $(is_vertical_win(b, 1, 'X'))\n")

	clear(b)

	add_checkers(b, "23344545515");
	println(b)
	println("Diagonal Up O: $(is_up_diagonal_win(b, 2, 'O'))\n")

        clear(b)

        add_checkers(b, "12345342322");
        println(b)
        println("Diagonal Down O: $(is_down_diagonal_win(b, 2, 'O'))\n")

end

function test_player()
	println("Not Implemented Yet")
end

function run_tests()
	println("Running Tests")
	test_board()
	test_player()
end

