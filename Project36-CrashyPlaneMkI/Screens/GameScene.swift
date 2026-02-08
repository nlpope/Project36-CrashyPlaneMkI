//  File: GameScene.swift
//  Project: Project36-CrashyPlaneMkI
//  Created by: Noah Pope on 2/3/26.

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    var player: SKSpriteNode!
    var playerScore: Int!
    
    override func didMove(to view: SKView)
    {
        createPlayer()
        createSky()
        createBackground()
        createGround()
        startRocks()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    //-------------------------------------//
    // MARK: - SUPPORTING METHODS
    
    func createPlayer()
    {
        let heliFrame1Texture = SKTexture(imageNamed: TextureKeys.heliFrame1)
        player = SKSpriteNode(texture: heliFrame1Texture)
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
        #warning("i dont get xscale")
        topObstacleRock.xScale = -1.0
        //why is anchor point zero not needed?
        topObstacleRock.zPosition = -20
        
        let bottomObstacleRock = SKSpriteNode(texture: obstacleRockTexture)
        bottomObstacleRock.xScale = -1.0
        bottomObstacleRock.zPosition = -20
        
        let goalPost = SKSpriteNode(
            color: UIColor.red,
            size: CGSize(width: 32, height: frame.height)
        )
        goalPost.name  = NameKeys.goalPost
        
//        addChildren(topObstacleRock, bottomObstacleRock, goalPost)

        //-------------------------------------//
        let xPosition = frame.width + topObstacleRock.frame.width
        let max = CGFloat(frame.height / 3)
//        let yPosition = CGFloat.random(in: -50...max) //problem child
        let yPosition = CGFloat.random(in: -50...max)
        let rockDistance: CGFloat = 70
        
        topObstacleRock.position = CGPoint(
            x: xPosition,
            y: yPosition + topObstacleRock.size.height + rockDistance
        )
        
        print("------------------------------")
        print("cgpoint.y = yposition: \(yPosition)")
        print(" + rock.size.height: \(topObstacleRock.size.height)")
        print("+ rockDistance: \(rockDistance)")
        print(topObstacleRock.position.y)//so it's lower the smaller y is and higher the bigger y is
        
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
    
    
    func startRocks()
    {
        let create = SKAction.run { [unowned self] in
            self.createObstacles()
        }
        
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
}
