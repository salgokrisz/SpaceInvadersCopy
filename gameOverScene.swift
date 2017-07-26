//
//  gameOverScene.swift
//  Space Invaders Clone
//
//  Created by MacBook Air 13 on 2017. 05. 01..
//  Copyright © 2017. salgokrisz. All rights reserved.
//

import Foundation
import SpriteKit

class gameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "Starjedi")

    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Starjedi")
        gameOverLabel.text = "game over"
        gameOverLabel.fontSize = 150
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.65)
        gameOverLabel.zPosition = 2
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Starjedi")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x:self.size.width*0.5, y:self.size.height*0.55)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScore = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScore{
            highScore = gameScore
            defaults.set(highScore, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "Starjedi")
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 100
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.45)
        highScoreLabel.zPosition = 2
        self.addChild(highScoreLabel)
        
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 100
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.35)
        restartLabel.zPosition = 2
        self.addChild(restartLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if restartLabel.contains(pointOfTouch){
                //scaleFunc()
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
        }
        
    }
    
    /*func scaleFunc(){
        
        let scaleDown = SKAction.scale(to: 0.5, duration: 0.5)
        let scaleUp = SKAction.scale(to: 1, duration: 0.5)
        let pulseSequence = SKAction.sequence([scaleDown, scaleUp])
        restartLabel.run(pulseSequence)
        
    }*/
    
    

}
