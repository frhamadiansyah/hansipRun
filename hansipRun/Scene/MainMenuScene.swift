//
//  MainMenuScene.swift
//  hansipRun
//
//  Created by Fandrian Rhamadiansyah on 11/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    var startLabel : SKLabelNode?
    
    override func didMove(to view: SKView) {
        addStartLabel()
        createBackground()
    }
    
    func addStartLabel() {
        startLabel = SKLabelNode(text: "Start")
        startLabel?.name = "startLabel"
        startLabel?.fontSize = 50
        startLabel?.position = CGPoint(x: 0, y: 0)
        startLabel?.zPosition = 1
        print("start")
        self.addChild(startLabel!)
    }
    
    func createBackground() {
        let sky = SKSpriteNode(imageNamed: "Sky")
        sky.name = "sky"
        sky.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
        sky.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sky.position = CGPoint(x: 0, y: 0)
        
        self.addChild(sky)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let startNode = childNode(withName: "startLabel") as! SKLabelNode
        if startNode.frame.contains(touch.location(in: self)) {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = scaleMode
                view?.presentScene(scene)
            }
            
        }
    }
    
}
