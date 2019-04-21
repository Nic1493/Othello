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
    var background: SKSpriteNode!
    var clickParticle: SKEmitterNode!
    var touchStartLoc: CGRect!
    
    var backButton: SKSpriteNode!
    
    var titleLabel: SKLabelNode!
    var howtoplayLabel1: SKLabelNode!
    var howtoplayLabel2: SKLabelNode!

    var soundOn: Bool = UserDefaults.standard.bool(forKey: "sound")
    var audioPlayer = AVAudioPlayer()
    let sfxClickDown: URL! = Bundle.main.url(forResource: "button-click-down", withExtension: "mp3", subdirectory: "Sounds")
    let sfxClickUp: URL! = Bundle.main.url(forResource: "button-click-up", withExtension: "mp3", subdirectory: "Sounds")
    
    override init(size: CGSize) {
        super.init(size: size)
        touchStartLoc = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        background = SKSpriteNode(imageNamed: "menu-BG")
        background?.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background?.position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        background?.zPosition = -1;
        addChild(background)
        
        backButton = SKSpriteNode(texture: SKTexture(imageNamed: "back"))
        addChild(backButton)
        backButton.anchorPoint = CGPoint(x: 0, y: 0)
        backButton.position = CGPoint(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.width * 0.05)
        backButton.setScale((UIScreen.main.bounds.width / backButton.frame.width) * 0.18)
        
        titleLabel = SKLabelNode(text: "How to Play")
        titleLabel.fontName = "Timeless"
        titleLabel.fontSize = UIScreen.main.bounds.width * 0.125
        titleLabel.position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.85)
        addChild(titleLabel)
        
        howtoplayLabel1 = SKLabelNode(text: "Each turn, the player places one disc on the board. Each disc played must be placed adjacent to an opponent's disc such that a row of 1 or more of the opponent's discs is flanked by the new disc and an existing disc of the player's colour. All of the opponent's discs between these two discs are turned over to match the player's colour.")
        howtoplayLabel1.fontName = "Timeless"
        howtoplayLabel1.fontSize = UIScreen.main.bounds.width * 0.055
        howtoplayLabel1.numberOfLines = 0
        howtoplayLabel1.horizontalAlignmentMode = .left
        howtoplayLabel1.verticalAlignmentMode = .top
        howtoplayLabel1.preferredMaxLayoutWidth = UIScreen.main.bounds.width * 0.8
        howtoplayLabel1.position = CGPoint(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.8)
        addChild(howtoplayLabel1)
        
        howtoplayLabel2 = SKLabelNode(text: "If the current player cannot make a valid move, the turn is passed to the other player. The game is over when neither player can make a valid move, or when the board is full. The player that has the most discs of their colour on the board when the game ends is the winner.")
        howtoplayLabel2.fontName = "Timeless"
        howtoplayLabel2.fontSize = UIScreen.main.bounds.width * 0.055
        howtoplayLabel2.numberOfLines = 0
        howtoplayLabel2.horizontalAlignmentMode = .left
        howtoplayLabel2.verticalAlignmentMode = .top
        howtoplayLabel2.preferredMaxLayoutWidth = UIScreen.main.bounds.width * 0.8
        howtoplayLabel2.position = CGPoint(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.4)
        addChild(howtoplayLabel2)
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
            if (backButton.frame.contains(t.location(in: self))) {
                backButton.texture = SKTexture(imageNamed: "back-pressed")
                PlaySound(url: sfxClickDown)
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
                PlaySound(url: sfxClickUp)
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
