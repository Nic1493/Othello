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
    
    override init(size: CGSize) {
        super.init(size: size)
        
        BackButton = SKSpriteNode(texture: SKTexture(imageNamed: "quit"))
        addChild(BackButton)
        BackButton.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 5)
        BackButton.setScale(0.5)
        
        placeHolderSprite = SKSpriteNode(texture: SKTexture(imageNamed: "Flower"))
        addChild(placeHolderSprite)
        placeHolderSprite.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        placeHolderSprite.setScale(1.0)
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
                let transition = SKTransition.moveIn(with: .right, duration: 0.5)
                self.view?.presentScene(scene, transition:transition)
            }
        }
    }
}
