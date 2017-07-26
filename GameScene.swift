//
//  GameScene.swift
//  Space Invaders Clone
//
//  Created by MacBook Air 13 on 2017. 04. 22..
//  Copyright © 2017. salgokrisz. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    
    var gameLevel = 0
    var livesNumber = 3
    let scoreLabel = SKLabelNode(fontNamed: "Starjedi")
    let levelLabel = SKLabelNode(fontNamed: "Starjedi")
    let livesLabel = SKLabelNode(fontNamed: "Starjedi")
    
    

    
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    let bulletSound = SKAction.playSoundFileNamed("laserSound.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false)
    
    
    enum gameState{
        case preGame // when the game is about to start
        case inGame // when we are in the game
        case afterGame // when the game is finished
    }
    
    var currentGameState = gameState.inGame
    
    
    
    struct PhysicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1
        static let Bullet: UInt32 = 0b10
        static let Enemy: UInt32 = 0b100
    }
    
    
    
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    
    var gameArea: CGRect
    
    override init(size: CGSize){
        
        let  maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not ben impplemented")
    }
    

    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale(0.5)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x:self.size.width*0.15, y:self.size.height*0.9)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        levelLabel.text = "Level: 1"
        levelLabel.fontSize = 50
        levelLabel.fontColor = SKColor.white
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        levelLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height*0.9)
        levelLabel.zPosition = 100
        self.addChild(levelLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 50
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height*0.95)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        startNewLevel()
        
    }
    
    func loseLife(){
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0{
            gameOver()
        }
        
    }
    
    func addScore(){
    
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50{
            startNewLevel()
            rotate()
        }
    
    }
    
    
    func gameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        let changeGameScene = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let waitToPlaySound = SKAction.wait(forDuration: 0.5)
        let changeSceneSequence = SKAction.sequence([waitToPlaySound, gameOverSound, waitToChangeScene, changeGameScene])
        self.run(changeSceneSequence)
    }
    
    func changeScene(){
        let sceneToMoveTo = gameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            //if enemy hits the player
            loseLife()
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            gameOver()
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height{
            //if a bullet hits an enemy
            addScore()
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
        
        
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
        
    }
    
    func rotate(){
        let highLightFont = levelLabel
        let rotate = SKAction.rotate(byAngle: 6.2831853072, duration: 0.35)
        let ratateSequence = SKAction.sequence([rotate])
        highLightFont.run(ratateSequence)
    }
    
    
    
    func startNewLevel(){
        
        gameLevel += 1
        levelLabel.text = "Level: \(gameLevel)"
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch gameLevel {
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
        }
    
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    
    }
    
    
    
    func fireBullet(){
    
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(0.08)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
        
    }
    
    func spawnEnemy(){
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.name = "Enemy"
        enemy.setScale(0.3)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2)
        let deleteEnemy = SKAction.removeFromParent()
        let loseLifeAction = SKAction.run(loseLife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseLifeAction])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
        }
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.inGame{
            fireBullet()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            
            if currentGameState == gameState.inGame{
                player.position.x += amountDragged
            }
            if player.position.x > gameArea.maxX {
                player.position.x = gameArea.maxX
            }
            if player.position.x < gameArea.minX {
                player.position.x = gameArea.minX
            }
            
        }
        
        
    }
    
    
    
}
