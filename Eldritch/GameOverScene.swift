//
//  GameOverScene.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/12/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit

let gameOverLabel = SKLabelNode(fontNamed: "Copperhead");

class GameOverScene: SKScene {
    override func didMoveToView(view: SKView) {
        
        gameOverLabel.name = "gameOverLabel";
        
        if won {
            // WON LABEL
            // GameOverLabel Text Properties
            gameOverLabel.text = "You Won! Click HERE to Play Again!";
            gameOverLabel.fontSize = 25;
            gameOverLabel.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
            // Position
            gameOverLabel.position = CGPoint(x: frame.size.width/1.635, y: frame.size.height/20);
            self.addChild(gameOverLabel);
        } else {
            // LOSE LABEL
            // GameOverLabel Text Properties
            gameOverLabel.text = "You Lost! Click HERE to Retry!";
            gameOverLabel.fontSize = 25;
            gameOverLabel.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
            // Position
            gameOverLabel.position = CGPoint(x: frame.size.width/1.635, y: frame.size.height/20);
            self.addChild(gameOverLabel);
        }
        
        gameOverLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2);
    }
    
    override init(size: CGSize) {
        super.init(size: size);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch;
        let location = touch.locationInNode(self);
        let touchedNode = self.nodeAtPoint(location);
        
        if let name = touchedNode.name {
            print(name);
            switch name {
            case "gameOverLabel":
                // Combat Scene Transition
                let transition = SKTransition.revealWithDirection(.Down, duration: 1.0);
                let gameScene: GameScene = GameScene(size: scene!.size);
                gameScene.scaleMode = .AspectFill;
                self.view?.presentScene(gameScene, transition: transition);
            default:
                break;
            }
        }
    }
        
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
