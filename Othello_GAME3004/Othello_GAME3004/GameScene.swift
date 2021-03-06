//
//  GameScene.swift
//  Othello_GAME3004
//
//  Created by Darren Yam on 2019-03-12.
//  Copyright © 2019 Codex. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // MARK: Game logic vars
    //set board dimensions; internalize game board array
    let boardSize: Int = 8
    var gameBoard: [[Character]]!
    var numTurnsPassed: Int = 0                 //how many turns have passed without the board state changing?
    var gameOver: Bool = false
    
    //character tokens for internal array handling
    let black: Character = "b"
    let white: Character = "w"
    let empty: Character = "e"
    var currentTurn: Character = " "
    
    //amount of discs on the board (game starts with 2 each on board)
    var whiteCount = 2
    var blackCount = 2
    
    //enable/disable AI
    let singlePlayer: Bool = UserDefaults.standard.bool(forKey: "singlePlayer")
    
    // MARK: Scene display vars
    //general
    var background: SKSpriteNode!
    var inputEnabled: Bool = true
    var clickParticle: SKEmitterNode!
    var touchStartLoc: CGRect!
    
    //game
    var board: SKSpriteNode!
    let greenRatio: CGFloat = 73.0 / 80.0       //the percentage of the board sprite that is green
    var blackDisc: SKSpriteNode!
    var whiteDisc: SKSpriteNode!
    var hintSprite: SKSpriteNode!
    var hintsActive: Bool = true
    let cpuDelay: Double = 1.0                  //how long the CPU delays itself before making a move (for the sake of R E A L I S M)
    
    //text display
    let playerTurnLabel: SKLabelNode! = SKLabelNode(text: "Black's turn.")
    let blackTitleLabel: SKLabelNode! = SKLabelNode(text: "Black")
    let whiteTitleLabel: SKLabelNode! = SKLabelNode(text: "White")
    var blackCountLabel: SKLabelNode!
    var whiteCountLabel: SKLabelNode!
    
    //animations
    var blackToWhiteAnim: SKAction!
    var whiteToBlackAnim: SKAction!
    let animTimePerFrame: Double = 0.05         //length of 1 frame in the disc-flipping animation
    let animDelay: Double = 0.6                 //length of the delay before re-allowing input since starting the animation
    
    //buttons
    var pauseButton: SKSpriteNode!
    var soundButton: SKSpriteNode!
    var hintButton: SKSpriteNode!
    
    //audio
    var soundOn: Bool = UserDefaults.standard.bool(forKey: "sound")
    var audioPlayer = AVAudioPlayer()
    var sfxClickDown: URL!
    var sfxClickUp: URL!
	var sfxDiscPlace: URL!
    
    override init(size: CGSize) {
        super.init(size: size)
        touchStartLoc = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        background = SKSpriteNode(imageNamed: "menu-BG")
        background?.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background?.zPosition = -2
        addChild(background)
        
        pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: "back"))
        addChild(pauseButton)
        pauseButton.anchorPoint = CGPoint(x: 0, y: 0)
        pauseButton.setScale((UIScreen.main.bounds.width / pauseButton.frame.width) * 0.18)
        pauseButton.position = CGPoint(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.width * 0.05)
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: soundOn ? "soundon" : "soundoff"))
        addChild(soundButton)
        soundButton.anchorPoint = CGPoint(x: 1, y: 0)
        soundButton.setScale((UIScreen.main.bounds.width / soundButton.frame.width) * 0.18)
        soundButton.position = CGPoint(x: UIScreen.main.bounds.width * 0.95, y: UIScreen.main.bounds.width * 0.05)
        
        hintButton = SKSpriteNode(texture: SKTexture(imageNamed: hintsActive ? "hintson" : "hintsoff"))
        addChild(hintButton)
        hintButton.anchorPoint.y = 0
        hintButton.setScale((UIScreen.main.bounds.width / hintButton.frame.width) * 0.36)
        hintButton.position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.width * 0.05)
        
        sfxClickDown = Bundle.main.url(forResource: "button-click-down", withExtension: "mp3", subdirectory: "Sounds")
        sfxClickUp = Bundle.main.url(forResource: "button-click-up", withExtension: "mp3", subdirectory: "Sounds")
        sfxDiscPlace = Bundle.main.url(forResource: "disc-place", withExtension: "mp3", subdirectory: "Sounds")
        
        board = SKSpriteNode(texture: SKTexture(imageNamed: "board"))
        addChild(board)
        board.zPosition = -1
        board.setScale(UIScreen.main.bounds.width / (UIScreen.main.bounds.width * 2))
        board.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        blackTitleLabel.fontName = "Timeless"
        blackTitleLabel.position = CGPoint(x: UIScreen.main.bounds.width * 3/4, y: (board.frame.maxY + UIScreen.main.bounds.height) / 2 +  blackTitleLabel.frame.height/2)
        blackTitleLabel.fontSize = UIScreen.main.bounds.width/10
        blackTitleLabel.horizontalAlignmentMode = .center
        blackTitleLabel.numberOfLines = 0
        addChild(blackTitleLabel)
        
        whiteTitleLabel.fontName = "Timeless"
        whiteTitleLabel.position = CGPoint(x: UIScreen.main.bounds.width * 1/4, y: (board.frame.maxY + UIScreen.main.bounds.height) / 2 +  whiteTitleLabel.frame.height/2)
        whiteTitleLabel.fontSize = UIScreen.main.bounds.width/10
        whiteTitleLabel.horizontalAlignmentMode = .center
        whiteTitleLabel.numberOfLines = 0
        addChild(whiteTitleLabel)
        
        blackCountLabel = SKLabelNode(text: "\(blackCount)")
        blackCountLabel.fontName = "Timeless"
        blackCountLabel.position = CGPoint(x: UIScreen.main.bounds.width * 3/4, y: (board.frame.maxY + UIScreen.main.bounds.height) / 2 - blackTitleLabel.frame.height)
        blackCountLabel.fontSize = UIScreen.main.bounds.width/10
        blackCountLabel.horizontalAlignmentMode = .center
        blackCountLabel.numberOfLines = 0
        addChild(blackCountLabel)
        
        whiteCountLabel = SKLabelNode(text: "\(whiteCount)")
        whiteCountLabel.fontName = "Timeless"
        whiteCountLabel.position = CGPoint(x: UIScreen.main.bounds.width * 1/4, y: (board.frame.maxY + UIScreen.main.bounds.height) / 2 - whiteTitleLabel.frame.height)
        whiteCountLabel.fontSize = UIScreen.main.bounds.width/10
        whiteCountLabel.horizontalAlignmentMode = .center
        whiteCountLabel.numberOfLines = 0
        addChild(whiteCountLabel)
        
        playerTurnLabel.fontName = "Timeless"
        playerTurnLabel.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: board.frame.minY / 2)
        playerTurnLabel.fontSize = UIScreen.main.bounds.width/10
        playerTurnLabel.horizontalAlignmentMode = .center
        addChild(playerTurnLabel)
        
        blackDisc = SKSpriteNode(texture: SKTexture(imageNamed: "black0"))
        addChild(blackDisc)
        blackDisc.position = CGPoint(x: -100, y: -100)                  //spawn off-screen. only used for cloning during runtime
        
        whiteDisc = SKSpriteNode(texture: SKTexture(imageNamed: "white0"))
        addChild(whiteDisc)
        whiteDisc.position = CGPoint(x: -100, y: -100)                  //same as above
        
        hintSprite = SKSpriteNode(texture: SKTexture(imageNamed: "black0"))     //init.'d as black0 but can change to white0 depending on currentTurn
        addChild(hintSprite)
        hintSprite.position = CGPoint(x: -100, y: -100)
        
        var btwFrames: [SKTexture] = [blackDisc.texture!]
        var wtbFrames: [SKTexture] = [whiteDisc.texture!]
        for i in 1..<12 {
            btwFrames.append(SKTexture(imageNamed: "black\(i)"))
            wtbFrames.append(SKTexture(imageNamed: "white\(i)"))
        }
        btwFrames.append(whiteDisc.texture!)
        wtbFrames.append(blackDisc.texture!)
        blackToWhiteAnim = SKAction.animate(with: btwFrames, timePerFrame: animTimePerFrame)
        whiteToBlackAnim = SKAction.animate(with: wtbFrames, timePerFrame: animTimePerFrame)
        
        currentTurn = black
        InitGameState()
    }
    
    //sets starting game state
    func InitGameState() {
        gameBoard = [[Character]](repeating: [Character](repeating: " ", count: boardSize), count: boardSize)
        print(singlePlayer ? "1P selected" : "2P selected")
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                gameBoard[i][j] = empty
            }
        }
        
        gameBoard[3][3] = white
        gameBoard[3][4] = black
        gameBoard[4][3] = black
        gameBoard[4][4] = white
        
        DrawDisc(colour: white, r: 3, c: 3)
        DrawDisc(colour: black, r: 3, c: 4)
        DrawDisc(colour: black, r: 4, c: 3)
        DrawDisc(colour: white, r: 4, c: 4)
        
        DrawHints()
    }
    
    //renders <colour> disc at position [r, c] on the game board
    func DrawDisc(colour: Character, r: Int, c: Int) {
        let discCopy = blackDisc.copy() as! SKSpriteNode
        //change texture to whiteDisc if colour is white, otherwise keep it as is
        if colour == white {
            discCopy.texture = whiteDisc.texture
        }
        discCopy.name = "disc\(r)\(c)"
        discCopy.anchorPoint = CGPoint(x: -greenRatio / 2, y: 1 + greenRatio / 2)
        discCopy.setScale(greenRatio * board.xScale)
        discCopy.position = CGPoint(x: board.frame.width * (CGFloat(c) / 8) * greenRatio, y: board.frame.maxY - board.frame.height * (CGFloat(r) / 8) * greenRatio)
        discCopy.position.x += board.frame.minX + CGFloat(c) * 2
        discCopy.position.y -= CGFloat(r) * 2
        addChild(discCopy)
    }
    
    //sets hint opacity based on <hintsActive>
    func ToggleHints() {
        hintsActive = !hintsActive
        
        if (hintsActive) {
            DrawHints()
        }
        else {
            RemoveHints()
        }
    }
    
    //removes all hint sprites from scene
    func RemoveHints() {
        for _ in 0..<FindValidMoves(colour: currentTurn == black ? black : white).count {
            childNode(withName: "hint")?.removeFromParent()
        }
    }
    
    //renders hint sprites at valid move positions for the player(s)
    func DrawHints() {
        var validMoves: [[Int]] = FindValidMoves(colour: currentTurn)
        
        for i in 0..<validMoves.count {
            let r: Int = validMoves[i][0]
            let c: Int = validMoves[i][1]
            
            let hintCopy = hintSprite.copy() as! SKSpriteNode
            hintCopy.texture = SKTexture(imageNamed: currentTurn == black ? "black0" : "white0")
            hintCopy.alpha = 0.4
            hintCopy.name = "hint"
            hintCopy.anchorPoint = CGPoint(x: -greenRatio / 2, y: 1 + greenRatio / 2)
            hintCopy.setScale(greenRatio * board.xScale)
            hintCopy.position = CGPoint(x: board.frame.width * (CGFloat(c) / 8) * greenRatio, y: board.frame.maxY - board.frame.height * (CGFloat(r) / 8) * greenRatio)
            hintCopy.position.x += board.frame.minX + CGFloat(c) * 2
            hintCopy.position.y -= CGFloat(r) * 2
            addChild(hintCopy)
        }
    }
	
	func IsValidMove(colour: Character, r: Int, c: Int) -> Bool {
        var opponent: Character = empty
		if colour == black { opponent = white }
		else if colour == white { opponent = black }
		
		//checks if there is an adjacent opponent disc one direction at a time
		//returns true if at least one direction returns true
		if gameBoard[r][c] == empty
		{
			var distanceToEdge: Int = 0     //how many spaces is the disc away from the edge when checking each direction?
            
			//bottom
            if r + 2 < boardSize, gameBoard[r + 1][c] == opponent {     //if sandwich can be made and opponent is adjacent in the check direction
                distanceToEdge = boardSize - 1 - r                      //calculate # of spaces away from the edge
				for y in 2...distanceToEdge {                           //from disc's current position + 2 to the edge...
					if gameBoard[r + y][c] == colour {                  //if there eventually is another disc of the same colour in this direction, sandwich confirmed
                        return true
					}
                    else if gameBoard[r + y][c] == empty {              //if there eventually is an empty spot, break immediately and move on to the next check(s)
                        break
                    }
				}
			}
                                                                        //repeat check for all 7 other directions
			//top
			if r - 2 > -1, gameBoard[r - 1][c] == opponent {
				distanceToEdge = r
				for y in 2...distanceToEdge {
					if gameBoard[r - y][c] == colour {
                        return true
					}
                    else if gameBoard[r - y][c] == empty {
                        break
                    }
				}
			}
			
			//right
            if c + 2 < boardSize, gameBoard[r][c + 1] == opponent {
				distanceToEdge = boardSize - 1 - c
				for x in 2...distanceToEdge {
					if gameBoard[r][c + x] == colour {
                        return true
					}
                    else if gameBoard[r][c + x] == empty {
                        break
                    }
				}
			}
			
			//left
            if c - 2 > -1, gameBoard[r][c - 1] == opponent {
				distanceToEdge = c
				for x in 2...distanceToEdge {
					if gameBoard[r][c - x] == colour {
                        return true
					}
                    else if gameBoard[r][c - x] == empty {
                        break
                    }
				}
			}
			
			//bottom right
			if r + 2 < boardSize, c + 2 < boardSize, gameBoard[r + 1][c + 1] == opponent {
				distanceToEdge = min(boardSize - 1 - r, boardSize - 1 - c)
				for xy in 2...distanceToEdge {
					if gameBoard[r + xy][c + xy] == colour {
                        return true
					}
                    else if gameBoard[r + xy][c + xy] == empty {
                        break
                    }
				}
			}
			
			//bottom left
			if r + 2 < boardSize, c - 2 > -1, gameBoard[r + 1][c - 1] == opponent {
				distanceToEdge = min(boardSize - 1 - r, c)
				for xy in 2...distanceToEdge {
					if gameBoard[r + xy][c - xy] == colour {
                        return true
					}
                    else if gameBoard[r + xy][c - xy] == empty {
                        break
                    }
				}
			}
			
			//top left
			if r - 2 > -1, c - 2 > -1, gameBoard[r - 1][c - 1] == opponent {
				distanceToEdge = min(r, c)
				for xy in 2...distanceToEdge {
					if gameBoard[r - xy][c - xy] == colour {
                        return true
					}
                    else if gameBoard[r - xy][c - xy] == empty {
                        break
                    }
				}
			}
			
			//top right
			if r - 2 > -1, c + 2 < boardSize, gameBoard[r - 1][c + 1] == opponent{
				distanceToEdge = min(r, boardSize - 1 - c)
				for xy in 1...distanceToEdge {
					if gameBoard[r - xy][c + xy] == colour{
                        return true
					}
                    else if gameBoard[r - xy][c + xy] == empty {
                        break
                    }
				}
			}
            
		}
		
		return false
	}
    
	//places disc on board, immediately calls FlipDiscs()
	func PlaceDisc(colour: Character, r: Int, c: Int) {
		gameBoard[r][c] = colour
		DrawDisc(colour: colour, r: r, c: c)
        PlaySound(url: sfxDiscPlace)
		for i in stride(from: 0, to:Double.pi * 2, by:Double.pi / 4)
		{			
			FlipDiscs(colour: colour, r: r, c: c, yDelta: Int(round(sin(i))), xDelta: Int(round(sin(i + Double.pi / 2))))
		}
	}

	//flips discs according to standard Othello rules
	func FlipDiscs(colour: Character, r: Int, c: Int, yDelta: Int, xDelta: Int) {
		var nextRow: Int = r + yDelta
		var nextCol: Int = c + xDelta
		
        //O_O
        while nextRow < boardSize, nextRow > -1, nextCol < boardSize, nextCol > -1, gameBoard[nextRow][nextCol] != empty
        {
            if gameBoard[nextRow][nextCol] == colour
            {
                while !(r == nextRow && c == nextCol)
                {
                    if gameBoard[nextRow][nextCol] != colour
                    {
                        gameBoard[nextRow][nextCol] = colour
                        AnimateDisc(colour: colour == black ? black : white, r: nextRow, c: nextCol)
                    }
                    nextRow -= yDelta
                    nextCol -= xDelta
                }
                break
            }
            else
            {
                nextRow += yDelta
                nextCol += xDelta
            }
        }
	}
    
    //plays disc-flipping animation
    func AnimateDisc(colour: Character, r: Int, c: Int) {
        childNode(withName: "disc\(r)\(c)")?.removeFromParent()
        
        DrawDisc(colour: colour, r: r, c: c)
        inputEnabled = false
        self.childNode(withName: "disc\(r)\(c)")?.run(colour == self.black ? self.whiteToBlackAnim : self.blackToWhiteAnim)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animDelay, execute: { self.inputEnabled = true })
    }
	
    //returns all possible valid spsots to place a tile as an array of array of 2 ints in the format [row, col]
    func FindValidMoves(colour: Character) -> [[Int]] {
        var validMoves: [[Int]] = [[Int]]()
        
        for i in 0..<boardSize
        {
            for j in 0..<boardSize
            {
                if gameBoard[i][j] == empty
                {
                    if IsValidMove(colour: colour, r: i, c: j)
                    {
                        var coordinate: [Int] = [Int]()
                        coordinate.append(i)
                        coordinate.append(j)
                        validMoves.append(coordinate)
                    }
                }
            }
        }
        
        //print("Possible moves: \(validMoves)")
        return validMoves
    }
    
    //AI - places a tile in a valid spot at random
    //always plays as white
    func RunCPU() {
        var validCpuMoves: [[Int]] = FindValidMoves(colour: white)
        inputEnabled = false
        
        if validCpuMoves.count != 0 {
            let randNum: Int = Int(arc4random_uniform(UInt32(validCpuMoves.count)))
            let randChoice: [Int] = validCpuMoves[randNum]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + cpuDelay, execute: {
                print("CPU has selected to make move at \(randChoice)")
                self.PlaceDisc(colour: self.white, r: randChoice[0], c: randChoice[1])
                DispatchQueue.main.asyncAfter(deadline: .now() + self.animDelay, execute: {
                    self.PassTurn()
                    self.inputEnabled = true
                })
            })
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + cpuDelay, execute: {
                self.PassTurn()
                self.inputEnabled = true
            })
        }
    }
    
    //handles turn passing logic
    //can be optimized
    func PassTurn() {
        if currentTurn == black {
            if FindValidMoves(colour: white).count != 0 {           //if a move can be made...
                numTurnsPassed = 0                                  //reset 'turns passed' counter
                currentTurn = white                                 //pass turn over to other colour
                if singlePlayer {                                   //if 1P, run CPU; otherwise draw hints for white
                    RunCPU()
                }
                else {
                    if (hintsActive) {
                        DrawHints()
                    }
                }
            }
            else {                                                  //if a move can't be made...
                if numTurnsPassed < 2 {                             //if turn hasn't been passed over once already...
                    numTurnsPassed += 1                             //increment 'turns passed' counter, pass turn over to other colour
                    currentTurn = white
                    PassTurn()
                }
                else {                                              //if turn has been passed over once already, game is over because
                    gameOver = true                                 //no valid move can be made with either colour
                }
            }
        }
        else {                                                      //same thing for other colour, except without CPU handling
            if FindValidMoves(colour: black).count != 0 {
                numTurnsPassed = 0
                currentTurn = black
                if (hintsActive) {
                    DrawHints()
                }
            }
            else {
                if numTurnsPassed < 2 {
                    numTurnsPassed += 1
                    currentTurn = black
                    PassTurn()
                }
                else {
                    gameOver = true
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    //checks if the board is full; if it is, then game is over
	func CheckGameOver(){
        if blackCount + whiteCount >= boardSize * boardSize {
            gameOver = true
        }
    }
    
    //returns number of discs of <colour> colour on the game board
    func GetDiscCount(colour: Character) -> Int{
        var discCount: Int = 0
        
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                if gameBoard[i][j] == colour {
                    discCount += 1
                }
            }
        }
        
        return discCount
    }
    
    //tracks disc count internally
    func UpdateDiscCount() {
        blackCount = GetDiscCount(colour: black)
        whiteCount = GetDiscCount(colour: white)
    }
    
    //displays disc count on screen based on internal count
    func UpdateLabels() {
        blackCountLabel.text = "\(blackCount)"
        whiteCountLabel.text = "\(whiteCount)"
        
        if !gameOver {
            playerTurnLabel.text = singlePlayer ? (currentTurn == black ? "Your turn." : "CPU's turn.") : (currentTurn == black ? "Black's turn." : "White's turn.")
        }
        else {
            playerTurnLabel.text = blackCount > whiteCount ? (singlePlayer ? "You win!" : "Black wins!") : (blackCount == whiteCount ? "Tie game!" : (singlePlayer ? "CPU wins." : "White wins!"))
        }
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        UpdateDiscCount()
        UpdateLabels()
        CheckGameOver()
    }
    
    //tries to play <url>
    func PlaySound(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            if soundOn { audioPlayer.play() }
        } catch {
            print("Couldn't play file!")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if inputEnabled {
            for t in touches {
                if pauseButton.frame.contains(t.location(in: self)) {
                    pauseButton.texture = SKTexture(imageNamed: "back-pressed")
                    PlaySound(url: sfxClickDown)
                    touchStartLoc = pauseButton.frame
                }
                
                if (soundButton.frame.contains(t.location(in: self))) {
                    soundButton.texture = SKTexture(imageNamed: soundOn ? "soundon-pressed" : "soundoff-pressed")
                    PlaySound(url: sfxClickDown)
                    touchStartLoc = soundButton.frame
                }
                
                if hintButton.frame.contains(t.location(in: self)) {
                    hintButton.texture = SKTexture(imageNamed: hintsActive ? "hintson-pressed" : "hintsoff-pressed")
                    PlaySound(url: sfxClickDown)
                    touchStartLoc = hintButton.frame
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            clickParticle = SKEmitterNode(fileNamed: "ClickParticle.sks")
            clickParticle.position = t.location(in: self)
            scene?.addChild(clickParticle)
			
            if inputEnabled {
                if !gameOver {
                    if board.frame.contains(t.location(in: self)) {
                        //convert tap location from pixels to array index
                        let row: Int = Int(floor((board.frame.maxY - t.location(in: self).y) / (board.frame.height / 8)))
                        let col: Int = Int(floor((t.location(in: self).x - board.frame.minX) / (board.frame.width / 8)))
                        
                        if IsValidMove(colour: currentTurn, r: row, c: col) {
                            RemoveHints()
                            PlaceDisc(colour: currentTurn, r: row, c: col)
                            DispatchQueue.main.asyncAfter(deadline: .now() + animDelay, execute: {self.PassTurn()})
                        }
                    }
                }
            
                if (pauseButton.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(pauseButton.frame)) {
                    let scene = MainMenuScene(size: self.size)
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    self.view?.presentScene(scene, transition:transition)
                    PlaySound(url: sfxClickUp)
                }
            
                if (soundButton.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(soundButton.frame)) {
                    if (soundOn) {
                        soundButton.texture = SKTexture(imageNamed: "soundoff")
                        soundOn = false
                        //no need to play sound here
                    }
                    else
                    {
                        soundButton.texture = SKTexture(imageNamed: "soundon")
                        soundOn = true
                        PlaySound(url: sfxClickUp)
                    }
                    
                    //save sound state
                    UserDefaults.standard.set(soundOn, forKey: "sound")
                }
            
                if (hintButton.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(hintButton.frame)) {
                    if (hintsActive) {
                        hintButton.texture = SKTexture(imageNamed: "hintsoff")
                        ToggleHints()
                        PlaySound(url: sfxClickUp)
                    }
                    else
                    {
                        hintButton.texture = SKTexture(imageNamed: "hintson")
                        ToggleHints()
                        PlaySound(url: sfxClickUp)
                    }
                }
            
                if (!pauseButton.frame.contains(t.location(in: self)) ||
                    !soundButton.frame.contains(t.location(in: self)) ||
                    !hintButton.frame.contains(t.location(in: self))) {
                    pauseButton.texture = SKTexture(imageNamed: "back")
                    soundButton.texture = SKTexture(imageNamed: soundOn ? "soundon" : "soundoff")
                    hintButton.texture = SKTexture(imageNamed: hintsActive ? "hintson" : "hintsoff")
                    touchStartLoc = CGRect(x: 0, y: 0, width: 0, height: 0)
                    return
                }
            }
        }
    }
}
