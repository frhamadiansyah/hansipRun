//
//  GameScene.swift
//  hansipRun
//
//  Created by Fandrian Rhamadiansyah on 10/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    var hansip : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        self.physicsBody?.categoryBitMask = PhysicsCategory.boundary
        self.physicsBody?.contactTestBitMask = PhysicsCategory.hansip
        
        createBackground()
        createLand()
        createHansip()
        setupSpawnAction()
        setupFinish()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        moveBackground()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        hansip.run(SKAction.applyImpulse(CGVector(dx: 0.0, dy: 500.0), duration: 0.1))
        hansip.removeAction(forKey: "movingAnimation")
        hansip.texture = SKTexture(imageNamed: "Hansip - Jump-1.png")
        
    }
    
    func createHansip() {
        hansip = SKSpriteNode(imageNamed: "Hansip - Stand-1.png")
        
        hansip.name = "hansip"
        hansip.size = CGSize(width: (self.scene?.size.width)! * 0.15, height: (self.scene?.size.width)! * 0.15)
        hansip.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        hansip.position = CGPoint(x: frame.midX, y: frame.midY)
        hansip.zPosition = 2
        
        self.addChild(hansip)
        
        //add physicsbody
        let hansipBody = SKPhysicsBody(rectangleOf: CGSize(width: hansip.size.width, height: hansip.size.height))
        hansipBody.isDynamic = true
        hansipBody.affectedByGravity = true
        hansipBody.allowsRotation = false
        hansipBody.categoryBitMask = PhysicsCategory.hansip
        hansipBody.contactTestBitMask = PhysicsCategory.land | PhysicsCategory.boundary
        hansip.physicsBody = hansipBody
        
        
        // add texture
        hansipRunningAnimation(asset: hansip)
    }
    
    func setupSpawnAction() {
        let spawnBgMeteorAction = SKAction.run {
            self.createObstacle()
        }
        
        let waitAction = SKAction.wait(forDuration: 1)
        
        let sequence = SKAction.sequence([spawnBgMeteorAction, waitAction])
        run(SKAction.repeatForever(sequence), withKey: "spawnObstacle")

    }
    
    
}

//MARK: - Physics Contact

extension GameScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if (bitMask == PhysicsCategory.land | PhysicsCategory.hansip) {
            let hansip = (contact.bodyA.node?.name == "hansip" ? contact.bodyA.node : contact.bodyB.node) as! SKSpriteNode
            
            hansipRunningAnimation(asset: hansip)
            
        } else if (bitMask == PhysicsCategory.boundary | PhysicsCategory.hansip) {
            print("lose")
            if let scene = SKScene(fileNamed: "MainMenuScene") {
                scene.scaleMode = scaleMode
                view?.presentScene(scene)
            }
        } else if (bitMask == PhysicsCategory.poskamling | PhysicsCategory.hansip) {
            print("finish")
            if let scene = SKScene(fileNamed: "MainMenuScene") {
                scene.scaleMode = scaleMode
                view?.presentScene(scene)
            }
        }
        
    }
    
    
}

//MARK: - Obstacle Function

extension GameScene {
    
    func createObstacle() {
            let obstacleArray = ["challenge-log", "challenge-rocks"]
            let randomInt = Int.random(in: 0...1)
            let obstacle = SKSpriteNode(imageNamed: obstacleArray[randomInt])
            obstacle.anchorPoint = CGPoint(x: 0, y: 0)
            obstacle.setScale(0.1 * CGFloat.random(in: 5...20))
            obstacle.position = CGPoint(x: frame.maxX - obstacle.size.width, y: frame.minY + (self.scene?.size.height)!/4)
            obstacle.zPosition = 3
            self.addChild(obstacle)
            
            print("ada")
            
    //        let obstacleBody = SKPhysicsBody(rectangleOf: CGSize(width: obstacle.size.width, height: obstacle.size.height))
            let obstacleBody = SKPhysicsBody(texture: SKTexture(imageNamed: obstacleArray[randomInt]), alphaThreshold: 0, size: obstacle.size)
            obstacleBody.isDynamic = false
            obstacle.physicsBody = obstacleBody

            let moveAction = SKAction.moveTo(x: frame.minX, duration: 2)
            obstacle.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
    
}

//MARK: - Background and Movement

extension GameScene {
    
    func createBackground() {
        for i in 0...3 {
            let sky = SKSpriteNode(imageNamed: "background-sky")
            sky.name = "sky"
            sky.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
            sky.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: 0)
            
            self.addChild(sky)
            
        }
    }
    
    func createLand() {
        let land = SKSpriteNode(imageNamed: "foreground-land")
        land.name = "land"
        land.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!/2)
        land.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        land.position = CGPoint(x: 0, y: frame.minY)
        land.zPosition = 1
        land.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: land.size.width, height: land.size.height))
        land.physicsBody?.isDynamic = false
        land.physicsBody?.affectedByGravity = true
        land.physicsBody?.categoryBitMask = PhysicsCategory.land
        land.physicsBody?.contactTestBitMask = PhysicsCategory.hansip
        
        self.addChild(land)
    }
    
    
    func hansipRunningAnimation(asset : SKSpriteNode) {
        
        var moving : [SKTexture] = []
        
        for i in 1...6 {
            moving.append(SKTexture(imageNamed: "Hansip - walk V3-\(i).png"))
        }
        let movingAnimation = SKAction.animate(with: moving, timePerFrame: 1/12)
        
        asset.run(SKAction.repeatForever(movingAnimation), withKey: "movingAnimation")
    }
    
    func moveBackground() {
        self.enumerateChildNodes(withName: "sky") { (node, error) in
            node.position.x -= 3
            
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
            }
        }
    }
    
}


//MARK: - Finish Category

extension GameScene {
    
    func spawnPoskamling() {
        let poskamling = SKSpriteNode(imageNamed: "poskamling")
        poskamling.anchorPoint = CGPoint(x: 0, y: 0)
        poskamling.setScale(2)
        poskamling.position = CGPoint(x: frame.maxX - poskamling.size.width, y: frame.minY + (self.scene?.size.height)!/4)
        poskamling.zPosition = 4
        self.addChild(poskamling)
        print("muncul")
        
        poskamling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: poskamling.size.width/2, height: poskamling.size.height))
        poskamling.physicsBody?.isDynamic = false
        
        
        poskamling.physicsBody?.categoryBitMask = PhysicsCategory.poskamling
        poskamling.physicsBody?.contactTestBitMask = PhysicsCategory.hansip
        
        let moveAction = SKAction.moveTo(x: frame.minX, duration: 2)
        poskamling.run(SKAction.sequence([moveAction]))
        
    }
    
    func setupFinish() {
        let spawnPoskamling = SKAction.run {
            self.spawnPoskamling()
        }
        
        let levelDuration = SKAction.wait(forDuration: 10)
        let waitAction = SKAction.wait(forDuration: 5)
        let removeAction = SKAction.run {
            self.removeAction(forKey: "spawnObstacle")
        }
        let sequence = SKAction.sequence([levelDuration, removeAction, waitAction, spawnPoskamling])
        run(sequence, withKey: "spawnPoskamling")
    }
    
    
}

