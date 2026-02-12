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
        startRocks()
        //report collisions to game scnee
        //add method - configPhysicsWorld
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    func configWorldPhysics()
    {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    }
    
    
    func configPlayerPhysics(for player: SKSpriteNode)
    {
        guard let playerTexture = player.texture else { return }
        //creates pixel-perfect physics
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        //tells us when the player collides w anything
        //wasteful in some games but  here the player dies if they touch anything so it's okay
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        //isDynamic makes the plae respond to physics
        //true = default but including it so we can change it later
        player.physicsBody?.isDynamic = true
        //makes the plane bounce off nothing
//        player.physicsBody?.collisionBitMask = 0
    }
    
    //-------------------------------------//
    // MARK: - ASSET CREATION
    
    func createPlayer()
    {
        let heliFrame1Texture = SKTexture(imageNamed: TextureKeys.heliFrame1)
        player = SKSpriteNode(texture: heliFrame1Texture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(player)
        
        configPlayerPhysics(for: player)
        
        let heliFrame2Texture = SKTexture(imageNamed: TextureKeys.heliFrame2)
        let heliFrame3Texture = SKTexture(imageNamed: TextureKeys.heliFrame3)
        let animation = SKAction.animate(with: [heliFrame1Texture, heliFrame2Texture, heliFrame3Texture], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever)
    }
    
    
    func createSky()
    {
        //I think these are spriteNodes for the simple fact that I cant create a texture out of thin air specifying only a color. I think the sky could be swapped for a texture though since it's not needing to be manipulated (? i was wrong, background ended up being a node anyways)
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
    
    
    func createObstacles()
    {
        let obstacleRockTexture = SKTexture(imageNamed: TextureKeys.obstacleRock)
        
        //-------------------------------------//
        let topObstacleRock = SKSpriteNode(texture: obstacleRockTexture)
        topObstacleRock.zRotation = .pi
        topObstacleRock.xScale = -1.0
        topObstacleRock.zPosition = -20
        
        let bottomObstacleRock = SKSpriteNode(texture: obstacleRockTexture)
        bottomObstacleRock.xScale = -1.0
        bottomObstacleRock.zPosition = -20
        
        let goalPost = SKSpriteNode(
            color: UIColor.red,
            size: CGSize(width: 32, height: frame.height)
        )
        goalPost.name  = NameKeys.goalPost
        
        //-------------------------------------//
        let xPosition = frame.width + topObstacleRock.frame.width
        let maxY = CGFloat(frame.height / 3)
        //yPosition determines where safe gaps in rocks should be
        //setting low range to be 110 as anything below that value
        //e.g. -50 results in my top rock floating off the top view
        let yPosition = CGFloat.random(in: 110...maxY)
        let rockDistance: CGFloat = 70
        
        topObstacleRock.position = CGPoint(
            x: xPosition,
            y: yPosition + topObstacleRock.size.height + rockDistance
        )
        
        print("------------------------------")
        print("frame height: \(frame.height)")
        print("1/3 of frame height: \(frame.height / 3)")
        print("cgpoint.y = yposition: \(yPosition)")
        print(" + rock.size.height: \(topObstacleRock.size.height)")
        print("+ rockDistance: \(rockDistance)")
        print("so toprocks cgpoint.y = \(topObstacleRock.position.y)")
        
        bottomObstacleRock.position = CGPoint(
            x: xPosition,
            y: yPosition - rockDistance
        )
        
        goalPost.position = CGPoint(
            x: xPosition + (goalPost.size.width * 2),
            y: frame.midY
        )
        
        addChildren(topObstacleRock, bottomObstacleRock, goalPost)

        //-------------------------------------//
        let endPosition = frame.width + (topObstacleRock.frame.width * 2)
        
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
        topObstacleRock.run(moveSequence)
        bottomObstacleRock.run(moveSequence)
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
            self.createObstacles()
        }
        
        let wait = SKAction.wait(forDuration:2)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    
    //-------------------------------------//
    // MARK: - SCORE KEEPING
    
    
}
