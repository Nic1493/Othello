//
//  GameScene.swift
//  Othello_GAME3004
//
//  Created by Darren Yam on 2019-03-12.
//  Copyright © 2019 Codex. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var pauseButton: SKSpriteNode!
    
    var board: SKSpriteNode!
    var blackDisc: SKSpriteNode!
    var whiteDisc: SKSpriteNode!
    
    //define board size, create game board
    let boardSize = 8;
    var gameBoard: [[Character]]!;
    
    //tokens (internal)
    let black: Character = "b";
    let white: Character = "w";
    let empty: Character = "e";
    
    //amount of discs on the board
    var whiteCount = 2;
    var blackCount = 2;
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        //display pause button
        pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: "pause"))
        addChild(pauseButton)
        pauseButton.anchorPoint = CGPoint(x: 0, y: 0)
        pauseButton.setScale(0.4)
        pauseButton.position = CGPoint(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.width * 0.05)
        
        blackDisc = SKSpriteNode(texture: SKTexture(imageNamed: "black0"))
        addChild(blackDisc)
        blackDisc.position = CGPoint(x: -100, y: -100)
        
        whiteDisc = SKSpriteNode(texture: SKTexture(imageNamed: "white0"))
        addChild(whiteDisc)
        whiteDisc.position = CGPoint(x: -100, y: -100)
        
        board = SKSpriteNode(texture: SKTexture(imageNamed: "board"))
        addChild(board)
        board.zPosition = -1
        board.setScale(0.5)
        board.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        //keep loop below for debugging
        /*for i in 0..<boardSize
        {
            for j in 0..<boardSize
            {
                DrawDisc(colour: white, r: i, c: j)
            }
        }*/
        
        InitGameBoard()
    }
    
    //init. game state
    func InitGameBoard(){
        gameBoard = [[Character]](repeating: [Character](repeating: " ", count: boardSize), count: boardSize);
        
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
        
        DrawDisc(colour: white, r: 3, c: 3);
        DrawDisc(colour: black, r: 3, c: 4);
        DrawDisc(colour: black, r: 4, c: 3);
        DrawDisc(colour: white, r: 4, c: 4);
    }
    
    //renders <colour> disc at position [r, c] on the game board
    func DrawDisc(colour: Character, r: Int, c: Int) {

        if colour == black
        {
            let newBlackDisc = blackDisc.copy() as! SKSpriteNode
            addChild(newBlackDisc)
            newBlackDisc.anchorPoint = CGPoint(x: 0, y: 1)
            newBlackDisc.setScale(73.0 / 160.0)
            newBlackDisc.position = CGPoint(x: board.frame.minX + board.frame.width * (CGFloat(c) / 8), y: board.frame.maxY - board.frame.height * (CGFloat(r) / 8))
        }
        if colour == white
        {
            let newWhiteDisc = whiteDisc.copy() as! SKSpriteNode
            addChild(newWhiteDisc)
            newWhiteDisc.anchorPoint = CGPoint(x: 0, y: 1)
            newWhiteDisc.setScale(73.0 / 160.0)
            newWhiteDisc.position = CGPoint(x: board.frame.minX + board.frame.width * (CGFloat(c) / 8), y: board.frame.maxY - board.frame.height * (CGFloat(r) / 8))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if board.frame.contains(t.location(in: self)) {
                print(t.location(in: self))
            }
            if (pauseButton.frame.contains(t.location(in: self))) {
                pauseButton.texture = SKTexture(imageNamed: "pause-pressed")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if (pauseButton.frame.contains(t.location(in: self))) {
                pauseButton.texture = SKTexture(imageNamed: "pause")
                let scene = MainMenuScene(size: self.size)
                let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
        }
    }
}
