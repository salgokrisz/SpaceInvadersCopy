//
//  startGameScene.swift
//  Space Invaders Clone
//
//  Created by MacBook Air 13 on 2017. 05. 02..
//  Copyright © 2017. salgokrisz. All rights reserved.
//

import Foundation
import SpriteKit

class startGameScene: SKScene{
    
    let startGameLabel = SKLabelNode(fontNamed: "Starjedi")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        startGameLabel.text = "Start Game"
        startGameLabel.fontSize = 150
        startGameLabel.fontColor = SKColor.white
        startGameLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        startGameLabel.zPosition = 2
        self.addChild(startGameLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if startGameLabel.contains(pointOfTouch){
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
        startGameLabel.run(pulseSequence)
        
    }*/
}

