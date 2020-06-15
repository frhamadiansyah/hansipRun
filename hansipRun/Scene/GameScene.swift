//
//  GameScene.swift
//  hansipRun
//
//  Created by Fandrian Rhamadiansyah on 10/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import CoreAudio


class GameScene: SKScene {
    
    // Voice Control Variable
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var levelTimer = Timer()
    var voicePower : Float = 0.0
    
    // character
    var hansip : SKSpriteNode!
    var ground : SKSpriteNode!
    
    // distance progress
    var hansipMini : SKSpriteNode!
    var pocongMini : SKSpriteNode!
    var distanceBar : SKShapeNode!
    var pocongPosition : CGFloat!
    
    
    var levelDuration = levelObjective.duration
    let minSpawnTime = 1.0
    let maxSpawnTime = 2.0
    var inGround = true
    var levelProgress = 0.0
    
    override func didMove(to view: SKView) {
        
        runVoiceControl()
        
        // set boundary
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        self.physicsBody?.categoryBitMask = PhysicsCategory.boundary
        self.physicsBody?.contactTestBitMask = PhysicsCategory.hansip
        
        //set background
        createBackground()
        createGround()
        createHansip()
        createDistanceBar()
        setupSpawnAction(minSpawnTime: minSpawnTime, maxSpawnTime: maxSpawnTime)
        finishCriteria(duration: levelDuration)
        
        // set distanceBar boundary
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
        // jump
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        moveBackground()
//        jumpControl()
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // if hansip is airborne, he is incapable of jumping
//        if inGround == true {
//            if voicePower > -120.0 {
//                inGround = false
//                hansip.run(SKAction.applyImpulse(CGVector(dx: 0.0, dy: 300.0), duration: 0.1))
//                hansip.removeAction(forKey: "movingAnimation")
//                hansip.texture = SKTexture(imageNamed: "Hansip - Jump-1.png")
//            }
//
//        }
        
        
    }
    
    
}


//MARK: - Create Character and Background

extension GameScene {
    
    func createHansip() {
        hansip = SKSpriteNode(imageNamed: "Hansip - Stand-1.png")
        
        hansip.name = "hansip"
        hansip.setScale(3)
        hansip.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        hansip.position = CGPoint(x: frame.midX, y: frame.minY + ground.size.height/2 + hansip.size.height/2)
        hansip.zPosition = 2
        
        self.addChild(hansip)
        
        //add physicsbody
        let hansipBody = SKPhysicsBody(rectangleOf: CGSize(width: hansip.size.width/2, height: hansip.size.height))
        hansipBody.isDynamic = true
        hansipBody.affectedByGravity = true
        hansipBody.allowsRotation = false
        hansipBody.categoryBitMask = PhysicsCategory.hansip
        hansipBody.contactTestBitMask = PhysicsCategory.land | PhysicsCategory.boundary | PhysicsCategory.obstacle
        hansip.physicsBody = hansipBody
        
        
        // add texture
        hansipRunningAnimation(asset: hansip)
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
    
    func createObstacle(speed : Double) {
        let obstacleArray = ["challenge-log", "challenge-rocks"]
        let randomInt = Int.random(in: 0...1)
        let obstacle = SKSpriteNode(imageNamed: obstacleArray[randomInt])
        obstacle.anchorPoint = CGPoint(x: 0, y: 0)
        obstacle.setScale(0.1 * CGFloat.random(in: 5...20))
        obstacle.position = CGPoint(x: frame.maxX - obstacle.size.width, y: frame.minY + (self.scene?.size.height)!/4)
        obstacle.zPosition = 3
        self.addChild(obstacle)
        
//        print("ada")
        
        //        let obstacleBody = SKPhysicsBody(rectangleOf: CGSize(width: obstacle.size.width, height: obstacle.size.height))
        let obstacleBody = SKPhysicsBody(texture: SKTexture(imageNamed: obstacleArray[randomInt]), alphaThreshold: 0, size: obstacle.size)
        obstacleBody.isDynamic = false
        obstacleBody.categoryBitMask = PhysicsCategory.obstacle
        obstacleBody.contactTestBitMask = PhysicsCategory.hansip
        obstacle.physicsBody = obstacleBody
        
        let moveAction = SKAction.moveTo(x: frame.minX, duration: TimeInterval(speed))
        obstacle.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
    }
    
    func createPoskamling() {
        let poskamling = SKSpriteNode(imageNamed: "poskamling")
        poskamling.anchorPoint = CGPoint(x: 0, y: 0)
        poskamling.setScale(2.5)
        poskamling.position = CGPoint(x: frame.maxX - poskamling.size.width, y: frame.minY + (self.scene?.size.height)!/4)
        poskamling.zPosition = 4
        self.addChild(poskamling)
        print("muncul")
        
        poskamling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: poskamling.size.width/2, height: poskamling.size.height))
        poskamling.physicsBody?.isDynamic = false
        
