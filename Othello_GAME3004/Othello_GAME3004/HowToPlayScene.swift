//
//  HowToPlayScene.swift
//  Othello_GAME3004
//
//  Created by Darren Yam on 2019-03-12.
//  Copyright © 2019 Codex. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

class HowToPlayScene: SKScene {
    var backButton: SKSpriteNode!
    var placeHolderSprite: SKSpriteNode!
    var background: SKSpriteNode!
    var titleLabel: SKLabelNode!
    var instructionsLabel: SKLabelNode!
    var clickParticle: SKEmitterNode!
    var touchStartLoc: CGRect!
    
    override init(size: CGSize) {
        super.init(size: size)
        touchStartLoc = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        background = SKSpriteNode(imageNamed: "menu-BG")
        background?.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background?.zPosition = -1;
        addChild(background)
        
        backButton = SKSpriteNode(texture: SKTexture(imageNamed: "back"))
        addChild(backButton)
        backButton.anchorPoint = CGPoint(x: 0, y: 0)
        //backButton.setScale(UIScreen.main.bounds.width / (UIScreen.main.bounds.width * 3))
        
        backButton.position = CGPoint(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.width * 0.05)
        backButton.setScale((UIScreen.main.bounds.width / backButton.frame.width) * 0.18)
        
        //label = SKLabelNode(fontNamed: "Chalkduster")
        titleLabel = SKLabelNode(text: "How To Play")
        titleLabel.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 8.5/10)
        titleLabel.fontSize = UIScreen.main.bounds.width/8
        addChild(titleLabel)
        
        instructionsLabel = SKLabelNode(text: "Objective of the Game: \nTo have the most discs on the board\nwhen the game ends. \n\nHow to Play: \nEach player take turns to place down \none disc on the board. The player's \ndisc must be placed beside the \nopposing player's disc to make a line \nwhere the last disc is the player's disc.")
        instructionsLabel.numberOfLines = 0
        instructionsLabel.horizontalAlignmentMode = .center
        instructionsLabel.preferredMaxLayoutWidth = 500
        instructionsLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        instructionsLabel.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 4/10)
        instructionsLabel.fontSize = UIScreen.main.bounds.width/18
        //addChild(instructionsLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if (backButton.frame.contains(t.location(in: self))) {
                backButton.texture = SKTexture(imageNamed: "back-pressed")
                touchStartLoc = backButton.frame
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            clickParticle = SKEmitterNode(fileNamed: "ClickParticle.sks")
            clickParticle.position = t.location(in: self)
            scene?.addChild(clickParticle)
            
            if (backButton.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(backButton.frame)) {
                backButton.texture = SKTexture(imageNamed: "back")
                let scene = MainMenuScene(size: self.size)
                let transition = SKTransition.moveIn(with: .down, duration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (!backButton.frame.contains(t.location(in: self))) {
                backButton.texture = SKTexture(imageNamed: "back")
                touchStartLoc = CGRect(x: 0, y: 0, width: 0, height: 0)
                return;
            }
        }
    }
}
