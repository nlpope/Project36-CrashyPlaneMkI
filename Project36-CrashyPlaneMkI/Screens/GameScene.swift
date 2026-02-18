//  File: GameScene.swift
//  Project: Project36-CrashyPlaneMkI
//  Created by: Noah Pope on 2/3/26.

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var player: SKSpriteNode!
    var scoreBoard: SKLabelNode!
    var playerScore = 0 {
        didSet { scoreBoard.text = "SCORE: \(playerScore)" }
    }
    
    override func didMove(to view: SKView)
    {
        createPlayer()
        createSky()
        createBackground()
        createGround()
        createScoreBoard()
        configPhysicsWorld()
        startRocks()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
    }
    
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    func configPhysicsWorld()
    {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    }
    
    /**
     the call to config physics for player comes after addChild
     and the call for the ssame on the ground is called before addChild
     what's the difference?
     */
    
    func configPhysics(for node: SKSpriteNode)
    {
        switch node.name {
            
        case NameKeys.player:
            //creates pixel-perfect physics
            node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
            //tells us when the player collides w anything
            //wasteful in some games but  here the player dies if they touch anything so it's okay
            node.physicsBody!.contactTestBitMask = node.physicsBody!.collisionBitMask
            //isDynamic makes the plane respond to physics
            //true = default but including it so we can change it later
            node.physicsBody?.isDynamic = true
            //makes the plane bounce off nothing
//            node.physicsBody?.collisionBitMask = 0
            
        case NameKeys.ground:
            node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
            node.physicsBody?.isDynamic = false
//            node.physicsBody?.collisionBitMask = 0
            
        case NameKeys.rock:
            node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
            node.physicsBody?.isDynamic = false
//            node.physicsBody?.collisionBitMask = 2
            
        case NameKeys.goalPost:
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.isDynamic = false
            
        default:
            return
        }
    }
    
    //-------------------------------------//
    // MARK: - ASSET CREATION
    
    func createPlayer()
    {
        let heliFrame1Texture = SKTexture(imageNamed: TextureKeys.heliFrame1)
        player = SKSpriteNode(texture: heliFrame1Texture)
        player.name = NameKeys.player
        configPhysics(for: player)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(player)
        
        let heliFrame2Texture = SKTexture(imageNamed: TextureKeys.heliFrame2)
        let heliFrame3Texture = SKTexture(imageNamed: TextureKeys.heliFrame3)
        let animation = SKAction.animate(with: [heliFrame1Texture, heliFrame2Texture, heliFrame3Texture], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever)
    }
    
    
    func createSky()
    {
        /**
         I think these are spriteNodes for the simple fact that I cant create a texture out of thin air specifying only a color. I think the sky could be swapped for a texture though since it's not needing to be manipulated (? i was wrong, background ended up being a node anyways)
         */
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55,
                                                 saturation: 0.14,
                                                 brightness: 0.97,
                                                 alpha: 1),
                                  size: CGSize(width: frame.width,
                                               height: frame.height * 0.67)
        )
        
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55,
                                                    saturation: 0.16,
                                                    brightness: 0.96,
                                                    alpha: 1),
                                     size: CGSize(width: frame.width,
                                                  height: frame.height * 0.33)
        )
                
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        topSky.zPosition = -40
        bottomSky.zPosition = -40
        
        addChildren(topSky, bottomSky)
    }
    
    
    func createBackground()
    {
        let backgroundTexture = SKTexture(imageNamed: TextureKeys.background)
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(
                x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i),
                y: 100
            )
            
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
    
    
    func createGround()
    {
        let groundTexture = SKTexture(imageNamed: TextureKeys.ground)
        
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.name = NameKeys.ground
            configPhysics(for: ground)
            ground.zPosition = -10
            ground.anchorPoint = CGPoint.zero
            ground.position = CGPoint(
                x: (groundTexture.size().width * CGFloat(i)) - CGFloat(1 * i),
                y: 0
            )
                        
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
    
    
    func createRockObstacles()
    {
        let obstacleRockTexture = SKTexture(imageNamed: TextureKeys.rockObstacle)
        
        //-------------------------------------//
        let topRockObstacle = SKSpriteNode(texture: obstacleRockTexture)
        topRockObstacle.name = "rock"
        /**
         configging the physics here, before all the below manipulation
         keeps the pixel perfect contact rather than a distorted one that's too far or close to the texture
         */
        configPhysics(for: topRockObstacle)
        topRockObstacle.zRotation = .pi
        topRockObstacle.xScale = -1.0
        topRockObstacle.zPosition = -20
        
        let bottomRockObstacle = SKSpriteNode(texture: obstacleRockTexture)
        bottomRockObstacle.name = NameKeys.rock
        configPhysics(for: bottomRockObstacle)
        bottomRockObstacle.xScale = -1.0
        bottomRockObstacle.zPosition = -20
        
        //AKA rockCollision
        let goalPost = SKSpriteNode(
            color: UIColor.red,
            size: CGSize(width: 32, height: frame.height)
        )
        
        goalPost.name  = NameKeys.goalPost
        configPhysics(for: goalPost)
        
        //-------------------------------------//
        let xPosition = frame.width + topRockObstacle.frame.width
        let maxY = CGFloat(frame.height / 3)
        //yPosition determines where safe gaps in rocks should be
        //setting low range to be 110 as anything below that value
        //e.g. -50 results in my top rock floating off the top view
        let yPosition = CGFloat.random(in: 110...maxY)
        let rockDistance: CGFloat = 70
        
        topRockObstacle.position = CGPoint(
            x: xPosition,
            y: yPosition + topRockObstacle.size.height + rockDistance
        )
        
        bottomRockObstacle.position = CGPoint(
            x: xPosition,
            y: yPosition - rockDistance
        )
        
        goalPost.position = CGPoint(
            x: xPosition + (goalPost.size.width * 2),
            y: frame.midY
        )
        
        addChildren(topRockObstacle, bottomRockObstacle, goalPost)

        //-------------------------------------//
        let endPosition = frame.width + (topRockObstacle.frame.width * 2)
        
        let moveAction = SKAction.moveBy(
            x: -endPosition,
            y: 0,
            duration: 6.2
        )
        
        let moveSequence = SKAction.sequence([
            moveAction,
            SKAction.removeFromParent()
        ])
        
        //-------------------------------------//
        topRockObstacle.run(moveSequence)
        bottomRockObstacle.run(moveSequence)
        goalPost.run(moveSequence)
    }
    
    
    func createScoreBoard()
    {
        scoreBoard = SKLabelNode(fontNamed: FontKeys.optimaExtraBlack)
        scoreBoard.fontSize = 24
        scoreBoard.text = "SCORE: 0"
        scoreBoard.fontColor = UIColor.black
        scoreBoard.position = CGPoint(
            x: frame.maxX - 70,
            y: frame.maxY - 60
        )
        
        addChild(scoreBoard)
    }
    
    //-------------------------------------//
    // MARK: - INITIALIZATION
    
    func startRocks()
    {
        let create = SKAction.run { [unowned self] in
            self.createRockObstacles()
        }
        
        let wait = SKAction.wait(forDuration:2)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    
    //-------------------------------------//
    // MARK: - SCORE KEEPING
    
    //-------------------------------------//
    // MARK: - ASSET CONTACT & DESTRUCTION AND FRAME UPDATES
    
    override func update(_ currentTime: TimeInterval)
    {
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        guard let  contactBodyA = contact.bodyA.node else { return }
        guard let contactBodyB = contact.bodyB.node else { return }
        
        guard contactBodyA.name == NameKeys.goalPost || contactBodyB.name == NameKeys.goalPost
        else { destroyPlayer(); return }
        
        if contactBodyA == player {
            contactBodyB.removeFromParent()
        } else {
            contactBodyA.removeFromParent()
        }
        
        let sound = SKAction.playSoundFileNamed(SoundKeys.coinWav, waitForCompletion: false)
        run(sound)
        
        playerScore += 1
        
        return
    }
    
    
    func destroyPlayer()
    {
        
    }
}
