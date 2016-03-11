//
//  GameScene.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/8/16.
//  Copyright (c) 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

// THE DISPLAYED ICONS ARE QUEUED ACTIONS
// Lousiana Voodoo, late 1800s

// Collision Body
struct physicsCategories {
    static let player: UInt32 = 0x1<<0;
    //static let playerThrust: UInt32 = 0x1<<1
    static let horror: UInt32 = 0x1<<1;
    static let border: UInt32 = 0x1<<2;
    
    static let playerName: String = "player";
    static let horrorName: String = "horror";
}

var pTurn = false;
var touchingScreen = false;

// Player and Enemy Nodes
var player: Player!
var horror: Horror!

// Icons ADD SHADOWS TO THESE LATER FOR DEPTH
let attackIcon = SKSpriteNode(imageNamed: "attackIcon");
let castIcon = SKSpriteNode(imageNamed: "castIcon");
let dodgeIcon = SKSpriteNode(imageNamed: "dodgeIcon");
let moveIcon = SKSpriteNode(imageNamed: "moveIcon");
let iconArray = [moveIcon, dodgeIcon];

// Combat Music
let backgroundMusic = SKAction.playSoundFileNamed("backgroundMusic", waitForCompletion: false);

// Player Animations
let playerIdleState = SKAction.setTexture(SKTexture(imageNamed: "Main_Idle"));
let playerRunAction: SKAction = SKAction.animateWithTextures([SKTexture(imageNamed: "Main_Move1"), SKTexture(imageNamed: "Main_Move2"), SKTexture(imageNamed: "Main_Move3"), SKTexture(imageNamed: "Main_Move4"), SKTexture(imageNamed: "Main_Move5")], timePerFrame: 0.17);
let playerAttackAction = SKAction.animateWithTextures([SKTexture(imageNamed: "Main_Attack1"), SKTexture(imageNamed: "Main_Attack2"), SKTexture(imageNamed: "Main_Attack3")], timePerFrame: 0.4);

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        player = Player();
        horror = Horror();
        
        // Player Node
        player.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
        player.xScale = 1.5;
        player.yScale = 1.5;
        player.name = "player";
        self.addChild(player);
        
        // Enemy Node
        horror.position = CGPointMake(self.frame.size.width/1.5, self.frame.size.height/2);
        horror.xScale = 3;
        horror.yScale = 3;
        horror.name = "horror";
        self.addChild(horror);
        
        // Icon Nodes
        moveIcon.xScale = 0.8;
        moveIcon.yScale = 0.8;
        moveIcon.position = CGPoint(x: player.position.x+moveIcon.frame.width, y: player.position.y+moveIcon.frame.height*1.1);
        moveIcon.zPosition = 2;
        self.addChild(moveIcon);
        
        attackIcon.xScale = 0.8;
        attackIcon.yScale = 0.8;
        attackIcon.position = CGPoint(x: moveIcon.position.x+attackIcon.frame.width/4, y: moveIcon.position.y-attackIcon.frame.height*1.1);
        attackIcon.zPosition = 3;
        attackIcon.name = "attackIcon";
        self.addChild(attackIcon);
        
        dodgeIcon.xScale = 0.8;
        dodgeIcon.yScale = 0.8;
        dodgeIcon.position = CGPoint(x: attackIcon.position.x-dodgeIcon.frame.width/4, y: attackIcon.position.y-dodgeIcon.frame.height*1.1);
        dodgeIcon.zPosition = 2;
        self.addChild(dodgeIcon);
        
        // Border
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame);
        self.physicsBody = border;
        self.physicsBody?.categoryBitMask = physicsCategories.border;
        self.physicsBody?.contactTestBitMask = physicsCategories.player;
        
        // SKPhysicsContactDelegate
        self.physicsWorld.contactDelegate = self;
        
        // Turn Off Gravity
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        // SKScene Responds to Touches
        self.userInteractionEnabled = true;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        pTurn = true;
        
        let touch = touches.first! as UITouch;
        let location = touch.locationInNode(self);
        let touchedNode = self.nodeAtPoint(location);
        var multiplierForDirection : CGFloat;
        
        // Give Player a Speed
        let playerSpeed = self.frame.size.width / 5.0;
        
        // X and Y Distances
        let moveDifference = CGPointMake(location.x - player.position.x, location.y - player.position.y);
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y);
        
        // Calculate Move Duration
        let moveDuration = Double(distanceToMove / playerSpeed);
        
        // Facing Direction
        if (moveDifference.x > 0) {
            multiplierForDirection = 1.0;
        } else {
            multiplierForDirection = -1.0;
        }
        
        // Move Player and End Animation
        let moveAction = (SKAction.moveTo(location, duration: moveDuration));
        let doneAction = (SKAction.runBlock({
            //print("Animation Completed")
            player.removeAllActions();
        }));

        if let name = touchedNode.name {
            print(name);
            switch name {
            case "player":
                print("player");
                break;
            case "attackIcon":
                let texture = SKTexture(imageNamed: "Main_Stab");
                let size = CGSize(width: texture.size().width*1.5, height: texture.size().height*1.5)
                player.physicsBody = SKPhysicsBody(texture: texture, size: size);
                player.runAction(SKAction.sequence([playerAttackAction]), withKey: "playerAttacking");
                print("attack");
            default:
                break;
            }
        } else {
            
            // If No Nodes Are Touched, Touching Screen
            touchingScreen = true;
        }
        
        if touchingScreen {
            
            // Change Direction of Sprite Based on Direction of Movement
            player.xScale = fabs(player.xScale) * multiplierForDirection
            
            // Run Sequential Action for Move and Done
            player.runAction(SKAction.sequence([moveAction, doneAction]), withKey: "moving");
        }
        
        // If Player is Moving
        if (player.actionForKey("moving") != nil) {
            
            // Run Animation
            player.runAction(SKAction.repeatAction(playerRunAction, count: 5), withKey: "playerAnimating");
        } else {
            
            // If Player isn't Moving, Kill Animation
            player.runAction(doneAction);
            horror.removeAllActions();
            pTurn = false;
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchingScreen = false;
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // Return Player to Idle State
        if (player.actionForKey("moving") == nil) {
            player.runAction(playerIdleState);
            
            // Stop All Enemy Actions When Player Not Moving
            horror.removeAllActions();
        }
        
        // Have Enemy Follow Player
        if pTurn {
            if player.position.x != horror.position.x {
                horror.runAction(SKAction.moveTo(player.position, duration: 5));
            }
            if player.position.y != horror.position.y {
                horror.runAction(SKAction.moveTo(player.position, duration: 5));
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        // Accounts for Both Contacts, Assigns Lower Value BitMask to First, Reducing Number of Checks by Half
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        // If Player Hits Enemy
        if (firstBody.categoryBitMask == physicsCategories.player && secondBody.categoryBitMask == physicsCategories.horror) {
            
            // Play Hit Animation
            print("contact");
            
            //player.runAction(SKAction.moveBy(CGVector(dx: horror.size.width/2, dy: horror.size.height/2), duration: 0.2));
            
            if (player.actionForKey("playerAttacking") != nil) {
                horror.health -= 1;
                print(horror.health);
            }
            
        }
        
        // If Player Hits Bottom of the Screen,
        if (firstBody.categoryBitMask == physicsCategories.player && secondBody.categoryBitMask == physicsCategories.border) {
            
            // Stop Player
            player.removeAllActions();
        }
    }
}


// in didMoveToView
//        // Icon Nodes
//        moveIcon.xScale = 0.8;
//        moveIcon.yScale = 0.8;
//        moveIcon.position = CGPoint(x: player.position.x+moveIcon.frame.width, y: player.position.y+moveIcon.frame.height*1.1);
//        moveIcon.zPosition = 2;
//        self.addChild(moveIcon);
//
//        attackIcon.xScale = 0.8;
//        attackIcon.yScale = 0.8;
//        attackIcon.position = CGPoint(x: moveIcon.position.x+attackIcon.frame.width/4, y: moveIcon.position.y-attackIcon.frame.height*1.1);
//        attackIcon.zPosition = 2;
//        self.addChild(attackIcon);
//
//        attackIcon.name = "attackIcon";
//
//        dodgeIcon.xScale = 0.8;
//        dodgeIcon.yScale = 0.8;
//        dodgeIcon.position = CGPoint(x: attackIcon.position.x-dodgeIcon.frame.width/4, y: attackIcon.position.y-dodgeIcon.frame.height*1.1);
//        dodgeIcon.zPosition = 2;
//        self.addChild(dodgeIcon);

// Reposition Icons
//            moveIcon.position = CGPoint(x: player.position.x+moveIcon.frame.width, y: player.position.y+moveIcon.frame.height*1.1);
//            attackIcon.position = CGPoint(x: moveIcon.position.x+attackIcon.frame.width/4, y: moveIcon.position.y-attackIcon.frame.height*1.1);
//            dodgeIcon.position = CGPoint(x: attackIcon.position.x-dodgeIcon.frame.width/4, y: attackIcon.position.y-dodgeIcon.frame.height*1.1);

// in touchesMoved
// Use this if I need to have the horror go to near the player position, not on top of
//let horrorSize = CGPoint(x: playerEndLocation.x - horror.size.width, y: playerEndLocation.y - horror.size.height);
//horror.runAction(SKAction.moveTo(horrorSize, duration: 4));