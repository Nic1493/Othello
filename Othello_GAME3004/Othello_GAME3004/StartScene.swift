//
//  StartScene.swift
//  Othello_GAME3004
//
//  Created by Darren Yam on 2019-03-12.
//  Copyright © 2019 Codex. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene: SKScene {
    
    var placeHolderSprite: SKSpriteNode!
    var title: SKSpriteNode!
    var background: SKSpriteNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        title = SKSpriteNode(imageNamed: "title")
        addChild(title)
        title?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.8)
        title.setScale((UIScreen.main.bounds.width / title.frame.width) * 0.6)
        
        background = SKSpriteNode(imageNamed: "menu-BG")
        background?.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background?.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        background?.zPosition = -1;
        addChild(background)
        
        placeHolderSprite = SKSpriteNode(texture: SKTexture(imageNamed: "Placeholder"))
        addChild(placeHolderSprite)
        placeHolderSprite.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        placeHolderSprite.setScale(UIScreen.main.bounds.width/UIScreen.main.bounds.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder: ) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = MainMenuScene(size: self.size)
        let transition = SKTransition.crossFade(withDuration: 0.5)
        self.view?.presentScene(scene, transition:transition)
    }
}
