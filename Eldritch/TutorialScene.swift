//
//  TutorialScene.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/12/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

// Tutorial Assets
var tutorialBackground = SKSpriteNode(imageNamed: "tutorialBackground");
var tutorialBackground2 = SKSpriteNode(imageNamed: "tutorialBackground2");
var tutorialNext = SKLabelNode(fontNamed: "Copperhead");

class TutorialScene: SKScene {
    
    //MARK: Did Move to View
    override func didMoveToView(view: SKView) {
        
        backgroundColor = UIColor.grayColor(); 
        
        // Tutorial
        tutorialBackground.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2.2);
        tutorialBackground.zPosition = -1;
        self.addChild(tutorialBackground);
        
        tutorialNext.name = "next";
        
        tutorialNext.text = "Next";
        tutorialNext.fontSize = 25;
        tutorialNext.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        tutorialNext.zPosition = 1;
        tutorialNext.position = CGPoint(x: frame.size.width/2, y: frame.size.height/3);
        self.addChild(tutorialNext);
        
        returnToMenu.name = "return";
        
        returnToMenu.text = "Return to Menu";
        returnToMenu.fontSize = 25;
        returnToMenu.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        returnToMenu.zPosition = 1;
        returnToMenu.position = CGPoint(x: frame.size.width/2, y: frame.size.height/3.5);
        self.addChild(returnToMenu);
    }
    
    //MARK: Touches Began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch;
        let location = touch.locationInNode(self);
        let touchedNode = self.nodeAtPoint(location);
        
        if let name = touchedNode.name {
            print(name);
            switch name {
            case "next":
                tutorialBackground.removeFromParent();
                tutorialBackground2.position = CGPoint(x: frame.size.width/2, y: frame.size.height/1.8);
                tutorialBackground2.xScale = 0.8;
                tutorialBackground2.yScale = 0.8;
                tutorialBackground2.zPosition = 0;
                self.addChild(tutorialBackground2);
                tutorialNext.removeFromParent();
                returnToMenu.position = CGPoint(x: frame.size.width/2, y: frame.size.height/20);
                break;
            case "return":
                // Game Scene Transition
                let transition = SKTransition.revealWithDirection(.Down, duration: 1.0);
                let gameScene: GameScene = GameScene(size: scene!.size);
                gameScene.scaleMode = .AspectFill;
                self.view?.presentScene(gameScene, transition: transition);
            default:
                break;
            }
        }
    }
    
    //MARK: Update
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
