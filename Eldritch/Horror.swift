//
//  Horror.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/8/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

class Horror: SKSpriteNode {
    
    let movementSpeed: CGFloat = 80.0
    var wayPoints: [CGPoint] = []
    var velocity = CGPoint(x: 0, y: 0)
    
    // Add moves to array to select
    var knownMoves: [String] = ["attacks"];
    //var knownMoves = [baseAttack]
    //var knownMoves: [SKAction] = [];
    
    var health: Double = 100.0;
    var corruption: Double = 1.0;
    
    var attack: Double = 1.0;
    var specialAttack: Double = 1.0;
    
    var defense: Double = 1.0;
    var specialDefense: Double = 1.0;
    
    var stats: [Double] = [];
    
    init() {
        
        let texture = SKTexture(imageNamed: "sampleMonster");
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size());
        
        self.name = "horror";
        
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
    
    func addMovingPoint(point: CGPoint) {
        wayPoints.append(point);
    }
    
    func move(dt: NSTimeInterval) {
        let currentPosition = position
        var newPosition = position
        
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

    
    func horrorAction(action: String) {
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
}