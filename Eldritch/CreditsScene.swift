//
//  CreditsScene.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/12/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

var returnToMenu = SKLabelNode(fontNamed: "Copperhead");
var creditsBackground = SKSpriteNode(imageNamed: "creditsBackground");

class CreditsScene: SKScene {
    
    //MARK: Did Move to View
    override func didMoveToView(view: SKView) {
        
        backgroundColor = UIColor.grayColor();
        
        // Credits
        creditsBackground.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2.2);
        creditsBackground.zPosition = -1;
        self.addChild(creditsBackground);
        
        // Return to Menu Label
        returnToMenu.name = "return";
        
        returnToMenu.text = "Return to Menu";
        returnToMenu.fontSize = 25;
        returnToMenu.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        returnToMenu.zPosition = 1;
        returnToMenu.position = CGPoint(x: frame.size.width/2, y: frame.size.height/3);
        self.addChild(returnToMenu);
    }
    
    //MARK: TouchesBegan
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch;
        let location = touch.locationInNode(self);
        let touchedNode = self.nodeAtPoint(location);
        
        if let name = touchedNode.name {
            print(name);
            switch name {
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