        poskamling.physicsBody?.categoryBitMask = PhysicsCategory.poskamling
        poskamling.physicsBody?.contactTestBitMask = PhysicsCategory.hansip
        
        let moveAction = SKAction.moveTo(x: frame.minX, duration: 3)
        poskamling.run(SKAction.sequence([moveAction]))
        
    }
    
    func createDistanceBar() {
        distanceBar = SKShapeNode(rect: CGRect(x: -frame.width/4, y: frame.height/3, width: frame.width/2, height: 20))
        distanceBar.zPosition = 3
        distanceBar.fillColor = .red
        
        
        hansipMini = SKSpriteNode(imageNamed: "Hansip - walk V3-2.png")
        hansipMini.setScale(1.5)
        hansipMini.position = CGPoint(x: distanceBar.frame.minX + distanceBar.frame.width/3, y: distanceBar.frame.midY)
        hansipMini.zPosition = 5
        
        distanceBar.addChild(hansipMini)
        
        pocongMini = SKSpriteNode(imageNamed: "Pocong idle-1.png")
        pocongMini.setScale(1.5)
        pocongMini.position = CGPoint(x: hansipMini.position.x - (self.frame.width*0.5/4), y: distanceBar.frame.midY)
        pocongMini.zPosition = 6
        distanceBar.addChild(pocongMini)
        
        let poskamlingMini = SKSpriteNode(imageNamed: "poskamling")
        poskamlingMini.setScale(1)
        poskamlingMini.position = CGPoint(x: distanceBar.frame.maxX, y: distanceBar.frame.midY)
        poskamlingMini.zPosition = 4
        distanceBar.addChild(poskamlingMini)
        
        self.addChild(distanceBar)
    }
    
}

//MARK: - Animation and Movement (Aesthetic)

extension GameScene {
    
    func hansipRunningAnimation(asset : SKSpriteNode) {
        
        var moving : [SKTexture] = []
        
        for i in 1...6 {
            moving.append(SKTexture(imageNamed: "Hansip - walk V3-\(i).png"))
        }
        let movingAnimation = SKAction.animate(with: moving, timePerFrame: 1/12)
        
        asset.run(SKAction.repeatForever(movingAnimation), withKey: "movingAnimation")
    }
    
    func moveBackground() {
        self.enumerateChildNodes(withName: "background-sky") { (node, error) in
            node.position.x -= 3
            
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
            }
        }
    }
}


//MARK: - Game Mechanics

extension GameScene {
    
    func jumpControl() {
           if inGround == true {
               if voicePower > -15.0 {
                   inGround = false
                   let temp = pow((15.0 + Double(voicePower)), 2)
                   let jumpPower = 300 + temp
                  
                   print("voicePower \(temp)")
                   print("voicePower \(voicePower)")
    
//                   let jumpHeight = 10.0 * pow(voicePower, 2)
                   let jumpImpulse =   SKAction.applyImpulse(CGVector(dx: 0.0, dy: Double(jumpPower)), duration: 0.1)
                   let jumpSound = SKAction.playSoundFileNamed("jump-effect.wav", waitForCompletion: false)
                  
                   hansip.run(SKAction.group([jumpImpulse, jumpSound]))
                   hansip.removeAction(forKey: "movingAnimation")
                   hansip.texture = SKTexture(imageNamed: "Hansip - Jump-1.png")
                  
               }
           }
       }
    
