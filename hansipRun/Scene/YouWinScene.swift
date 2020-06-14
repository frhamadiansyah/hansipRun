//
//  YouWinScene.swift
//  hansipRun
//
//  Created by Fandrian Rhamadiansyah on 15/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import Foundation
import SpriteKit

class YouWinScene: SKScene {
    var youWinLabel : SKLabelNode!
    var continueLabel : SKLabelNode!
    
    override func didMove(to view: SKView) {
        createBackground()
        addYouDeadLabel()
        addContinueLabel()
    }
    
    func addYouDeadLabel() {
        youWinLabel = SKLabelNode(text: "You Win!")
        youWinLabel?.name = "youWinLabel"
        youWinLabel?.fontSize = 50
        youWinLabel?.position = CGPoint(x: 0, y: 0)
        youWinLabel?.zPosition = 1
        self.addChild(youWinLabel!)
    }
    
    func addContinueLabel() {
        continueLabel = SKLabelNode(text: "Next Level!")
        continueLabel?.name = "continueLabel"
        continueLabel?.fontSize = 40
        continueLabel?.position = CGPoint(x: 0, y: -self.frame.height/5)
        continueLabel?.zPosition = 2
        print("retry")
        self.addChild(continueLabel!)
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
        levelObjective.duration += 10.0
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = scaleMode
            view?.presentScene(scene)
        }
    }
}
