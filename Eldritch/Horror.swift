//
//  Horror.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/8/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

// Horror Attack Sprites
let horrorSwipe = SKSpriteNode(imageNamed: "swipe");
let horrorBite = SKSpriteNode(imageNamed: "horror_bite");
let horrorTailSwipe = SKSpriteNode(imageNamed: "horror_tailSwipe");
let horrorTrample = SKSpriteNode(imageNamed: "trample");

class Horror: SKSpriteNode {
    
    // Add moves to array to select
    var knownMoves: [String] = ["attacks"];
    
    // Horror Stats
    var health: Double = 100.0;
    var corruption: Double = 1.0;
    
    var attack: Double = 1.0;
    var specialAttack: Double = 1.0;
    
    var defense: Double = 1.0;
    var specialDefense: Double = 1.0;
    
    var stats: [Double] = [];
    
    init() {
        
        // Horror Texture
        let texture = SKTexture(imageNamed: "Lizard_Horror");
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size());
        
        self.size = CGSize(width: self.size.width/2, height: self.size.height/2);
        
        // Horror Node Name
        self.name = "horror";
        
        // Horror Physics
        self.zPosition = 1;
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.restitution = 0.0;
        self.physicsBody?.friction = 0.0;
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.dynamic = true;
        self.physicsBody?.categoryBitMask = physicsCategories.horror;
        self.physicsBody?.contactTestBitMask = physicsCategories.player;
        
        // Set Up Stats Array
        stats = [attack, specialAttack, defense, specialDefense];
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Determine Horror Attack
    func horrorAction(action: String) {
        switch action {
        case "Swipe":
            //selfModificationStat(enemies[0]);
            break
        case "Bite":
            //selfModificationPercentage(enemies[0]);
            break
        case "Tail Swipe":
            //proliferationStat(enemies[0]);
            break
        case "Trample":
            //proliferationPercentage(enemies[0]);
            break
        default:
            break;
        }
    }
    
    // Corruption Changes The Way The Horror Fights
    func corrupt() {
        switch self.health {
        case 80:
            knownMoves = ["attack"];
            // Change Sprites to More Haggard
        case 60:
            knownMoves = ["attack"];
        case 40:
            knownMoves = ["attack"];
        case 20:
            knownMoves = ["attack"];
        case 10:
            knownMoves = ["attack"];
        default:
            // statAllocation();
            print("Stats");
        }
    }
    
    // Swipe Attack
    func swipe(scene: HuntScene) {
        
        // add CGPoint for player location and base attack direction on that player location
        
        // if player.position.x > horror.position.x
            // horrorSwipe.position = CGPoint()
        
//        horrorSwipe.position = CGPoint(x: horror.position.x, y: horror.position.y+horror.size.height+horrorSwipe.size.width*2);
//        horrorSwipe.size = horrorSwipe.texture!.size();
//        horrorSwipe.physicsBody = SKPhysicsBody(rectangleOfSize: horrorSwipe.size);
//        horrorSwipe.physicsBody?.dynamic = true;
//        horrorSwipe.physicsBody?.categoryBitMask = physicsCategories.horror;
//        horrorSwipe.physicsBody?.contactTestBitMask = physicsCategories.player;
//        scene.addChild(horrorSwipe);
        
        horror.runAction(horrorSwipeAction, withKey: "horrorAttacking");
        print("horrorAttack");
    }
    
    // Other Attacks Here
    func bite() {
        
    }
    
    func tailSwipe() {
        
    }
    
    func trample() {
        
    }
}