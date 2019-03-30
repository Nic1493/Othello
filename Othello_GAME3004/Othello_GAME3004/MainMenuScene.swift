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
    var clickParticle: SKEmitterNode!
    var touchStartLoc: CGRect!
    
    var P1Button: SKSpriteNode!
    var P2Button: SKSpriteNode!
    var howToPlayButton: SKSpriteNode!
    var soundButton: SKSpriteNode!
    
    var soundOn: Bool = UserDefaults.standard.bool(forKey: "sound")
    var audioPlayer = AVAudioPlayer()
    var sfxClickDown: URL!
    var sfxClickUp: URL!
    
    override init(size: CGSize) {
        super.init(size: size)
        touchStartLoc = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        background = SKSpriteNode(imageNamed: "menu-BG")
        background?.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background?.zPosition = -1
        addChild(background)
        
        title = SKSpriteNode(imageNamed: "title")
        addChild(title)
        title?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.8)
        title.setScale((UIScreen.main.bounds.width / title.frame.width) * 0.6)
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: soundOn ? "soundon" : "soundoff"))
        addChild(soundButton)
        soundButton.anchorPoint = CGPoint(x: 1, y: 0)
        soundButton.position = CGPoint(x: UIScreen.main.bounds.width * 0.95, y: UIScreen.main.bounds.width * 0.05)
        soundButton.setScale((UIScreen.main.bounds.width / soundButton.frame.width) * 0.18)
    
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
            if soundOn { audioPlayer.play() }
        } catch {
            print("Couldn't play file!")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
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
                soundButton.texture = SKTexture(imageNamed: soundOn ? "soundon-pressed" : "soundoff-pressed")
                PlaySound(url: sfxClickDown)
                touchStartLoc = soundButton.frame
            }            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            clickParticle = SKEmitterNode(fileNamed: "ClickParticle.sks")
            clickParticle.position = t.location(in: self)
            scene?.addChild(clickParticle)
            
            if (P1Button.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(P1Button.frame)) {
                P1Button.texture = SKTexture(imageNamed: "1P")
                UserDefaults.standard.set(true, forKey: "singlePlayer")
                PlaySound(url: sfxClickUp)
                let scene = GameScene(size: self.size)
                let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
            
            if (P2Button.frame.contains(t.location(in: self)) && touchStartLoc!.equalTo(P2Button.frame)) {
                P2Button.texture = SKTexture(imageNamed: "2P")
                UserDefaults.standard.set(false, forKey: "singlePlayer")
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
            
            if (!P1Button.frame.contains(t.location(in: self)) ||
                !P2Button.frame.contains(t.location(in: self)) ||
                !howToPlayButton.frame.contains(t.location(in: self)) ||
                !soundButton.frame.contains(t.location(in: self))){
                
                P1Button.texture = SKTexture(imageNamed: "1P")
                P2Button.texture = SKTexture(imageNamed: "2P")
                howToPlayButton.texture = SKTexture(imageNamed: "howtoplay")
                soundButton.texture = SKTexture(imageNamed: soundOn ? "soundon" : "soundoff")
                
                touchStartLoc = CGRect(x: 0, y: 0, width: 0, height: 0)
                return
            }
        }
    }
}
