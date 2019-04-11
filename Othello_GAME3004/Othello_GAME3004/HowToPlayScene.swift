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
    
    var titleLabel: SKLabelNode!
    
    var howToPlayLabel: SKLabelNode!
    var instructionsLabel: SKLabelNode!
    var objectiveTitleLabel: SKLabelNode!
    var objectiveLabel: SKLabelNode!
    
    var backButton: SKSpriteNode!
    
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
        //backButton.setScale(UIScreen.main.bounds.width / (UIScreen.main.bounds.width * 3))
        
        backButton.position = CGPoint(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.width * 0.05)
        backButton.setScale((UIScreen.main.bounds.width / backButton.frame.width) * 0.18)
        
        titleLabel = SKLabelNode(fontNamed: "Timeless")
        titleLabel.text = "How To Play"
        titleLabel.position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 8.5/10)
        titleLabel.fontSize = UIScreen.main.bounds.width/8
        addChild(titleLabel)
        
        howToPlayLabel = SKLabelNode(text: "~ How to Play ~")
        howToPlayLabel.fontName = "Timeless"
        howToPlayLabel.horizontalAlignmentMode = .center
        howToPlayLabel.verticalAlignmentMode = .top
        howToPlayLabel.position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height  * 0.8)
        howToPlayLabel.fontSize = UIScreen.main.bounds.width/18
        addChild(howToPlayLabel)
        
        instructionsLabel = SKLabelNode(text: "Each turn, the player places one disc on the board. Each disc played must be laid adjacent to an opponent's disc so that the opponent's disc or a row of opponent's discs is flanked by the new disc and another disc of the player's colour. All of the opponent's discs between these two discs are 'captured' and turned over to match the player's colour.")
        instructionsLabel.fontName = "Timeless"
        instructionsLabel.numberOfLines = 0
        instructionsLabel.horizontalAlignmentMode = .left
        instructionsLabel.verticalAlignmentMode = .top
        instructionsLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width * 0.8
        instructionsLabel.position = CGPoint(x: UIScreen.main.bounds.width  * 0.1, y: UIScreen.main.bounds.height  * 0.75)
        instructionsLabel.fontSize = UIScreen.main.bounds.width/18
        addChild(instructionsLabel)

        
        objectiveTitleLabel = SKLabelNode(text: "~ Objective ~")
        objectiveTitleLabel.fontName = "Timeless"
        objectiveTitleLabel.horizontalAlignmentMode = .center
        objectiveTitleLabel.verticalAlignmentMode = .top
        objectiveTitleLabel.position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height  * 0.25)
        objectiveTitleLabel.fontSize = UIScreen.main.bounds.width/18
        addChild(objectiveTitleLabel)
        
        
        objectiveLabel = SKLabelNode(text: "To have the most discs on the board when the game ends.")
        objectiveLabel.fontName = "Timeless"
        objectiveLabel.numberOfLines = 0
        objectiveLabel.horizontalAlignmentMode = .left
        objectiveLabel.verticalAlignmentMode = .top
        objectiveLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width * 0.8
        objectiveLabel.position = CGPoint(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height  * 0.2)
        objectiveLabel.fontSize = UIScreen.main.bounds.width/18
        addChild(objectiveLabel)
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
