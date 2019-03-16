//
//  MenuScene.swift
//  Othello_GAME3004
//
//  Created by Darren Yam on 2019-03-12.
//  Copyright © 2019 Codex. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    var P1Button: SKSpriteNode!
    var P2Button: SKSpriteNode!
    var howToPlayButton: SKSpriteNode!
    var soundButton: SKSpriteNode!
    var quitButton: SKSpriteNode!
    var isSoundOn: Bool = true
    
    override init(size: CGSize) {
        super.init(size: size)
        
        P1Button = SKSpriteNode(texture: SKTexture(imageNamed: "1P"))
        addChild(P1Button)
        P1Button.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 3/5)
        P1Button.setScale(0.5)
        
        P2Button = SKSpriteNode(texture: SKTexture(imageNamed: "2P"))
        addChild(P2Button)
        P2Button.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        P2Button.setScale(0.5)
        
        howToPlayButton = SKSpriteNode(texture: SKTexture(imageNamed: "howtoplay"))
        addChild(howToPlayButton)
        howToPlayButton.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 2/5)
        howToPlayButton.setScale(0.5)
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: "soundon"))
        addChild(soundButton)
        soundButton.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - (soundButton.frame.width / 4) , y: UIScreen.main.bounds.height * 3/10)
        soundButton.setScale(0.5)
        
        quitButton = SKSpriteNode(texture: SKTexture(imageNamed: "quit"))
        addChild(quitButton)
        quitButton.position = CGPoint(x: (UIScreen.main.bounds.width / 2) + (quitButton.frame.width / 4), y: UIScreen.main.bounds.height * 3/10)
        quitButton.setScale(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if (P1Button.frame.contains(t.location(in: self))) {
                P1Button.texture = SKTexture(imageNamed: "1P-pressed")
            }
            
            if (P2Button.frame.contains(t.location(in: self))) {
                P2Button.texture = SKTexture(imageNamed: "2P-pressed")
            }
            
            if (howToPlayButton.frame.contains(t.location(in: self))) {
                howToPlayButton.texture = SKTexture(imageNamed: "howtoplay-pressed")
            }
            
            if (soundButton.frame.contains(t.location(in: self))) {
                if (isSoundOn) {
                    soundButton.texture = SKTexture(imageNamed: "soundon-pressed")
                }
                else
                {
                    soundButton.texture = SKTexture(imageNamed: "soundoff-pressed")
                }
            }
            
            if (quitButton.frame.contains(t.location(in: self))) {
                quitButton.texture = SKTexture(imageNamed: "quit-pressed")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if (P1Button.frame.contains(t.location(in: self))) {
                P1Button.texture = SKTexture(imageNamed: "1P")
                let scene = GameScene(size: self.size)
                let transition = SKTransition.moveIn(with: .right, duration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (P2Button.frame.contains(t.location(in: self))) {
                P2Button.texture = SKTexture(imageNamed: "2P")
                let scene = GameScene(size: self.size)
                let transition = SKTransition.moveIn(with: .right, duration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (howToPlayButton.frame.contains(t.location(in: self))) {
                howToPlayButton.texture = SKTexture(imageNamed: "howtoplay")
                let scene = HowToPlayScene(size: self.size)
                let transition = SKTransition.moveIn(with: .left, duration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (soundButton.frame.contains(t.location(in: self))) {
                if (isSoundOn) {
                    soundButton.texture = SKTexture(imageNamed: "soundoff")
                    isSoundOn = false;
                }
                else
                {
                    soundButton.texture = SKTexture(imageNamed: "soundon")
                    isSoundOn = true
                }
            }
            
            if (quitButton.frame.contains(t.location(in: self))) {
                exit(0)
            }
            
            if (!P1Button.frame.contains(t.location(in: self)) ||
                !P2Button.frame.contains(t.location(in: self)) ||
                !howToPlayButton.frame.contains(t.location(in: self)) ||
                !soundButton.frame.contains(t.location(in: self)) ||
                !quitButton.frame.contains(t.location(in: self))) {
                
                P1Button.texture = SKTexture(imageNamed: "1P");
                P2Button.texture = SKTexture(imageNamed: "2P");
                howToPlayButton.texture = SKTexture(imageNamed: "howtoplay");
                quitButton.texture = SKTexture(imageNamed: "quit")
                
                if (isSoundOn) {
                    soundButton.texture = SKTexture(imageNamed: "soundon")
                }
                else
                {
                    soundButton.texture = SKTexture(imageNamed: "soundoff")
                }
                return;
            }
        }
    }
}
