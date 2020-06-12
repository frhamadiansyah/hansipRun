//
//  GameScene.swift
//  hansipRun
//
//  Created by Fandrian Rhamadiansyah on 10/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let hansip: UInt32 = 0b1 // 1
    static let land: UInt32 = 0b10 // 2

}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameState = State.preGame
    var startLabel : SKLabelNode?
    var hansip : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -1792, y: -1792, width: 1792*2, height: 1792*2))

        createBackground()
        createLand()
        createHansip()
    }
    
    //update
    override func update(_ currentTime: TimeInterval) {

//        moveBackground()
    }
    
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
        
        self.addChild(land)
    }
    
    func createHansip() {
        hansip = SKSpriteNode(imageNamed: "Hansip - Stand-1.png")

        hansip!.name = "hansip"
        hansip!.size = CGSize(width: (self.scene?.size.width)! * 0.15, height: (self.scene?.size.width)! * 0.15)
        hansip!.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        hansip!.position = CGPoint(x: frame.midX, y: frame.midY)
        hansip!.zPosition = 2
        
        self.addChild(hansip!)
        
        //add physicsbody
        let hansipBody = SKPhysicsBody(rectangleOf: CGSize(width: hansip!.size.width, height: hansip!.size.height))
        hansipBody.isDynamic = true
        hansipBody.affectedByGravity = true
        hansipBody.categoryBitMask = PhysicsCategory.hansip
        hansip!.physicsBody = hansipBody
//        hansip.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: frame.midX, y: frame.midY, width: (self.scene?.size.width)! * 0.15, height: (self.scene?.size.width)! * 0.15))

        
        // add texture
        var moving : [SKTexture] = []

        for i in 1...4 {
            moving.append(SKTexture(imageNamed: "Hansip - Stand-\(i).png"))
        }
        let movingAnimation = SKAction.animate(with: moving, timePerFrame: 0.1)

        hansip?.run(SKAction.repeatForever(movingAnimation))
    }
    
    func moveBackground() {
        self.enumerateChildNodes(withName: "sky") { (node, error) in
            node.position.x -= 3

            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode {
            if node == hansip {
                hansip!.run(SKAction.applyForce(CGVector(dx: 0.0, dy: 5000.0), duration: 0.1))
                print("jump")
            }
        }
    }


}

