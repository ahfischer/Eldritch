//
//  HuntScene.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/8/16.
//  Copyright (c) 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit
import AVFoundation

// This Scene Will Have Redone Custom Sprites and Animations for the Final Submission

// THE DISPLAYED ICONS ARE QUEUED ACTIONS

// Collision Body
struct physicsCategories {
    static let player: UInt32 = 0x1<<0;
    static let spear: UInt32 = 0x1<<1;
    static let horror: UInt32 = 0x1<<2;
    static let border: UInt32 = 0x1<<4;
    
    static let playerName: String = "player";
    static let horrorName: String = "horror";
}

// Horror AI Timing
var timeSinceLast: CFTimeInterval = 0.0;
var lastUpdateTime: CFTimeInterval = 0.0;
var lastAttackTime: CFTimeInterval = 0.0;

// Bools
var touchingScreen = false;
var moveEnabled = false;
var attackEnabled = false;
var dodgeEnabled = false;
var gamePaused = false;

var won = false;

// Player and Enemy Nodes
var player: Player!
var horror: Horror!

// Attack Nodes
let spear = SKSpriteNode(imageNamed: "swipe");

// Icons ADD SHADOWS TO THESE LATER FOR DEPTH
let attackIcon = SKSpriteNode(imageNamed: "attackIcon");
let castIcon = SKSpriteNode(imageNamed: "castIcon");
let dodgeIcon = SKSpriteNode(imageNamed: "dodgeIcon");
let moveIcon = SKSpriteNode(imageNamed: "moveIcon");
let pauseIcon = SKSpriteNode(imageNamed: "pauseIcon");
//let iconArray = [moveIcon, dodgeIcon];

// Attack Direction Icons
let directionUpIcon = SKSpriteNode(imageNamed: "attackUpIcon");
let directionRightIcon = SKSpriteNode(imageNamed: "attackRightIcon");
let directionDownIcon = SKSpriteNode(imageNamed: "attackDownIcon");
let directionLeftIcon = SKSpriteNode(imageNamed: "attackLeftIcon");

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
// Placeholder Dodge Sprite
//let dodgeTexture = SKTexture(imageNamed: "placeholderMist");

class HuntScene: SKScene {
    
    var audio = AVAudioPlayer!();
    
    //MARK: Did Move to View
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
        
        backgroundColor = UIColor.grayColor();
        
        // Player Node
        player.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
        player.zPosition = 2;
        //player.xScale = 1.5;
        //player.yScale = 1.5;
        player.name = "player";
        self.addChild(player);
        
        // Enemy Node
        horror.position = CGPointMake(self.frame.size.width/1.5, self.frame.size.height/2);
        player.zPosition = 2;
        horror.xScale = 2//3;
        horror.yScale = 2//3;
        horror.name = "horror";
        self.addChild(horror);
        self.runAction(roar);
        
        // Icon Nodes
        moveIcon.xScale = 0.8;
        moveIcon.yScale = 0.8;
        moveIcon.position = CGPoint(x: sceneSize.width/3, y:sceneSize.height/15);
        moveIcon.zPosition = 3;
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
        dodgeIcon.zPosition = 3;
        dodgeIcon.name = "dodgeIcon";
        self.addChild(dodgeIcon);
        
        pauseIcon.position = CGPoint(x: dodgeIcon.position.x+pauseIcon.frame.width*1.3, y: attackIcon.position.y);
        pauseIcon.zPosition = 3;
        pauseIcon.name = "pauseIcon";
        self.addChild(pauseIcon);
        
        // Health Label Text Properties
        healthLabel.text = "Player Health: \(player.health)";
        healthLabel.fontSize = 15;
        healthLabel.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        healthLabel.position = CGPoint(x: frame.size.width/1.635, y: frame.size.height/20);
        self.addChild(healthLabel);
        
