//
//  GameScene.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/12/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

// Main Menu Label Nodes
var startGame = SKLabelNode(fontNamed: "Copperhead");
var credits = SKLabelNode(fontNamed: "Copperhead");
var tutorial = SKLabelNode(fontNamed: "Copperhead");

class GameScene: SKScene {
    
    //MARK: Did Move to View
    override func didMoveToView(view: SKView) {
        
        backgroundColor = UIColor.grayColor();
        
        // Start Game Label
        startGame.name = "startGame";
        
        startGame.text = "Start Game";
        startGame.fontSize = 25;
        startGame.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        startGame.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2);
        self.addChild(startGame);
        
        // Tutorial Label
        tutorial.name = "Tutorial";
        
        tutorial.text = "Tutorial";
        tutorial.fontSize = 25;
        tutorial.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        tutorial.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2.5);
        self.addChild(tutorial);
        
        // Credits Label
        credits.name = "credits";
        
        credits.text = "Credits";
        credits.fontSize = 25;
        credits.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        credits.position = CGPoint(x: frame.size.width/2, y: frame.size.height/3);
        self.addChild(credits);
    }
    
    //MARK: Touches Began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch;
        let location = touch.locationInNode(self);
        let touchedNode = self.nodeAtPoint(location);
        
        if let name = touchedNode.name {
            print(name);
            switch name {
            case "startGame":
                // Hunt Scene Transition
                let transition = SKTransition.revealWithDirection(.Down, duration: 1.0);
                let gameScene: HuntScene = HuntScene(size: scene!.size);
                gameScene.scaleMode = .AspectFill;
                self.view?.presentScene(gameScene, transition: transition);
            case "Tutorial":
                // Tutorial Scene Transition
                let transition = SKTransition.revealWithDirection(.Down, duration: 1.0);
                let gameScene: TutorialScene = TutorialScene(size: scene!.size);
                gameScene.scaleMode = .AspectFill;
                self.view?.presentScene(gameScene, transition: transition);
            case "credits":
                // Credits Scene Transition
                let transition = SKTransition.revealWithDirection(.Down, duration: 1.0);
                let gameScene: CreditsScene = CreditsScene(size: scene!.size);
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
