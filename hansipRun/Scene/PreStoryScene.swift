//
//  PreStoryScene.swift
//  hansipRun
//
//  Created by Haddawi on 16/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import Foundation
import SpriteKit

class PreStoryScene: SKScene {
    var tapCount: Int = 1
    
    override func didMove(to view: SKView) {
        changeBackground()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (tapCount > 4) {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = scaleMode
                view?.presentScene(scene)
            }
        } else {
            changeBackground()
        }
    }
    
    func changeBackground() {
        let imageNamed = changeStory(story: tapCount)
        let prestorybg = SKSpriteNode(imageNamed: imageNamed)
        
        prestorybg.name = "prestory"
        prestorybg.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
        prestorybg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        prestorybg.position = CGPoint(x: 0, y: 0)
        prestorybg.zPosition = CGFloat(tapCount)
        
        self.addChild(prestorybg)
        
        tapCount += 1
    }
    
    func changeStory(story: Int) -> String {
        
        switch story {
        case 2:
            return "prestory-2"
        case 3:
            return "prestory-3"
        case 4:
            return "prestory-4"
        default:
            return "prestory-1"
        }
    }
}