        // Directional Icons
        directionUpIcon.size = CGSize(width: frame.width/4, height: frame.height/18);
        directionUpIcon.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.02);
        directionUpIcon.zPosition = 1;
        directionUpIcon.alpha = 0.3;
        self.addChild(directionUpIcon);
        directionUpIcon.name = "directionUpIcon";
        
        directionRightIcon.size = CGSize(width: frame.width/18, height: frame.height/3.5);
        directionRightIcon.position = CGPoint(x: self.frame.width/1.465, y: self.frame.size.width/2.5);
        directionRightIcon.zPosition = 1;
        directionRightIcon.alpha = 0.3;
        self.addChild(directionRightIcon);
        directionRightIcon.name = "directionRightIcon";
        
        directionDownIcon.size = CGSize(width: frame.width/4, height: frame.height/18);
        directionDownIcon.position = CGPoint(x: directionUpIcon.position.x, y: dodgeIcon.position.y + self.frame.size.height/14);
        directionDownIcon.zPosition = 1;
        directionDownIcon.alpha = 0.3;
        self.addChild(directionDownIcon);
        directionDownIcon.name = "directionDownIcon";
        
        directionLeftIcon.size = CGSize(width: frame.width/18, height: frame.height/3.5);
        directionLeftIcon.position = CGPoint(x: self.frame.width/3.15, y: self.frame.size.width/2.5);
        directionLeftIcon.zPosition = 1;
        directionLeftIcon.alpha = 0.3;
        self.addChild(directionLeftIcon);
        directionLeftIcon.name = "directionLeftIcon";
        
        
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
    
    //MARK: Touches Began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch;
        let location = touch.locationInNode(self);
        let touchedNode = self.nodeAtPoint(location);
        var multiplierForDirection : CGFloat;
        
        // Give Player a Speed
        let playerSpeed = self.frame.size.width / 8.0; //5.0;
        
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
                if attackEnabled || dodgeEnabled {
                    attackEnabled = false;
                    dodgeEnabled = false;
                }
            case "attackIcon":
                attackEnabled = true;
                //attackIcon.alpha = 0.3;
                if attackEnabled || dodgeEnabled {
                    dodgeEnabled = false;
                }
            case "dodgeIcon":
                // Disipate into a Purple Mist and Wisp to New Area
                // have to remove collision
                
                dodgeEnabled = true;
            case "directionUpIcon":
                
                // If Attack Icon was Tapped
                if attackEnabled {
                    spear.position = CGPoint(x: player.position.x, y: player.position.y+spear.size.width*2);
                    spear.size = spear.texture!.size();
                    spear.physicsBody = SKPhysicsBody(rectangleOfSize: spear.size);
                    spear.physicsBody?.dynamic = true;
                    spear.physicsBody?.categoryBitMask = physicsCategories.spear;
                    spear.physicsBody?.contactTestBitMask = physicsCategories.horror;
                    self.addChild(spear);
                    
                    player.runAction(playerAttackAction, withKey: "playerAttacking");
                    print("attack");
                    
                    attackEnabled = false;
                }
                
                // If Dodge Icon was Tapped
                if dodgeEnabled {
                    // replace duration with animation.duration
                    player.runAction(SKAction.sequence([SKAction.moveByX(0, y: self.frame.size.height/4, duration: 1), SKAction.runBlock({ () -> Void in
                        dodgeEnabled = false;
                        print("donezo")
                    })]), withKey: "playerDodging");
                }
            case "directionRightIcon":
                
                if attackEnabled {
                    spear.position = CGPoint(x: player.position.x+spear.size.width*2, y: player.position.y);
                    spear.size = spear.texture!.size();
                    spear.physicsBody = SKPhysicsBody(rectangleOfSize: spear.size);
                    spear.physicsBody?.dynamic = true;
                    spear.physicsBody?.categoryBitMask = physicsCategories.spear;
                    spear.physicsBody?.contactTestBitMask = physicsCategories.horror;
                    self.addChild(spear);
                    
                    player.runAction(playerAttackAction, withKey: "playerAttacking");
                    print("attack");
                    
                    attackEnabled = false;
                }
                
                if dodgeEnabled {
                    // replace duration with animation.duration
                    player.runAction(SKAction.sequence([SKAction.moveByX(self.frame.size.height/4, y: 0, duration: 1), SKAction.runBlock({ () -> Void in
                        dodgeEnabled = false;
                        print("donezo")
                    })]), withKey: "playerDodging");
                }
            case "directionDownIcon":
                
                if attackEnabled {
                    spear.position = CGPoint(x: player.position.x, y: player.position.y-spear.size.width*2);
                    spear.size = spear.texture!.size();
                    spear.physicsBody = SKPhysicsBody(rectangleOfSize: spear.size);
                    spear.physicsBody?.dynamic = true;
                    spear.physicsBody?.categoryBitMask = physicsCategories.spear;
                    spear.physicsBody?.contactTestBitMask = physicsCategories.horror;
                    self.addChild(spear);
                    
                    player.runAction(playerAttackAction, withKey: "playerAttacking");
                    print("attack");
                    
                    attackEnabled = false;
                }
                
                if dodgeEnabled {
                    // replace duration with animation.duration
                    player.runAction(SKAction.sequence([SKAction.moveByX(0, y: -self.frame.size.height/4, duration: 1), SKAction.runBlock({ () -> Void in
                        dodgeEnabled = false;
                        print("donezo")
                    })]), withKey: "playerDodging");
                }
            case "directionLeftIcon":
                
                if attackEnabled {
                    spear.position = CGPoint(x: player.position.x-spear.size.width*2, y: player.position.y);
                    spear.size = spear.texture!.size();
                    spear.physicsBody = SKPhysicsBody(rectangleOfSize: spear.size);
                    spear.physicsBody?.dynamic = true;
                    spear.physicsBody?.categoryBitMask = physicsCategories.spear;
                    spear.physicsBody?.contactTestBitMask = physicsCategories.horror;
                    self.addChild(spear);
                    
                    player.runAction(playerAttackAction, withKey: "playerAttacking");
                    print("attack");
                    
                    attackEnabled = false;
                }
                
                if dodgeEnabled {
                    // replace duration with animation.duration
                    player.runAction(SKAction.sequence([SKAction.moveByX(-self.frame.size.height/4, y: 0, duration: 1), SKAction.runBlock({ () -> Void in
                        dodgeEnabled = false;
                        print("donezo")
                    })]), withKey: "playerDodging");
                }
            case "pauseIcon":
                
                // If Pause Icon Has Been Pressed
                if gamePaused {
                    
                    // Set UnPaused
                    gamePaused = false
                    scene!.view!.paused = false;
                    
                    // Resume Music
                    audio.play();
                    
                    // Change Icon
                    pauseIcon.texture = SKTexture(imageNamed: "pauseIcon");
                } else {
                    
                    // Else Pause
                    gamePaused = true;
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
        } else if (player.actionForKey("playerAttacking") == nil && player.actionForKey("playerDodging") == nil) {
            
            // If Player isn't Moving, Kill Animation
            player.runAction(doneAction);
            //horror.removeAllActions();
            horror.paused = true;
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchingScreen = false;
    }
    
    //MARK: Update
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        timeSinceLast = currentTime - lastUpdateTime;
        lastUpdateTime = currentTime;
        
        // Set off of 60fps
        if (timeSinceLast > 1) {
            timeSinceLast = 1.0/60.0;
        }
        
        if (player.actionForKey("moving") != nil || player.actionForKey("playerAttacking") != nil || player.actionForKey("playerDodging") != nil) {
            
            self.updateWithTimeSinceLast(timeSinceLast);
        }
        
        // Hide Directional Attacks, Until Attacking
        if attackEnabled || dodgeEnabled {
            directionUpIcon.hidden = false;
            directionRightIcon.hidden = false;
            directionDownIcon.hidden = false;
            directionLeftIcon.hidden = false;
        } else {
            directionUpIcon.hidden = true;
            directionRightIcon.hidden = true;
            directionDownIcon.hidden = true;
            directionLeftIcon.hidden = true;
        }
        
        // Remove Collision When Dodge is Pressed
        if dodgeEnabled {
            player.physicsBody?.contactTestBitMask = 0;
            horror.physicsBody?.contactTestBitMask = 0;
            player.physicsBody?.dynamic = false;
            horror.physicsBody?.dynamic = false;
            dodgeIcon.alpha = 0.3;
        } else {
            player.physicsBody?.contactTestBitMask = physicsCategories.horror;
            horror.physicsBody?.contactTestBitMask = physicsCategories.player;
            player.physicsBody?.dynamic = true;
            horror.physicsBody?.dynamic = true;
            dodgeIcon.alpha = 1;
        }
        
