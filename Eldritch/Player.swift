//
//  Player.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/8/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    // Add moves to array to select
    var knownMoves: [String] = ["Stab", "Swing"];
    
    // Player Stats
    var health: Double = 100.0;
    var corruption: Double = 1.0;
    
    var attack: Double = 1.0;
    var specialAttack: Double = 1.0;

    var defense: Double = 1.0;
    var specialDefense: Double = 1.0;
    
    //var stats: [Double] = [];
    
    init() {
        
        // Player Texture
        let texture = SKTexture(imageNamed: "Main_Idle");
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size());

        // Player Node Name
        self.name = "player";
        self.zPosition = 2;
        
        // Player Physics
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size);
        self.physicsBody?.friction = 0.0;
        self.physicsBody?.restitution = 0.0;
        self.physicsBody?.linearDamping = 0.0;
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.dynamic = true;
        self.physicsBody?.categoryBitMask = physicsCategories.player;
        self.physicsBody?.contactTestBitMask = physicsCategories.horror;
        
        // Set Up Stats Array
        //stats = [attack, specialAttack, defense, specialDefense];
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Custom Initializer
    init(health: Double, corruption: Double, attack: Double, specialAttack: Double, defense: Double, specialDefense: Double) {
        
        let texture = SKTexture(imageNamed: "Main_Idle");
        
        self.health = health;
        self.corruption = corruption;
        self.attack = attack;
        self.specialAttack = specialAttack;
        self.defense = defense;
        self.specialDefense = specialDefense;
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size());
    }
    
    // Impliment A Spell Casting System
        // Each Spell Use Corrupts the Player, Adding Debuffs but Unlocking New Spells
    func corrupt() {
        switch self.corruption {
        case 3:
            knownMoves.append("Move");
            // Change Sprites to More Haggard
        case 6:
            knownMoves.append("Move");
        case 9:
            knownMoves.append("Move");
        case 12:
            knownMoves.append("Move");
        case 15:
            knownMoves.append("Move");
        case 18:
            knownMoves.append("Move");
        case 21:
            knownMoves.append("Move");
        case 24:
            knownMoves.append("Move");
        default:
            // statAllocation();
            print("Stats");
        }
    }
    
    // Add Spell Functions Here
    func thrust() {
        //self.physicsBody?.categoryBitMask = physicsCategories.playerThrust;
        // switch on knownMoves
        // case thrust:
        // SKAnimate
    }
}
