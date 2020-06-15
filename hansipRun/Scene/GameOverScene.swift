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
    var hansip : SKSpriteNode!
    var ground : SKSpriteNode!
    var pocong : SKSpriteNode!
    
    var youDeadLabel : SKLabelNode!
    var tapToRetryLabel : SKLabelNode!
    
    override func didMove(to view: SKView) {
        createBackground()
        addYouDeadLabel()
        addRetryLabel()
        createGround()
        createHansip()
        createPocong()
    }
    
    func addYouDeadLabel() {
        youDeadLabel = SKLabelNode(text: "You are DEAD")
        youDeadLabel?.name = "youDeadLabel"
        youDeadLabel?.fontSize = 50
        youDeadLabel?.position = CGPoint(x: 0, y: self.frame.height/8)
        youDeadLabel?.zPosition = 1
        self.addChild(youDeadLabel!)
    }
    
    func addRetryLabel() {
        tapToRetryLabel = SKLabelNode(text: "Tap anywhere to retry")
        tapToRetryLabel?.name = "tapToRetryLabel"
        tapToRetryLabel?.fontSize = 40
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
    
    func createHansip() {
        hansip = SKSpriteNode(imageNamed: "Hansip - Stand-1.png")
        hansip.name = "hansip"
        hansip.setScale(3)
        hansip.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        hansip.position = CGPoint(x: frame.maxX, y: frame.minY + ground.size.height/2 + hansip.size.height/2)
        hansip.zPosition = 2
        
        self.addChild(hansip)
    }
    
    func createPocong() {
        pocong = SKSpriteNode(imageNamed: "Hansip - Stand-1.png")
        pocong.name = "hansip"
        pocong.setScale(3)
        pocong.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        pocong.position = CGPoint(x: frame.minX, y: frame.minY + ground.size.height/2 + pocong.size.height/2)
        pocong.zPosition = 2
        
        self.addChild(pocong)
    }
    
    func createGround() {
        ground = SKSpriteNode(imageNamed: "foreground-land")
        ground.name = "land"
        ground.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!/2)
        ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ground.position = CGPoint(x: frame.midX, y: frame.minY)
        ground.zPosition = 1
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: ground.size.width, height: ground.size.height))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.affectedByGravity = true
        ground.physicsBody?.categoryBitMask = PhysicsCategory.land
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.hansip
        
        self.addChild(ground)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = scaleMode
            view?.presentScene(scene)
        }
        
    }
    
    func animateScene() {
        let moveAction = SKAction.moveTo(x: frame.midX, duration: TimeInterval(1))
        hansip.run(moveAction)
    }
}
