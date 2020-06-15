//
//  GameOverScene.swift
//  hansipRun
//
//  Created by Fandrian Rhamadiansyah on 13/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import Foundation
import SpriteKit

class DeadCutScene: SKScene {
    
    // character
    var hansip : SKSpriteNode!
    var ground : SKSpriteNode!
    var pocong : SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        createBackground()

        createGround()
        createHansip()
        createPocong()
        
        animateScene()
    }
    
    
    func createBackground() {
        let sky = SKSpriteNode(imageNamed: "Sky")
        sky.name = "sky"
        sky.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
        sky.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sky.position = CGPoint(x: 0, y: 0)
        sky.zPosition = -1
        
        self.addChild(sky)
        
        let tree = SKSpriteNode(imageNamed: "tree-groups")
        tree.name = "tree"
        tree.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)! / 3)
        tree.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tree.position = CGPoint(x: 0, y: frame.minY + (self.scene?.size.height)!/4 + tree.size.height/2)
        tree.zPosition = 0

        self.addChild(tree)
        
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
        pocong = SKSpriteNode(imageNamed: "Pocong idle-1.png")
        pocong.name = "pocong"
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
    
    
    func animateScene() {
        
        var pocongMoving : [SKTexture] = []
        var hansipMoving : [SKTexture] = []
        
        for i in 1...6 {
            pocongMoving.append(SKTexture(imageNamed: "Pocong Jumping-\(i).png"))
            hansipMoving.append(SKTexture(imageNamed: "Hansip - walk V3-\(i).png"))
        }
        
        let moveHansip = SKAction.moveTo(x: frame.midX + hansip.frame.width, duration: TimeInterval(1.5))
        let animateHansip = SKAction.repeatForever(SKAction.animate(with: hansipMoving, timePerFrame: 1/12))
        let runHansip = SKAction.run {
            self.hansip.run(moveHansip)
            self.hansip.run(animateHansip)
        }
        
//        let pocongMovingAnimation = SKAction.animate(with: pocongMoving, timePerFrame: 1/12)
        let movePocong = SKAction.moveTo(x: frame.midX + hansip.frame.width/2, duration: TimeInterval(2))
        let animatePocong = SKAction.repeatForever(SKAction.animate(with: pocongMoving, timePerFrame: 1/12))
        let runPocong = SKAction.run {
            self.pocong.run(movePocong)
            self.pocong.run(animatePocong)
        }
        
        run(SKAction.group([runPocong, runHansip]))
        
        let gameOverScene = GameOverScene(size: view!.frame.size)
        gameOverScene.scaleMode = scaleMode
        gameOverScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let transition = SKTransition.fade(with: .red, duration: 2)
        let presentAction = SKAction.run {
            self.view?.presentScene(gameOverScene, transition: transition)
        }
        
        let gameOverSequence = SKAction.sequence([SKAction.wait(forDuration: 2.5), presentAction])
        
        run(gameOverSequence)

        
    }
}
