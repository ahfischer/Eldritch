//
//  GameScene.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/8/16.
//  Copyright (c) 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit
import AVFoundation

// THE DISPLAYED ICONS ARE QUEUED ACTIONS
// Lousiana Voodoo, late 1800s

// Collision Body
struct physicsCategories {
    static let player: UInt32 = 0x1<<0;
    static let spear: UInt32 = 0x1<<1;
    static let horror: UInt32 = 0x1<<2;
    static let border: UInt32 = 0x1<<4;
    
    static let playerName: String = "player";
    static let horrorName: String = "horror";
}

// Bools
var pTurn = false;
var touchingScreen = false;
var moveEnabled = false;
var attackEnabled = true;

var won = false;

// Player and Enemy Nodes
var player: Player!
var horror: Horror!

let spear = SKSpriteNode(imageNamed: "swipe");

// Icons ADD SHADOWS TO THESE LATER FOR DEPTH
let attackIcon = SKSpriteNode(imageNamed: "attackIcon");
let castIcon = SKSpriteNode(imageNamed: "castIcon");
let dodgeIcon = SKSpriteNode(imageNamed: "dodgeIcon");
let moveIcon = SKSpriteNode(imageNamed: "moveIcon");
//let iconArray = [moveIcon, dodgeIcon];

// Health Bar
let healthLabel = SKLabelNode(fontNamed:"Copperplate");

// Combat Music
let backgroundMusic = SKAction.playSoundFileNamed("backgroundMusic", waitForCompletion: false);
let roar = SKAction.playSoundFileNamed("roar.wav", waitForCompletion: false);
let pain = SKAction.playSoundFileNamed("pain.wav", waitForCompletion: false);

// Player Animations
let playerIdleState = SKAction.setTexture(SKTexture(imageNamed: "Main_Idle"));
let playerRunAction: SKAction = SKAction.animateWithTextures([SKTexture(imageNamed: "Main_Move1"), SKTexture(imageNamed: "Main_Move2"), SKTexture(imageNamed: "Main_Move3"), SKTexture(imageNamed: "Main_Move4"), SKTexture(imageNamed: "Main_Move5")], timePerFrame: 0.17);
let playerAttackAction = SKAction.animateWithTextures([SKTexture(imageNamed: "Main_Attack1"), SKTexture(imageNamed: "Main_Attack2"), SKTexture(imageNamed: "Main_Attack3")], timePerFrame: 0.4);

class GameScene: SKScene {
    
    //var backgroundMusic = SKAudioNode!
    var audio = AVAudioPlayer!();
    
