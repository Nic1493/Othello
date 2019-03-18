import Foundation

//define board size, create game board
let boardSize = 8;
var gameBoard: [[Character]] = [[Character]](repeating: [Character](repeating: " ", count: boardSize), count: boardSize);

//tokens (temp)
let black: Character = "b";
let white: Character = "w";
let empty: Character = "e";

//amount of discs on the board
var whiteCount = 2;
var blackCount = 2;

class Othello
{
	//ctor
	init()
	{

		for i in 0..<boardSize
		{
			for j in 0..<boardSize
			{
				gameBoard[i][j] = empty;
			}
		}
		
		gameBoard[3][3] = white;
		gameBoard[3][4] = black;
		gameBoard[4][3] = black;
		gameBoard[4][4] = white;
		
		DisplayGameBoard();
	}

	//prints gameBoard in grid fashion; will rework later
	func DisplayGameBoard()
	{
		for i in 0..<boardSize
		{
			for j in 0..<boardSize
			{
				print("\(gameBoard[i][j]) ", terminator:"");
			}
			print();
		}
		print();
	}
	
	//checks if the player can place colour disc at gameBoard[r][c]
	func ValidMove(colour: Character, r: Int, c: Int) -> Bool
	{
		var opponent: Character = empty;
		if colour == black
		{
			opponent = white;
		}
		else if colour == white
		{
			opponent = black;
		}
		
		//checks if there is an adjacent opponent disc in all 8 directions
		//returns true if at least one direction returns true
		if gameBoard[r][c] == empty
		{
			var distanceToEdge: Int = 0;
			
			//bottom
			if r + 1 < boardSize, gameBoard[r + 1][c] == opponent
			{
				distanceToEdge = boardSize - 1 - r;
				for x in 1...distanceToEdge
				{
					if gameBoard[r + x][c] == colour
					{
						return true;
					}
				}
			}
			
			//top
			if r - 1 > -1, gameBoard[r - 1][c] == opponent
			{
				distanceToEdge = r;
				for x in 1...distanceToEdge
				{
					if gameBoard[r - x][c] == colour
					{
						return true;
					}
				}
			}
			
			//right
			if c + 1 < boardSize, gameBoard[r][c + 1] == opponent
			{
				distanceToEdge = boardSize - 1 - c;
				for y in 1...distanceToEdge
				{
					if gameBoard[r][c + y] == colour
					{
						return true;
					}
				}
			}
			
			//left
			if c - 1 > -1, gameBoard[r][c - 1] == opponent
			{
				distanceToEdge = c;
				for y in 1...distanceToEdge
				{
					if gameBoard[r][c - y] == colour
					{
						return true;
					}
				}
			}
			
			//bottom right
			if r + 1 < boardSize, c + 1 < boardSize, gameBoard[r + 1][c + 1] == opponent
			{
				distanceToEdge = min(boardSize - 1 - r, boardSize - 1 - c);
				for xy in 1...distanceToEdge
				{
					if gameBoard[r + xy][c + xy] == colour
					{
						return true;
					}
				}
			}
			
			//bottom left
			if r + 1 < boardSize, c - 1 > -1, gameBoard[r + 1][c - 1] == opponent
			{
				distanceToEdge = min(boardSize - 1 - r, c);
				for xy in 1...distanceToEdge
				{
					if gameBoard[r + xy][c - xy] == colour
					{
						return true;
					}
				}
			}
			
			//top left
			if r - 1 > -1, c - 1 > -1, gameBoard[r - 1][c - 1] == opponent
			{
				distanceToEdge = min(r, c);
				for xy in 1...distanceToEdge
				{
					if gameBoard[r - xy][c - xy] == colour
					{
						return true;
					}
				}
			}
			
			//top right
			if r - 1 > -1, c + 1 < boardSize, gameBoard[r - 1][c + 1] == opponent
			{
				distanceToEdge = min(r, boardSize - 1 - c);
				for xy in 1...distanceToEdge
				{
					if gameBoard[r - xy][c + xy] == colour
					{
						return true;
					}
				}
			}
		}
		
		return false;
	}
	
