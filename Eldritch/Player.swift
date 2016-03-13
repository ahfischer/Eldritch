//
//  Horror.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/8/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    let movementSpeed: CGFloat = 80.0
    var wayPoints: [CGPoint] = []
    var velocity = CGPoint(x: 0, y: 0)
    
    // Add moves to array to select
    var knownMoves: [String] = ["Stab", "Swing"];
    //var knownMoves = [baseAttack]
    //var knownMoves: [SKAction] = [];
    
    var health: Double = 100.0;
    var corruption: Double = 1.0;
    
    var attack: Double = 1.0;
    var specialAttack: Double = 1.0;

    var defense: Double = 1.0;
    var specialDefense: Double = 1.0;
    
    //var stats: [Double] = [];
    
    init() {
        
        let texture = SKTexture(imageNamed: "Main_Idle");
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size());

        self.name = "player";
        self.zPosition = 2;
        
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
    
    func addMovingPoint(point: CGPoint) {
        wayPoints.append(point)
    }
    
    func move(dt: NSTimeInterval) {
        let currentPosition = position;
        var newPosition = position;
        
        if wayPoints.count > 0 {
            let targetPoint = wayPoints[0];
            let offset = CGPoint(x: targetPoint.x - currentPosition.x, y: targetPoint.y - currentPosition.y);
            let length = Double(sqrtf(Float(offset.x * offset.x) + Float(offset.y * offset.y)));
            let direction = CGPoint(x:CGFloat(offset.x) / CGFloat(length), y: CGFloat(offset.y) / CGFloat(length));
            velocity = CGPoint(x: direction.x * movementSpeed, y: direction.y * movementSpeed);
            
            newPosition = CGPoint(x:currentPosition.x + velocity.x * CGFloat(dt), y:currentPosition.y + velocity.y * CGFloat(dt));
            position = newPosition;
            
            if frame.contains(targetPoint) {
                wayPoints.removeAtIndex(0);
            }
        }
    }
    
    func playerAction(action: String) {
        switch action {
        case "Stab":
            //selfModificationStat(enemies[0]);
            break
        case "Swing":
            //selfModificationPercentage(enemies[0]);
            break
        case "Shoot":
            //proliferationStat(enemies[0]);
            break
        case "Reload":
            //proliferationPercentage(enemies[0]);
            break
        case "Cast":
            //concealmentStat(enemies[0]);
            break
        default:
            break;
        }
    }
    
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
    
    func thrust() {
        //self.physicsBody?.categoryBitMask = physicsCategories.playerThrust;
        // switch on knownMoves
        // case thrust:
        // SKAnimate
    }
}
