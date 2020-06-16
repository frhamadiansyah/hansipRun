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
    
    var tapToBeginLabel : SKLabelNode?
    
    override func didMove(to view: SKView) {

        addTitleLabel()
        addTapToBeginLabel()
        createBackground()
    }
    
    
    func addTitleLabel() {
        let titleLabel = SKLabelNode(text: "HANSIP-RUN")
        titleLabel.name = "title"
        titleLabel.fontName = "Minecraft"
        titleLabel.fontSize = 50
        titleLabel.position = CGPoint(x: 0, y: self.frame.height/6)
        titleLabel.zPosition = 1
        print("start")
        self.addChild(titleLabel)
    }
    
    func addTapToBeginLabel() {
        tapToBeginLabel = SKLabelNode(text: "Tap Anywhere to begin")
        tapToBeginLabel?.name = "tapToBeginLabel"
        tapToBeginLabel?.fontName = "Minecraft"
        tapToBeginLabel?.fontSize = 40
        tapToBeginLabel?.position = CGPoint(x: 0, y: -self.frame.height/8)
        tapToBeginLabel?.zPosition = 1
//        print("start")
        self.addChild(tapToBeginLabel!)
    }
    
    func createBackground() {
        let sky = SKSpriteNode(imageNamed: "background-sky")
        sky.name = "sky"
        sky.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
        sky.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sky.position = CGPoint(x: 0, y: 0)
        
        self.addChild(sky)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = scaleMode
                view?.presentScene(scene)
            }
            

    }
    
}
