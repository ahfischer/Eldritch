//
//  Icon.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/8/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

class Icon: SKSpriteNode {
    init() {
        
        let texture = SKTexture(imageNamed: "noAttackIcon");
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size());
        
        self.name = "selfModificationStatIcon";
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}