//        if (player.actionForKey("playerDodging") != nil) {
//            player.texture = dodgeTexture;
//        }
        
        // If Player Isn't Moving, Return to Idle
        if (player.actionForKey("moving") == nil && player.actionForKey("playerAttacking") == nil) {
            
            // Only Unclick After Moving
            if moveEnabled == false {
                moveIcon.alpha = 1;
            }
            
            // Set Idle
            player.runAction(playerIdleState);
            
            // Stop All Enemy Actions When Player Not Moving
            if horror.actionForKey("horrorAttacking") == nil && horror.paused == false {
                // Remove Actions if None Are in Progress
                horror.removeAllActions();
            } else {
                // Pause Animation if Attacking
                horror.paused = true;
            }
        }
        
        // If Player is Moving, Gray Out MoveIcon
        if (player.actionForKey("moving") != nil) {
            moveIcon.alpha = 0.3;
        }
        
        // If Player Isn't Attacking
        if (player.actionForKey("playerAttacking") == nil) {
            attackIcon.userInteractionEnabled = false;
            attackIcon.alpha = 1;
            spear.removeFromParent();
        }
        
        // If Player is Attacking
        if (player.actionForKey("playerAttacking") != nil) {
            attackIcon.userInteractionEnabled = true;
            attackIcon.alpha = 0.3;
        }
        
        // Have Horror Follow Player When Active
        if (player.actionForKey("playerAttacking") != nil || player.actionForKey("moving") != nil || player.actionForKey("playerDodging") != nil) {
            // Unpause Horror to Allow Actions in Progress to Continue
            horror.paused = false;
            
            if horror.actionForKey("horrorAttacking") == nil {
                if player.position.x != horror.position.x {
                    horror.runAction(SKAction.moveTo(player.position, duration: 7));
                }
                if player.position.y != horror.position.y {
                    horror.runAction(SKAction.moveTo(player.position, duration: 7));
                }
            }
        }
        
        // If Horror is Attacking
        if (horror.actionForKey("horrorAttacking") != nil) {
            
        }
        
        // If Horror is not Attacking
        if (horror.actionForKey("horrorAttacking") == nil) {
            horrorSwipe.removeFromParent();
        }
        
        // If Game is Paused
        if gamePaused {
            pauseIcon.texture = SKTexture(imageNamed: "playIcon");
            scene!.view!.paused = true;
            audio.pause();
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
    
    func updateWithTimeSinceLast(timeSinceLast: CFTimeInterval) {
        lastAttackTime += timeSinceLast;
        if (lastAttackTime > 5) {
            lastAttackTime = 0;
            horror.removeAllActions();
            horror.swipe(self);
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
    
    override init(size: CGSize) {
        super.init(size: size);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: SKPhysicsContactDelegate
extension HuntScene: SKPhysicsContactDelegate {
    
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
            player.removeAllActions();
            
            // Knock Player Back if Hit
                // divide player.position.x-horror.position.x by a number to lessen bounce distance
            player.runAction(SKAction.moveBy(CGVector(dx: player.position.x - horror.position.x, dy: player.position.y - horror.position.y), duration: 0.2));
            
            // Update Player Health
            player.health -= 50;
            healthLabel.text = "Health: \(player.health)";
            
            // If Player gets Hit While Attacking
            if (player.actionForKey("playerAttacking") != nil) {
                // Interrupt Attack
                player.removeAllActions();
                spear.removeFromParent();
            }
        }
        
        // If Player's Spear Attack Hits Horror
        if (firstBody.categoryBitMask == physicsCategories.spear && secondBody.categoryBitMask == physicsCategories.horror) {
            if (player.actionForKey("playerAttacking") != nil) {
                // Interrupt Horror
                horror.removeAllActions();
                // Play Injure Animation
                horror.health -= 50;
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