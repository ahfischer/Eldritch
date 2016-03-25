//
//  GameScene.swift
//  Eldritch
//
//  Created by Anthony Fischer on 3/12/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import SpriteKit
import GameKit

// Main Menu Label Nodes
var startGame = SKLabelNode(fontNamed: "Copperhead");
var credits = SKLabelNode(fontNamed: "Copperhead");
var tutorial = SKLabelNode(fontNamed: "Copperhead");
var achievements = SKLabelNode(fontNamed: "Copperhead");
var leaderboards = SKLabelNode(fontNamed: "Copperhead");
var postHighScore = SKLabelNode(fontNamed: "Copperhead");

var gameCenterAchievements = [String: GKAchievement]();

class GameScene: SKScene {
    
    //MARK: Did Move to View
    override func didMoveToView(view: SKView) {
        
        previousHighScore = defaults.integerForKey("PreviousHighScore");
        
        authenticateLocalPlayer();
        
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
        
        // Achievements Label
        achievements.name = "Achievements";
        
        achievements.text = "Achievements";
        achievements.fontSize = 25;
        achievements.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        achievements.position = CGPoint(x: frame.size.width/2, y: frame.size.height/3.5);
        self.addChild(achievements);
        
        // Leaderboards Label
        leaderboards.name = "Leaderboards";
        
        leaderboards.text = "Leaderboards";
        leaderboards.fontSize = 25;
        leaderboards.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        leaderboards.position = CGPoint(x: frame.size.width/2, y: frame.size.height/4.25);
        self.addChild(leaderboards);
        
        // Post Score Label
        postHighScore.name = "PostHighScore";
        
        postHighScore.text = "Post High Score";
        postHighScore.fontSize = 25;
        postHighScore.fontColor = UIColor(red: 14/255, green: 107/255, blue: 30/255, alpha: 1)
        // Position
        postHighScore.position = CGPoint(x: frame.size.width/2, y: frame.size.height/5.5);
        self.addChild(postHighScore);
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
            case "Achievements":
                incrementCurrentPercentOfAchievement("Footloose", amount: 10);
            case "Leaderboards":
                
                // Update Leaderboard if Score is Higher Than Last
                if (currentScore > previousHighScore) {
                    self.saveHighScore("EldritchLeaderboard", score: currentScore);
                    
                    // Set Previous Score
                    previousHighScore = currentScore;
                    
                    defaults.setInteger(currentScore, forKey: "PreviousHighScore");
                }
                // Then Open Game Center
                showGameCenter();
            case "PostHighScore":
                break;
            default:
                break;
            }
        }
    }
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer();
        
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            if (viewController != nil) {
                let vc:UIViewController = self.view!.window!.rootViewController!
                vc.presentViewController(viewController!, animated: true, completion: nil);
            } else {
                print("Authentication is \(GKLocalPlayer.localPlayer().authenticated)");
                
                // Reset Achievements and Load Percentages
                gameCenterAchievements.removeAll();
                self.loadAchievementPercentages();
            }
        }
    }
    
    func loadAchievementPercentages() {
        print("Getting percentage of past achievements");
        GKAchievement.loadAchievementsWithCompletionHandler( { (allAchievements, error) -> Void in
            if error != nil {
                print("Game Center could not load achievements, the error is \(error)");
            } else {
                if (allAchievements != nil) {
                    
                    for achievement in allAchievements! {
                        
                        if let singleAchievement: GKAchievement = achievement {
                            
                            gameCenterAchievements[singleAchievement.identifier!] = singleAchievement;
                        }
                    }
                    
                    for (id, achievement) in gameCenterAchievements {
                        print("\(id) - \(achievement.percentComplete)");
                    }
                }
            }
        
        })
    }
    
    func saveHighScore(identifier: String, score: Int) {
        
        // Only Submit High Scores if Signed in to Game Center
        if (GKLocalPlayer.localPlayer().authenticated) {
            let scoreReporter = GKScore(leaderboardIdentifier: identifier);
            scoreReporter.value = Int64(score);
            let scoreArray: [GKScore] = [scoreReporter];
            GKScore.reportScores(scoreArray, withCompletionHandler: { (error) -> Void in
                if error != nil {
                    print(error);
                } else {
                    print("Posted score of \(score)");
                    // from here you can do anything else to tell the user they posted a high score
                }
            })
        }
    }
    
    func incrementCurrentPercentOfAchievement(identifier: String, amount: Double) {
        if GKLocalPlayer.localPlayer().authenticated {
            var currentPercentFound = false;
            
            if (gameCenterAchievements.count != 0) {
                for (id, achievement) in gameCenterAchievements {
                    if (id == identifier) {
                        currentPercentFound = true;
                        var currentPercent = achievement.percentComplete;
                        currentPercent = currentPercent+amount;
                        reportAchievement(identifier, percentComplete: currentPercent)
                        break;
                    }
                }
            }
            
            if (currentPercentFound == false) {
                reportAchievement(identifier, percentComplete: amount);
            }
        }
    }
    
    func reportAchievement(identifier: String, percentComplete: Double) {
        let achievement = GKAchievement(identifier: identifier);
        achievement.percentComplete = percentComplete;
        let achievementArray: [GKAchievement] = [achievement];
        GKAchievement.reportAchievements(achievementArray) { (error) -> Void in
            if error != nil {
                print(error);
            } else {
                print("reported achievement with percent of \(percentComplete)");
                gameCenterAchievements.removeAll();
                self.loadAchievementPercentages();
            }
        }
    }
    
    //MARK: Update
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}

extension GameScene: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil);
        gameCenterAchievements.removeAll();
        loadAchievementPercentages();
    }
    
    func showGameCenter() {
        let gameCenterViewController = GKGameCenterViewController();
        gameCenterViewController.gameCenterDelegate = self;
        
        let vc: UIViewController = self.view!.window!.rootViewController!
        vc.presentViewController(gameCenterViewController, animated: true, completion: nil);
    }
}
