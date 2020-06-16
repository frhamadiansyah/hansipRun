//
//  GameOverScene.swift
//  hansipRun
//
//  Created by Fandrian Rhamadiansyah on 13/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    // character
    
    var youDeadLabel : SKLabelNode!
    var tapToRetryLabel : SKLabelNode!
    
    override func didMove(to view: SKView) {
        createBackground()
        addYouDeadLabel()
        addRetryLabel()

    }
    
    func addYouDeadLabel() {
        youDeadLabel = SKLabelNode(text: "You are DEAD!!")
        youDeadLabel?.name = "youDeadLabel"
        youDeadLabel?.fontName = "Minecraft"
        youDeadLabel?.fontSize = 50
        youDeadLabel?.position = CGPoint(x: 0, y: self.frame.height/8)
        youDeadLabel?.zPosition = 1
        self.addChild(youDeadLabel!)
    }
    
    func addRetryLabel() {
        tapToRetryLabel = SKLabelNode(text: "Tap anywhere to retry")
        tapToRetryLabel?.name = "tapToRetryLabel"
        tapToRetryLabel?.fontName = "Minecraft"
        tapToRetryLabel?.fontSize = 30
        tapToRetryLabel?.position = CGPoint(x: 0, y: 0)
        tapToRetryLabel?.zPosition = 2
        print("retry")
        self.addChild(tapToRetryLabel!)
    }
    
    func createBackground() {
        let sky = SKSpriteNode(imageNamed: "Sky")
        sky.name = "sky"
        sky.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
        sky.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sky.position = CGPoint(x: 0, y: 0)
        sky.zPosition = 0
        
        self.addChild(sky)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = scaleMode
            view?.presentScene(scene)
        }
        
    }
    
    
}