    override func didMoveToView(view: SKView) {
        
        let sceneSize = self.frame.size;
        
        let soundFilePath = NSBundle.mainBundle().pathForResource("backgroundMusic.wav", ofType: nil);
        let soundFileURL = NSURL.fileURLWithPath(soundFilePath!);
        
        do {
            audio = try AVAudioPlayer(contentsOfURL: soundFileURL, fileTypeHint: nil);
        } catch {
            print(error);
        }
        
        // Loop Indefinitely
        audio.numberOfLoops = -1;
        audio.play();
        
        player = Player();
        horror = Horror();
        
        backgroundColor = UIColor.blackColor();
        
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
        self.runAction(roar);
        
        // Icon Nodes
        moveIcon.xScale = 0.8;
        moveIcon.yScale = 0.8;
        moveIcon.position = CGPoint(x: sceneSize.width/3, y:sceneSize.height/15);
        moveIcon.zPosition = 2;
        moveIcon.name = "moveIcon";
        self.addChild(moveIcon);
        
        attackIcon.xScale = 0.8;
        attackIcon.yScale = 0.8;
        attackIcon.position = CGPoint(x: moveIcon.position.x+attackIcon.frame.width, y: moveIcon.position.y);
        attackIcon.zPosition = 3;
        attackIcon.name = "attackIcon";
        self.addChild(attackIcon);
        
        dodgeIcon.xScale = 0.8;
        dodgeIcon.yScale = 0.8;
        dodgeIcon.position = CGPoint(x: attackIcon.position.x+dodgeIcon.frame.width, y: attackIcon.position.y);
        dodgeIcon.zPosition = 2;
        dodgeIcon.name = "dodgeIcon";
        self.addChild(dodgeIcon);
        
        // Health Label Text Properties
        healthLabel.text = "Player Health: \(player.health)";
        healthLabel.fontSize = 15;
        healthLabel.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        healthLabel.position = CGPoint(x: frame.size.width/1.635, y: frame.size.height/20);
        self.addChild(healthLabel);
        
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
            case "moveIcon":
                moveEnabled = true;
                moveIcon.alpha = 0.3;
                print("moveEnabled")
            case "attackIcon":
                
                // Change MultiplierForDirection Accordingly
                
                attackEnabled = true;
                
                let spear = SKSpriteNode(imageNamed: "swipe");
                spear.position = CGPoint(x: player.position.x, y: player.position.y-spear.size.width*2);
                //directionalAttack();
                spear.size = spear.texture!.size();
                spear.physicsBody = SKPhysicsBody(rectangleOfSize: spear.size);
                spear.physicsBody?.dynamic = true;
                spear.physicsBody?.categoryBitMask = physicsCategories.spear;
                spear.physicsBody?.contactTestBitMask = physicsCategories.horror;
                self.addChild(spear);
                
                player.runAction(playerAttackAction, withKey: "playerAttacking");
                print("attack");
                
            case "dodgeIcon":
                // Disipate into a Purple Mist and Wisp to New Area
                // have to remove collision
                
                if scene!.view!.paused {
                    scene!.view!.paused = false;
                    audio.play();
                } else {
                    scene!.view!.paused = true;
                    audio.pause();
                }
            default:
                break;
            }
        } else {
            
            // If No Nodes Are Touched, Touching Screen
            touchingScreen = true;
        }
        
        if touchingScreen && moveEnabled {
            
            // Change Direction of Sprite Based on Direction of Movement
            player.xScale = fabs(player.xScale) * multiplierForDirection
            
            // Run Sequential Action for Move and Done
            player.runAction(SKAction.sequence([moveAction, doneAction]), withKey: "moving");
            
            // Disable Move Until Move Button Pressed Again
            moveEnabled = false;
        }
        
        // If Player is Moving
        if (player.actionForKey("moving") != nil) {
            
            // Run Animation
            player.runAction(SKAction.repeatAction(playerRunAction, count: 500), withKey: "playerAnimating");
        } else if (player.actionForKey("playerAttacking") == nil) {
            
            // If Player isn't Moving, Kill Animation
            player.runAction(doneAction);
            horror.removeAllActions();
            //pTurn = false;
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchingScreen = false;
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // if attackingDownward
//        let spearRemoveAction = SKAction.runBlock({ () -> Void in
//            spear.removeFromParent();
//        });
        
        // If Player Isn't Moving, Return to Idle
        if (player.actionForKey("moving") == nil) {
            
            // Only Unclick After Moving
            if moveEnabled == false {
                moveIcon.alpha = 1;
            }
            
            player.runAction(playerIdleState);
            
            // Stop All Enemy Actions When Player Not Moving
            horror.removeAllActions();
        }
        
        // If Player is Moving, Gray Out MoveIcon
        if (player.actionForKey("moving") != nil) {
            moveIcon.alpha = 0.3;
        }
        
        // If Player Isn't Attacking
        if (player.actionForKey("playerAttacking") == nil) {
            //spear.runAction(spearRemoveAction);
            attackIcon.userInteractionEnabled = false;
            attackIcon.alpha = 1;
            spear.removeFromParent();
            //pTurn = false;
        }
        
        // If Player is Attacking
        if (player.actionForKey("playerAttacking") != nil) {
            attackIcon.userInteractionEnabled = true;
            attackIcon.alpha = 0.3;
            //pTurn = true;
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
        
        if horror.health <= 0 {
            //horror.die();
            horror.removeFromParent();
            // WIN
            won = true;
            gameOver();
        }
        
        if player.health <= 0 {
            //player.die();
            player.removeFromParent();
            // GAME OVER
            gameOver();
        }
    }
    
    func gameOver() {
        // GameOver Scene Transition
        audio.stop();
        let transition = SKTransition.revealWithDirection(.Down, duration: 1.0);
        let gameOverScene: GameOverScene = GameOverScene(size: scene!.size);
        gameOverScene.scaleMode = .AspectFill;
        self.view?.presentScene(gameOverScene, transition: transition);
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
            
            player.runAction(SKAction.moveBy(CGVector(dx: horror.size.width/2, dy: horror.size.height/2), duration: 0.2));
            
            // Update Player Health
            player.health -= 10;
            healthLabel.text = "Health: \(player.health)";
            
            if (spear.actionForKey("playerAttacking") != nil) {
                // Interrupt Attack
            }
        }
        
        if (firstBody.categoryBitMask == physicsCategories.spear && secondBody.categoryBitMask == physicsCategories.horror) {
            if (player.actionForKey("playerAttacking") != nil) {
                horror.health -= 100;
                print(horror.health);
                self.runAction(pain);
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

//        func directionalAttack() {
//            if attackEnabled {
//                // This checks that you selected Up Right
//                //if location.x > player.position.x && location.y > player.position.y
//
//                if location.x > player.position.x {
//                    // attack right
//                    spear.position = CGPoint(x: player.position.x+spear.size.width*2, y: player.position.y);
//                }
//
//                if location.x < player.position.x {
//                    // attack left
//                    spear.position = CGPoint(x: player.position.x-spear.size.width*2, y: player.position.y);
//                }
//
//                if location.y > player.position.y {
//                    // attack up
//                    spear.position = CGPoint(x: player.position.x, y: player.position.y);
//                }
//
//                if location.y < player.position.y {
//                    // attack down
//                    spear.position = CGPoint(x: player.position.x, y: player.position.y-spear.size.width*2);
//                }
//            }
//        }