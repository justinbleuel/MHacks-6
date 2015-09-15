//
//  GameScene.swift
//  Hacknight with jo
//
//  Created by Justin Bleuel on 9/12/15 at MHacks VI
//  Copyright (c) 2015 Justin Bleuel. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    var score = 0
    var highscore = 0
    var scoreLabel = SKLabelNode()
    var gameoverLabel = SKLabelNode()
    var extraLabel = SKLabelNode()
    var player = SKSpriteNode()
    var background = SKSpriteNode()
    var ground = SKNode()
    var corn = SKSpriteNode()
    var ufo = SKSpriteNode()
    var movingGood = SKSpriteNode()
    var movingEvil = SKSpriteNode()
    var labelContainer = SKSpriteNode()
    enum ColliderType: UInt32{
        case Player = 1
        case Evil = 2
        case Good = 4
    }
    
    var gameOver = true
    
    func makeBackground() {
        let backgroundTexture = SKTexture(imageNamed: "cloudysky")
        
        let movebackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 5)
        let replacebackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        let movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebackground, replacebackground]))
        
        
        
        for var i: CGFloat=0; i<3; i++ {
            background = SKSpriteNode(texture: backgroundTexture)
            
            background.position = CGPoint(x:  backgroundTexture.size().width +
                backgroundTexture.size().width*i, y: CGRectGetMidY(self.frame))
            
            background.size.height = self.frame.height
            
            background.zPosition = -5
            
            background.runAction(movebgForever)
            
            movingEvil.addChild(background)
        }

    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        if highscore > 0 {
            extraLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height - 70)
            extraLabel.text = "High score: " + String(highscore)
            extraLabel.fontName = "Helvetica"
            extraLabel.fontColor = UIColor.whiteColor()
            extraLabel.fontSize = 25
            labelContainer.addChild(extraLabel)
        }
        
        if gameOver == true {
            self.speed = 0
            gameoverLabel.fontName = "Helvetica"
            gameoverLabel.fontColor = UIColor.blackColor()
            gameoverLabel.fontSize = 25
            gameoverLabel.text = "collect the swag, avoid the distractions!"
            gameoverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            labelContainer.addChild(gameoverLabel)
        }
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingEvil)
        self.addChild(movingGood)
        self.addChild(labelContainer)
        
        makeBackground()
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLabel)

        
        
        let playerTexture = SKTexture(imageNamed: "littleguy")
        let playerTexture2 = SKTexture(imageNamed: "littleguy2")
        let playerTexture3 = SKTexture(imageNamed: "littleguy3")
        let playerTexture4 = SKTexture(imageNamed: "littleguy4")
        let playerTexture5 = SKTexture(imageNamed: "littleguy5")
        let playerTexture6 = SKTexture(imageNamed: "littleguy6")
        let playerTexture7 = SKTexture(imageNamed: "littleguy7")
    
        let animation = SKAction.animateWithTextures([playerTexture, playerTexture5, playerTexture3,playerTexture6, playerTexture7, playerTexture4, playerTexture2], timePerFrame: 0.1)
        let makePlayerAnimate = SKAction.repeatActionForever(animation)
        
        player = SKSpriteNode(texture: playerTexture)
        
        player.position = CGPoint(x: CGRectGetMidX(self.frame)-100, y: CGRectGetMidY(self.frame))
        player.size = CGSize(width: 70.0, height: 70.0)
        
        player.runAction(makePlayerAnimate)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: playerTexture.size().height/100)
        player.physicsBody!.dynamic = true
        player.physicsBody!.allowsRotation = false
        
        player.physicsBody!.categoryBitMask = ColliderType.Player.rawValue
        player.physicsBody!.contactTestBitMask = ColliderType.Evil.rawValue
        player.physicsBody!.collisionBitMask = ColliderType.Evil.rawValue
        
        self.addChild(player)
        
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody!.dynamic = false
        
        ground.physicsBody!.categoryBitMask = ColliderType.Evil.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.Evil.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Evil.rawValue
        
        self.addChild(ground)
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("makeCorn"), userInfo: nil, repeats: true)
        _ = NSTimer.scheduledTimerWithTimeInterval(2.2, target: self, selector: Selector("makeUFO"), userInfo: nil, repeats: true)
        
    }
    
    func makeUFO() {
        
        //randomly select evils
        
        
        let textures = ["snorlax", "bed", "internet"]
        let randomIndex = Int(arc4random()) % 3
        
        let UFOTexture = SKTexture(imageNamed: textures[randomIndex])
        ufo = SKSpriteNode(texture: UFOTexture)
        
        let moveUFO = SKAction.moveByX(-self.frame.size.width, y: 0, duration: NSTimeInterval (self.frame.size.width / 100))
        let removeUFO = SKAction.removeFromParent()
        let moveAndRemoveUFO = SKAction.sequence([moveUFO, removeUFO])
        
        ufo.physicsBody = SKPhysicsBody(circleOfRadius: UFOTexture.size().height/10)
        ufo.physicsBody!.dynamic = false
        
        let placement = arc4random() % UInt32(self.frame.size.height)
        ufo.position = CGPoint(x: self.frame.size.height*1.5, y: CGFloat(placement))
        ufo.size = CGSize(width: 100.0, height: 75.0)
        
        ufo.runAction(moveAndRemoveUFO)
        
        movingEvil.addChild(ufo)
    }
    
    func makeCorn() {
    /*    let cornTexture = SKTexture(imageNamed: "corn")  */
        
        //randomly select swag
        let textures = ["accel", "mhacks", "arm", "walmart", "a16z", "microsoft", "google", "apple", "capitalone", "umich", "amex"]
        let randomIndex = Int(arc4random()) % 11
        
        let cornTexture = SKTexture(imageNamed: textures[randomIndex])
        corn = SKSpriteNode(texture: cornTexture)
        
        let moveCorn = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        let removeCorn = SKAction.removeFromParent()
        let moveAndRemoveCorn = SKAction.sequence([moveCorn, removeCorn])
        
        let placement = arc4random() % UInt32(self.frame.size.height)
        corn.position = CGPoint(x: self.frame.size.height*1.5, y: CGFloat(placement+80))
        corn.size = CGSize(width: 80.0, height: 80.0)
        
        corn.runAction(moveAndRemoveCorn)
        
        
        corn.physicsBody = SKPhysicsBody(circleOfRadius: cornTexture.size().height/100)
        corn.physicsBody!.dynamic = false
        
        corn.physicsBody!.categoryBitMask = ColliderType.Good.rawValue
        corn.physicsBody!.contactTestBitMask = ColliderType.Player.rawValue
        corn.physicsBody!.collisionBitMask = ColliderType.Good.rawValue
        
        movingGood.addChild(corn)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyB.categoryBitMask == ColliderType.Good.rawValue {
            score++
            scoreLabel.text = String(score)
            movingGood.removeAllChildren()
        } else {
            
            if gameOver == false {
                gameOver = true
                if score > highscore {
                    highscore = score
                }
                labelContainer.removeAllChildren()
                self.speed = 0
                gameoverLabel.fontName = "Helvetica"
                gameoverLabel.fontSize = 30
                gameoverLabel.text = "Game Over! Tap to play again"
                gameoverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                extraLabel.fontName = "Helvetica"
                extraLabel.fontSize = 25
                extraLabel.text = "Score: " + String(score) + ", High score: " + String(highscore)
                extraLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-50)
                extraLabel.fontColor = UIColor.blackColor()
                labelContainer.addChild(gameoverLabel)
                labelContainer.addChild(extraLabel)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if gameOver == false {
        
            player.physicsBody!.velocity = CGVectorMake(0, 0)
            player.physicsBody!.applyImpulse(CGVectorMake(0, 30))
        } else {
            
            score = 0
            scoreLabel.text = "0"
            player.position = CGPointMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)+100)
          /*  player.physicalBody!.velocity = CGVectorMake(0, 0) */
            movingGood.removeAllChildren()
            movingEvil.removeAllChildren()
            makeBackground()
            self.speed = 1
            gameOver = false
            labelContainer.removeAllChildren()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
