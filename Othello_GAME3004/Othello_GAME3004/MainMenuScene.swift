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
    var background: SKSpriteNode!
    var title: SKSpriteNode!
    var clickParticle: SKEmitterNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        print(UIScreen.main.bounds.width)
        print(UIScreen.main.bounds.height)
        
        background = SKSpriteNode(imageNamed: "menu-BG")
        background?.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background?.zPosition = -1;
        addChild(background)
        
        title = SKSpriteNode(imageNamed: "title")
        addChild(title)
        title?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.8)
        title.xScale = (UIScreen.main.bounds.width / title.frame.width) * 0.6
        title.yScale = (UIScreen.main.bounds.height / title.frame.height) * 0.087
        
        quitButton = SKSpriteNode(texture: SKTexture(imageNamed: "quit"))
        addChild(quitButton)
        quitButton.position = CGPoint(x: (UIScreen.main.bounds.width / 2) + (UIScreen.main.bounds.width * 0.15), y: UIScreen.main.bounds.height * 3/10)
        quitButton.xScale = (UIScreen.main.bounds.width / quitButton.frame.width) * 0.3
        quitButton.yScale = (UIScreen.main.bounds.height / quitButton.frame.height) * 0.087
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: "soundon"))
        addChild(soundButton)
        soundButton.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - (UIScreen.main.bounds.width * 0.15), y: UIScreen.main.bounds.height * 3/10)
        soundButton.xScale = (UIScreen.main.bounds.width / soundButton.frame.width) * 0.3
        soundButton.yScale = (UIScreen.main.bounds.height / soundButton.frame.height) * 0.087
    
        howToPlayButton = SKSpriteNode(texture: SKTexture(imageNamed: "howtoplay"))
        addChild(howToPlayButton)
        howToPlayButton.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 4/10)
        howToPlayButton.xScale = (UIScreen.main.bounds.width / howToPlayButton.frame.width) * 0.6
        howToPlayButton.yScale = (UIScreen.main.bounds.height / howToPlayButton.frame.height) * 0.087
        
        P2Button = SKSpriteNode(texture: SKTexture(imageNamed: "2P"))
        addChild(P2Button)
        P2Button.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 5/10)
        P2Button.xScale = (UIScreen.main.bounds.width / P2Button.frame.width) * 0.6
        P2Button.yScale = (UIScreen.main.bounds.height / P2Button.frame.height ) * 0.087
        
        P1Button = SKSpriteNode(texture: SKTexture(imageNamed: "1P"))
        addChild(P1Button)
        P1Button.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 6/10)
        P1Button.xScale = (UIScreen.main.bounds.width / P1Button.frame.width) * 0.6
        P1Button.yScale = (UIScreen.main.bounds.height / P1Button.frame.height ) * 0.087
        
        print(P1Button.frame.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if (P1Button.frame.contains(t.location(in: self))) {
                P1Button.texture = SKTexture(imageNamed: "1P-pressed")
                print(P1Button.frame.width)
                print(P1Button.frame.height)
            }
            
            if (P2Button.frame.contains(t.location(in: self))) {
                P2Button.texture = SKTexture(imageNamed: "2P-pressed")
            }
            
            if (howToPlayButton.frame.contains(t.location(in: self))) {
                howToPlayButton.texture = SKTexture(imageNamed: "howtoplay-pressed")
            }
            
            if (soundButton.frame.contains(t.location(in: self))) {
                soundButton.texture = SKTexture(imageNamed: isSoundOn ? "soundon-pressed" : "soundoff-pressed")
            }
            
            if (quitButton.frame.contains(t.location(in: self))) {
                quitButton.texture = SKTexture(imageNamed: "quit-pressed")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            clickParticle = SKEmitterNode(fileNamed: "ClickParticle.sks")
            clickParticle.position = t.location(in: self)
            scene?.addChild(clickParticle)
            
            if (P1Button.frame.contains(t.location(in: self))) {
                P1Button.texture = SKTexture(imageNamed: "1P")
                let scene = GameScene(size: self.size)
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (P2Button.frame.contains(t.location(in: self))) {
                P2Button.texture = SKTexture(imageNamed: "2P")
                let scene = GameScene(size: self.size)
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (howToPlayButton.frame.contains(t.location(in: self))) {
                howToPlayButton.texture = SKTexture(imageNamed: "howtoplay")
                let scene = HowToPlayScene(size: self.size)
                let transition = SKTransition.moveIn(with: .up, duration: 0.5)
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
