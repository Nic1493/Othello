//
//  MenuScene.swift
//  Othello_GAME3004
//
//  Created by Darren Yam on 2019-03-12.
//  Copyright © 2019 Codex. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

class MainMenuScene: SKScene {
    
    var background: SKSpriteNode!
    var title: SKSpriteNode!
    var P1Button: SKSpriteNode!
    var P2Button: SKSpriteNode!
    var howToPlayButton: SKSpriteNode!
    var quitButton: SKSpriteNode!
    var soundButton: SKSpriteNode!
    var isSoundOn: Bool = true
    var clickParticle: SKEmitterNode!
    var touchStartLoc: CGRect!
    
    var audioPlayer = AVAudioPlayer()
    var sfxClickDown: URL!
    var sfxClickUp: URL!
    
    override init(size: CGSize) {
        super.init(size: size)
        touchStartLoc = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        background = SKSpriteNode(imageNamed: "menu-BG")
        background?.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background?.zPosition = -1;
        addChild(background)
        
        title = SKSpriteNode(imageNamed: "title")
        addChild(title)
        title?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.8)
        title.setScale((UIScreen.main.bounds.width / title.frame.width) * 0.6)
        
        quitButton = SKSpriteNode(texture: SKTexture(imageNamed: "quit"))
        addChild(quitButton)
        quitButton.position = CGPoint(x: (UIScreen.main.bounds.width / 2) + (UIScreen.main.bounds.width * 0.15), y: UIScreen.main.bounds.height * 3/10)
        quitButton.setScale((UIScreen.main.bounds.width / quitButton.frame.width) * 0.3)
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: "soundon"))
        addChild(soundButton)
        soundButton.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - (UIScreen.main.bounds.width * 0.15), y: UIScreen.main.bounds.height * 3/10)
        soundButton.setScale((UIScreen.main.bounds.width / soundButton.frame.width) * 0.3)
    
        howToPlayButton = SKSpriteNode(texture: SKTexture(imageNamed: "howtoplay"))
        addChild(howToPlayButton)
        howToPlayButton.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 4/10)
        howToPlayButton.setScale((UIScreen.main.bounds.width / howToPlayButton.frame.width) * 0.6)
        
        P2Button = SKSpriteNode(texture: SKTexture(imageNamed: "2P"))
        addChild(P2Button)
        P2Button.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 5/10)
        P2Button.setScale((UIScreen.main.bounds.width / P2Button.frame.width) * 0.6)
        
        P1Button = SKSpriteNode(texture: SKTexture(imageNamed: "1P"))
        addChild(P1Button)
        P1Button.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 6/10)
        P1Button.setScale((UIScreen.main.bounds.width / P1Button.frame.width) * 0.6)
        
        sfxClickDown = Bundle.main.url(forResource: "button-click-down", withExtension: "mp3", subdirectory: "Sounds")
        sfxClickUp = Bundle.main.url(forResource: "button-click-up", withExtension: "mp3", subdirectory: "Sounds")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    func PlaySound(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            if isSoundOn {
                audioPlayer.play()
            }
        } catch {
            print("Couldn't play file!")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            print(touchStartLoc)
            
            if (P1Button.frame.contains(t.location(in: self))) {
                P1Button.texture = SKTexture(imageNamed: "1P-pressed")
                PlaySound(url: sfxClickDown)
                touchStartLoc = P1Button.frame
            }
            
            if (P2Button.frame.contains(t.location(in: self))) {
                P2Button.texture = SKTexture(imageNamed: "2P-pressed")
                PlaySound(url: sfxClickDown)
                touchStartLoc = P2Button.frame
            }
            
            if (howToPlayButton.frame.contains(t.location(in: self))) {
                howToPlayButton.texture = SKTexture(imageNamed: "howtoplay-pressed")
                PlaySound(url: sfxClickDown)
                touchStartLoc = howToPlayButton.frame
            }
            
            if (soundButton.frame.contains(t.location(in: self))) {
                soundButton.texture = SKTexture(imageNamed: isSoundOn ? "soundon-pressed" : "soundoff-pressed")
                PlaySound(url: sfxClickDown)
                touchStartLoc = soundButton.frame
            }
            
            if (quitButton.frame.contains(t.location(in: self))) {
                quitButton.texture = SKTexture(imageNamed: "quit-pressed")
                PlaySound(url: sfxClickDown)
                touchStartLoc = quitButton.frame
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            clickParticle = SKEmitterNode(fileNamed: "ClickParticle.sks")
            clickParticle.position = t.location(in: self)
            scene?.addChild(clickParticle)
            print(touchStartLoc)
            
            if (P1Button.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(P1Button.frame)) {
                P1Button.texture = SKTexture(imageNamed: "1P")
                PlaySound(url: sfxClickUp)
                let scene = GameScene(size: self.size)
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (P2Button.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(P2Button.frame)) {
                P2Button.texture = SKTexture(imageNamed: "2P")
                PlaySound(url: sfxClickUp)
                let scene = GameScene(size: self.size)
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (howToPlayButton.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(howToPlayButton.frame)) {
                howToPlayButton.texture = SKTexture(imageNamed: "howtoplay")
                PlaySound(url: sfxClickUp)
                let scene = HowToPlayScene(size: self.size)
                let transition = SKTransition.moveIn(with: .up, duration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (soundButton.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(soundButton.frame)) {
                if (isSoundOn) {
                    soundButton.texture = SKTexture(imageNamed: "soundoff")
                    isSoundOn = false;
                    //no need to play sound here
                }
                else
                {
                    soundButton.texture = SKTexture(imageNamed: "soundon")
                    isSoundOn = true
                    PlaySound(url: sfxClickUp)
                }
            }
            
            if (quitButton.frame.contains(t.location(in: self)) &&
                touchStartLoc!.equalTo(quitButton.frame)) {
                exit(0)
            }
            
            if (!P1Button.frame.contains(t.location(in: self)) ||
                !P2Button.frame.contains(t.location(in: self)) ||
                !howToPlayButton.frame.contains(t.location(in: self)) ||
                !soundButton.frame.contains(t.location(in: self)) ||
                !quitButton.frame.contains(t.location(in: self))) {
                
                P1Button.texture = SKTexture(imageNamed: "1P")
                P2Button.texture = SKTexture(imageNamed: "2P")
                howToPlayButton.texture = SKTexture(imageNamed: "howtoplay")
                quitButton.texture = SKTexture(imageNamed: "quit")
                soundButton.texture = SKTexture(imageNamed: isSoundOn ? "soundon" : "soundoff")
                
                touchStartLoc = CGRect(x: 0, y: 0, width: 0, height: 0)
                return;
            }
        }
    }
}
