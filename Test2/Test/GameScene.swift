//
//  TestScene.swift
//
//  Testing Scene for testing purpose
//
//  Created by Dalton Danis on 2017-02-16.
//  Copyright © 2017 Dalton Danis. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
//============= General Declarations =============
    var wave = 1
    var health = Settings.Game.health
    var monstersDestroyed = 0 // # of monsters destroyed
    
    let player = SKSpriteNode(imageNamed: "player")
    var projectile: SKSpriteNode!
//============= Label Declarations =============
    var waveLabel = getWave()
    var healthLabel = getHealth()
    
//============= Projectile Power Declarations =============
    var count = 0
    var isTouching = false;
    
    
//============= Texture Declarations =============
    // define the purple monster's frames
    var purpleFlyingFrames : [SKTexture]!
    var purpleDeathFrames : [SKTexture]!
    
    
// Laura's change:
//============= Lives Declarations =============
    var livesArray:[SKSpriteNode]!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
//============= Game Declarations =============
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.gray
        
        // add background music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        //Label Declarations
        addChild(waveLabel)
        addChild(healthLabel)
        
        
        // Laura's change for 
        // define score Label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: (-size.width * 0.43 ), y: (size.height * 0.45)) // self.frame.size.height - 60
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        // Laura's change end
        
        
        //World Physics
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = Settings.Game.gravity
        physicsWorld.speed = 0.5
        
        player.position = playerLocation()
        addChild(player)
        
        // repeatedly add monster
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 2.0)
                ])
        ))
        
        // make purple monster flying frames
        var flyFrames:[SKTexture] = []
        let purpleAtlas = SKTextureAtlas(named: "Purple")
        
        for index in 1...6 {
            let textureName = "purple\(index)"
            flyFrames.append(purpleAtlas.textureNamed(textureName))
        }
        
        purpleFlyingFrames = flyFrames
        
        // make purple death frames
        var deathFrames:[SKTexture] = []
        let purpleDeathAtlas = SKTextureAtlas(named: "PurpleDeath")
        
        for index in 1...6 {
            let textureName = "purpleDeath\(index)"
            deathFrames.append(purpleDeathAtlas.textureNamed(textureName))
        }
        
        purpleDeathFrames = deathFrames
        
        // Laura's change
        // call add lives to initiate 3 heart icons at top right corner
        addLives()
    }
    
    
    // Laura's change:
    // Add lives function (3 heart icons)
    func addLives (){
        
        livesArray = [SKSpriteNode]()
        
        for live in 1 ... 3 {
            let liveNode = SKSpriteNode(imageNamed: "heart")
            liveNode.size = CGSize(width: 20, height: 20)
            liveNode.name = "live\(live)"
            
            //print(liveNode.name?.description)
            
            liveNode.position = CGPoint(x: size.width * 0.5 - CGFloat((4 - live)) * liveNode.size.width, y: size.height * 0.45)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Laura's change: call projectileDidCollideWithMonster function to process collision detection
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode, let
                projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
    }
//============= END of Game Declarations =============
    
    
//============= Monster Declarations =============
    func addMonster() {
        
        // define purple sprite's first present image as the first frame
        let temp : SKTexture = purpleFlyingFrames[0]
        let purple = SKSpriteNode(texture: temp)
        
        purple.size = CGSize(width: 80, height: 80)
        
        purple.physicsBody = SKPhysicsBody(rectangleOf: purple.size)
        purple.physicsBody?.isDynamic = false
        purple.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        purple.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        purple.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actualY = random(min: -(size.height/2 - purple.size.height), max: size.height/2 - purple.size.height/2)
        
        // define purple's initial position at the screen
        purple.position = CGPoint(x: size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(purple)
        
        // run purple with its own animation: repeat forever; call purpleFlyingFrames
        purple.run(SKAction.repeatForever(SKAction.animate(with: self.purpleFlyingFrames!, timePerFrame: 0.05, resize: false, restore: true)))
        
        // specify the duration for how long the movement should take
        let actualDuration = random(min: CGFloat(4.0), max: CGFloat(10.0))
        
        // move purple along screen from right to left by half of its width
        let actionMove = SKAction.move(to: CGPoint(x: -(self.frame.size.width+purple.size.width/2), y: actualY), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()

        let loseAction = SKAction.run() {
            
            // Laura's change: update lives icon in loseAction
            switch(self.health) {
            case 6:
                self.livesArray[0].texture = SKTexture(imageNamed: "heartHalf")
                break;
            case 5:
                self.livesArray[0].texture = SKTexture(imageNamed: "heartEmpty")
                break;
            case 4:
                self.livesArray[1].texture = SKTexture(imageNamed: "heartHalf")
                break;
            case 3:
                self.livesArray[1].texture = SKTexture(imageNamed: "heartEmpty")
                break;
            case 2:
                self.livesArray[2].texture = SKTexture(imageNamed: "heartHalf")
                break;
            case 1:
                self.livesArray[2].texture = SKTexture(imageNamed: "heartEmpty")
                break;
            default :
                print("hello default")
                
            }
            
            self.health -= 1
            // Laura's change end
            
            self.healthLabel.text = "Health: \(self.health)"
            if (self.health <  1) {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, won: false)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
        }
        
        purple.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
        
        // show the purpleDeath sprite as the first frame
        let temp : SKTexture = purpleDeathFrames[0]
        let purpleDeath = SKSpriteNode(texture: temp)
        
        // add purpleDeath to the scene
        purpleDeath.size = CGSize(width: 80, height: 80)
        purpleDeath.position = monster.position // fix the purpleDeath position as previous purple position
        self.addChild(purpleDeath)
        
        // for later use:
        // self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        // run purpleDeath with its own animation: repeat forever; call purpleDeathrames
        purpleDeath.run(SKAction.repeatForever(SKAction.animate(with: self.purpleDeathFrames!, timePerFrame: 0.05, resize: false, restore: true)))
        
        // let's show the purpleDeath animation for 1 sec
        self.run(SKAction.wait(forDuration: 1)) {
            purpleDeath.removeFromParent()
        }
        
        score += 5
        
        monstersDestroyed += 1
        if (monstersDestroyed > 20) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
//============= END of Monster Declarations =============
    
    
//============= Touch Declarations =============
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Added for Back button
        for touch in touches {
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Back" {
                if let scene = StartScene(fileNamed: "StartScene") {
                    scene.scaleMode = .aspectFill
                    view!.presentScene(scene, transition: SKTransition.fade(with: UIColor.black, duration: 0.2))
                }
            } else {
                isTouching = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        
        if (count >= 0) {
            
            // 1 - Choose one of the touches to work with
            guard let touch = touches.first else {
                return
            }
            let touchLocation = touch.location(in: self)
            
            setupBall();
            
            let vectorX
                = touchLocation.x - projectileAngleForTouchPosition(touchLocation, projectileRestPosition:projectile.position, circleRadius: CGFloat(40)).x
            let vectorY
                = touchLocation.y - projectileAngleForTouchPosition(touchLocation, projectileRestPosition:projectile.position, circleRadius: CGFloat(40)).y
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: Settings.Metrics.projectileRadius)
            
            //SKAction.applyImpulse(<#T##impulse: CGVector##CGVector#>, at: <#T##CGPoint#>, duration: TimeInterval)
            
            projectile.physicsBody?.applyImpulse(
                CGVector(
                    //0.1 - 1.0
                    dx: vectorX * CGFloat(0.15 * Float(count)/100),
                    dy: vectorY * CGFloat(0.15 * Float(count)/100)
                )
            )
            
            //projectile.physicsBody?.app
            
            projectile.physicsBody!.affectedByGravity = true
            
           
        }

        
        count = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isTouching {
            if (count <= 100) {
                print(Float(count)/100)
                count += 1
            }
        }
    }
//============= END of Touch Declarations =============

//============= Ball Declarations =============
    func setupBall(){
        projectile = SKSpriteNode(imageNamed: "projectile")
        
        projectile.position = player.position
        projectile.physicsBody?.isDynamic = false // 2
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        
//        var actionArray = [SKAction]()
//        
//        let removeAction = SKAction.run() {
//            
//            
//        }
//        
//        actionArray.append(SKAction.removeFromParent())
//        
//        if( projectile.position.y < (-size.height * 0.5) ){
//            run(SKAction.sequence(actionArray))
//        }
        
        addChild(projectile)
        
    
    }
    
    func projectileAngleForTouchPosition(_ fingerPosition: CGPoint, projectileRestPosition:CGPoint, circleRadius rLimit:CGFloat) -> CGPoint {
        
        // rests on y axis of start position
        if(fingerPosition.y == projectileRestPosition.y ){
            if(fingerPosition.y > projectileRestPosition.y){
                return CGPoint(x: projectileRestPosition.x + rLimit, y: projectileRestPosition.y)
            }else{
                return CGPoint(x: projectileRestPosition.x - rLimit, y: projectileRestPosition.y)
            }
        }
        
        // rests on x axis of start position
        if(fingerPosition.x == projectileRestPosition.x ){
            if(fingerPosition.x > projectileRestPosition.x){
                return CGPoint(x: projectileRestPosition.x, y: projectileRestPosition.y + rLimit)
            }else{
                return CGPoint(x: projectileRestPosition.x, y: projectileRestPosition.y - rLimit)
            }
        }
        
        // angle is valid
        let angleTheta = atan(
            (fingerPosition.y - projectileRestPosition.y )
                /
                (fingerPosition.x - projectileRestPosition.x)
        )
        
        
        
        let inverseX = projectileRestPosition.x - (rLimit * cos(angleTheta))
        let inverseY = projectileRestPosition.y - (rLimit * sin(angleTheta))
        return CGPoint(x: inverseX, y: inverseY)
    }
//============= END of Ball Declarations =============
    
//============= Function Declarations =============
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    func playerLocation() -> CGPoint {
        let width = self.size.width //207 or Y
        let height = self.size.height //368 or X
        
        let x = (((width/2)/4) * 3) * -1
        let y = (((height/2)/4) * 3) * -1
        
        let point = CGPoint(x: x, y: y)
        return point
    }
    
//============= END of Function Declarations =============
    
}