    func setupSpawnAction(minSpawnTime: Double, maxSpawnTime : Double) {
        let spawnBgMeteorAction = SKAction.run {
            self.createObstacle(speed: Double.random(in: minSpawnTime...maxSpawnTime))
        }
        
        let waitAction = SKAction.wait(forDuration: 1)
        
        let sequence = SKAction.sequence([waitAction, spawnBgMeteorAction])
        run(SKAction.repeatForever(sequence), withKey: "spawnObstacle")
        
    }
    
    
    func finishCriteria(duration : Double) {
        let spawnPoskamling = SKAction.run {
            self.createPoskamling()
        }
        
        let levelDuration = SKAction.wait(forDuration: TimeInterval(duration))
        let waitAction = SKAction.wait(forDuration: 5)
        let removeAction = SKAction.run {
            self.removeAction(forKey: "spawnObstacle")
        }
        let sequence = SKAction.sequence([levelDuration, removeAction, waitAction, spawnPoskamling])
        run(sequence, withKey: "spawnPoskamling")
    }
    
    func playerLose() {
        if let scene = SKScene(fileNamed: "GameOverScene") {
            scene.scaleMode = scaleMode
            view?.presentScene(scene)
        }
    }
    
    func playerWin() {
        if let scene = SKScene(fileNamed: "YouWinScene") {
            scene.scaleMode = scaleMode
            view?.presentScene(scene)
        }
    }
    
    @objc func updateProgress() {
        //example functionality
        if levelProgress < levelDuration * 4 {
//            print(levelProgress)
            pocongMini.position.x = hansipMini.position.x - (hansip.position.x - frame.minX)/4
            //        let progress = CGFloat(levelProgress/(levelDuration * 4))*distanceBar.frame.width*2/3
            hansipMini.position.x = distanceBar.frame.minX + distanceBar.frame.width/3 + CGFloat(levelProgress/(levelDuration * 4))*distanceBar.frame.width*2/3
            levelProgress += 1
        }
    }
    
}


//MARK: - Physics Contact

extension GameScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if (bitMask == PhysicsCategory.land | PhysicsCategory.hansip) {
            // set hansip running motion
            let hansip = (contact.bodyA.node?.name == "hansip" ? contact.bodyA.node : contact.bodyB.node) as! SKSpriteNode
            print("... touching grounds")
            inGround = true
            hansipRunningAnimation(asset: hansip)
//            }
            
            
        } else if (bitMask == PhysicsCategory.obstacle | PhysicsCategory.hansip) {
            // hansip is capable of jumping from on top of obstacle
            let hansip = (contact.bodyA.node?.name == "hansip" ? contact.bodyA.node : contact.bodyB.node) as! SKSpriteNode
//            print("touch obstacle")
            inGround = true
            hansipRunningAnimation(asset: hansip)
            
        } else if (bitMask == PhysicsCategory.boundary | PhysicsCategory.hansip) {
            print("lose")
            if inGround {
                print("lose")
                playerLose()
            }
            
        } else if (bitMask == PhysicsCategory.poskamling | PhysicsCategory.hansip) {
            print("finish")
            playerWin()
            
        }
        
    }
    
}

//MARK: - Voice Control

extension GameScene : AVAudioRecorderDelegate {
    
    func runVoiceControl() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startRecording()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            
            //            recordButton.setTitle("Tap to Stop", for: .normal)
            
            levelTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.levelTimerCallback), userInfo: nil, repeats: true)
            
        } catch {
            //                finishRecording(success: false)
            print("gagal")
        }
    }
    
    @objc func levelTimerCallback() {

        audioRecorder.updateMeters()
        voicePower = audioRecorder.averagePower(forChannel: 0)
        jumpControl()

    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
