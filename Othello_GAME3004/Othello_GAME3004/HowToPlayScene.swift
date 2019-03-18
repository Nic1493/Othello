//
//  HowToPlayScene.swift
//  Othello_GAME3004
//
//  Created by Darren Yam on 2019-03-12.
//  Copyright © 2019 Codex. All rights reserved.
//

import Foundation
import SpriteKit

class HowToPlayScene: SKScene {
    var BackButton: SKSpriteNode!
    var placeHolderSprite: SKSpriteNode!
    var background: SKSpriteNode!
    var titleLabel: SKLabelNode!
    var instructionsLabel: SKLabelNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        background = SKSpriteNode(imageNamed: "cherry-wood")
        background?.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background?.zPosition = -1;
        addChild(background)
        
        BackButton = SKSpriteNode(texture: SKTexture(imageNamed: "quit"))
        addChild(BackButton)
        BackButton.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 5)
        BackButton.setScale(0.5)
        
        placeHolderSprite = SKSpriteNode(texture: SKTexture(imageNamed: "Flower"))
        //addChild(placeHolderSprite)
        placeHolderSprite.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        placeHolderSprite.setScale(1.0)
        
        //label = SKLabelNode(fontNamed: "Chalkduster")
        titleLabel = SKLabelNode(text: "How To Play")
        titleLabel.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 8.5/10)
        titleLabel.fontSize = 50
        addChild(titleLabel)
        
        instructionsLabel = SKLabelNode(text: "Objective of the Game: \nTo have the most discs on the board\nwhen the game ends. \n\nHow to Play: \nEach player take turns to place down \none disc on the board. The player's \ndisc must be placed beside the \nopposing player's disc to make a line \nwhere the last disc is the player's disc.")
        instructionsLabel.numberOfLines = 0
        instructionsLabel.horizontalAlignmentMode = .center
        instructionsLabel.preferredMaxLayoutWidth = 500
        instructionsLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        instructionsLabel.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 4/10)
        instructionsLabel.fontSize = 25
        addChild(instructionsLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if (BackButton.frame.contains(t.location(in: self))) {
                BackButton.texture = SKTexture(imageNamed: "quit-pressed")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if (BackButton.frame.contains(t.location(in: self))) {
                BackButton.texture = SKTexture(imageNamed: "quit")
                let scene = MainMenuScene(size: self.size)
                let transition = SKTransition.moveIn(with: .down, duration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (!BackButton.frame.contains(t.location(in: self))) {
                BackButton.texture = SKTexture(imageNamed: "quit")
                return;
            }
        }
    }
}