	func MakeMove(colour: Character, r: Int, c: Int)
	{
		//places disc
		gameBoard[r][c] = colour;
		
		for i in stride(from: 0, to:Double.pi * 2, by:Double.pi / 4)
		{			
			FlipDiscs(colour: colour, r: r, c: c, yDelta: Int(round(sin(i))), xDelta: Int(round(sin(i + Double.pi / 2))));
		}
		
		DisplayGameBoard();
	}
	
	func FlipDiscs(colour: Character, r: Int, c: Int, yDelta: Int, xDelta: Int)
	{
		//print("\(yDelta), \(xDelta)");
		var nextRow: Int = r + yDelta;
		var nextCol: Int = c + xDelta;
		
		if nextRow < boardSize, nextRow > -1, nextCol < boardSize, nextCol > -1
		{
			while gameBoard[nextRow][nextCol] != empty
			{
				if gameBoard[nextRow][nextCol] == colour
				{
					while !(r == nextRow && c == nextCol)
					{
						gameBoard[nextRow][nextCol] = colour;
						nextRow -= yDelta;
						nextCol -= xDelta;
					}
					break;
				}
				else
				{
					nextRow += yDelta;
					nextCol += xDelta;
				}
			}
		}
	}
	
	//have the AI place a tile on a valid position
	//if there is more than 1 valid position, pick at random
	func RunCPU(colour: Character)
	{
		var possibleValidMoves: [[Int]] = FindValidMoves(colour: colour);
		srand(UInt32(time(nil)));
		let randNum = Int("\(rand())")! % possibleValidMoves.count;
		let randChoice: [Int] = possibleValidMoves[randNum];
		print("CPU has selected to make move at \(randChoice)");
		MakeMove(colour: colour, r: randChoice[0], c: randChoice[1]);
	}
	
	func FindValidMoves(colour: Character) -> [[Int]]
	{
		var validMoves: [[Int]] = [[Int]]();
		
		for i in 0..<boardSize
		{
			for j in 0..<boardSize
			{
				if gameBoard[i][j] == empty
				{
					if ValidMove(colour: colour, r: i, c: j)
					{		
						var coordinate: [Int] = [Int]();
						coordinate.append(i);
						coordinate.append(j);
						validMoves.append(coordinate);
					}
				}
			}
		}
		
		print("Possible moves: \(validMoves)");
		return validMoves;
	}
	
	//returns true if board is full
	func IsGameOver() -> Bool
	{
		return blackCount + whiteCount >= boardSize * boardSize;
	}
	
	//prints winner based on which colour appears more on the board
	func DisplayWinner()
	{
		print (blackCount > whiteCount ? "Black wins!" : blackCount != whiteCount ? "White wins!" : "Tie game!");
	}
	
	//main game loop
	//play against simple AI if singlePlayer == true
	func PlayGame(singlePlayer: Bool)
	{
		var turn = black;
		
		if singlePlayer
		{
			while !IsGameOver()
			{
				let row = readLine();
				let col = readLine();
				let r = Int(row!);
				let c = Int(col!);
				
				if ValidMove(colour: turn, r: r!, c: c!)
				{
					MakeMove(colour: turn, r: r!, c: c!);
					
					//start CPU's turn
					turn = white;
					print("CPU's turn.");
					RunCPU(colour: turn);
					
					turn = black;
					print("Player's turn.");
				}
				else
				{
					print("Invalid move.");
				}
			}
		}
		else
		{
			while !IsGameOver()
			{
				let row = readLine();
				let col = readLine();			
				let r = Int(row!);
				let c = Int(col!);
				
				if ValidMove(colour: turn, r: r!, c: c!)
				{
					MakeMove(colour: turn, r: r!, c: c!);
					
					if turn == black
					{
						turn = white;
						print("White's turn.");
					}
					else if turn == white
					{
						turn = black;
						print("Black's turn.");
					}
				}
				else
				{
					print("Invalid move.");
				}			
			}
		}
	}
}

let game = Othello();
game.PlayGame(singlePlayer: false);