//
//  PhysicsCategory.swift
//  hansipRun
//
//  Created by Fandrian Rhamadiansyah on 12/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import Foundation
import SpriteKit

struct PhysicsCategory {
    
    static let boundary : UInt32 = 0b1
    static let hansip: UInt32 = 0b10 // 2
    static let land: UInt32 = 0b100 // 4
    static let poskamling : UInt32 = 0b1000
    static let obstacle: UInt32 = 0b10000
    
}
