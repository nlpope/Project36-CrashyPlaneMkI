//  File: GameScene.swift
//  Project: Project36-CrashyPlaneMkI
//  Created by: Noah Pope on 2/3/26.

import SpriteKit
import GameplayKit

enum GameState
{
    case showingLogo
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var logoScreen: SKSpriteNode!
    var gameOverScreen: SKSpriteNode!
    var gameState = GameState.showingLogo
    
    var player: SKSpriteNode!
    var backgroundMusic: SKAudioNode!
    var scoreBoard: SKLabelNode!
    var gravity = -5.0
    var playerScore = 0 {
        didSet {
            scoreBoard.text = "SCORE: \(playerScore)"
            #warning("change to % 10")
            if playerScore % 10 == 0 { gravity -= 2; configPhysicsWorld(dy: gravity) }
        }
    }
    
    /**
     setting up the rockPhysicsBody and explosionEmitter as global props solves for a lag
     produced when said props are configged @ the time of generation.
     I don't know why but setting up an SKEmitterNode up top produces an optional
     who's 'position' prop cannot be equated to the player's for it being a (CGPoint) -> some View as
     opposed to just a CGPoint
     */
    let rockTexture = SKTexture(imageNamed: TextureKeys.rockObstacle)
    var rockPhysicsBody: SKPhysicsBody!
    
    let cactusTexture = SKTexture(imageNamed: TextureKeys.cactusObstacle)
    var cactusPhysicsBody: SKPhysicsBody!
    
    let explosionEmitter = SKEmitterNode(fileNamed: EmitterKeys.playerExplosion)
    
    override func didMove(to view: SKView)
    {
        configLogos()
        configPlayer()
        configSky()
        configBackground()
        configGround()
        configScoreBoard()
        configPhysicsWorld(dy: -5)
        configMusic()
    }
    
    //-------------------------------------//
    // MARK: - CONFIGURATION
    
    func configLogos()
    {
        logoScreen = SKSpriteNode(imageNamed: TextureKeys.logo)
        logoScreen.position = CGPoint(
            x: frame.midX,
            y: frame.midY
        )
        addChild(logoScreen)
        
        gameOverScreen = SKSpriteNode(imageNamed: TextureKeys.gameOver)
        gameOverScreen.position = CGPoint(
            x: frame.midX,
            y: frame.midY
        )
        gameOverScreen.alpha = 0
        addChild(gameOverScreen)
    }
    
    
    func configPhysicsWorld(dy: Double)
    {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: dy)
        //-5
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
            node.physicsBody = SKPhysicsBody(
                texture: node.texture!,
                size: node.texture!.size()
            )
            //tells us when the player collides w anything
            //wasteful in some games but  here the player dies if they touch anything so it's okay
            node.physicsBody!.contactTestBitMask = node.physicsBody!.collisionBitMask
            //isDynamic makes the plane respond to physics
            //true = default but including it so we can change it later
            node.physicsBody?.isDynamic = false
            //makes the plane bounce off nothing
//            node.physicsBody?.collisionBitMask = 0
            
        case NameKeys.ground:
            node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
            node.physicsBody?.isDynamic = false
//            node.physicsBody?.collisionBitMask = 0
            
        case NameKeys.rock:
            if rockPhysicsBody == nil {
                rockPhysicsBody = SKPhysicsBody(
                    texture: rockTexture,
                    size: rockTexture.size()
                )
            }
            node.physicsBody = rockPhysicsBody.copy() as? SKPhysicsBody
            node.physicsBody?.isDynamic = false
//            node.physicsBody?.collisionBitMask = 2
            
        case NameKeys.cactus:
            if cactusPhysicsBody == nil {
                cactusPhysicsBody = SKPhysicsBody(
                    texture: cactusTexture,
                    size: cactusTexture.size()
                )
            }
            node.physicsBody = cactusPhysicsBody.copy() as? SKPhysicsBody
            node.physicsBody?.isDynamic = false
            
        case NameKeys.goalPost:
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.isDynamic = false
            
        default:
            return
        }
    }
    
    
    func configMusic()
    {
        //turn silent mode off for music to work
        //auto loops + non-incidental (.wav) case
        if let musicURL = Bundle.main.url(
            forResource: "music",
            withExtension: "m4a"
        ) {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
    
    
    func configPlayer()
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
    
    
    func configSky()
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
    
    
    func configBackground()
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
    
    
    func configGround()
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

    
    func configScoreBoard()
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
    // MARK: - ASSET CREATION
    
    func createObstacles()
    {
        let randomInt = Int.random(in: 0...5)
        let rockTexture = SKTexture(imageNamed: TextureKeys.rockObstacle)
        let cactusTexture = SKTexture(imageNamed: TextureKeys.cactusObstacle)
//        let selectedTexture = randomInt == 3 ? cactusTexture : rockTexture
        let selectedTexture = randomInt == 3 ? cactusTexture : cactusTexture
        
        //-------------------------------------//
        let topObstacle = SKSpriteNode(texture: selectedTexture)
        topObstacle.name = selectedTexture == cactusTexture ? "cactus" : "rock"
        /**
         configging the physics here, before all the below manipulation
         keeps the pixel perfect contact rather than a distorted one that's too far or close to the texture
         */
        configPhysics(for: topObstacle)
        topObstacle.zRotation = .pi
        topObstacle.xScale = -1.0
        topObstacle.zPosition = -20
        
        let bottomObstacle = SKSpriteNode(texture: selectedTexture)
        bottomObstacle.name = selectedTexture == cactusTexture ? "cactus" : "rock"
        configPhysics(for: bottomObstacle)
        bottomObstacle.xScale = -1.0
        bottomObstacle.zPosition = -20
        
        if selectedTexture == cactusTexture {
            topObstacle.setScale(1.5)
            bottomObstacle.setScale(1.5)
            topObstacle.yScale = 3.0
            bottomObstacle.yScale = 3.0
        }
        
        let goalPost = SKSpriteNode(
            color: UIColor.clear,
            size: CGSize(width: 32, height: frame.height)
        )
        
        goalPost.name  = NameKeys.goalPost
        configPhysics(for: goalPost)
        
        //-------------------------------------//
        // MARK: - OBSTACLE POSITIONING
        
        let xPosition = frame.width + topObstacle.frame.width
        let maxY = CGFloat(frame.height / 3)
        //obstacleSafeGap determines where safe gaps in rocks should be
        //setting low range to be 110 as anything below that value
        //e.g. -50 results in my top rock floating off the top view
        let yPosition = CGFloat.random(in: 110...maxY)
        let obstacleSafeGap: CGFloat = 70
        
        topObstacle.position = CGPoint(
            x: xPosition,
            y: yPosition + topObstacle.size.height + obstacleSafeGap
        )
        
        bottomObstacle.position = CGPoint(
            x: xPosition,
            y: yPosition - obstacleSafeGap
        )
        
        goalPost.position = CGPoint(
            x: xPosition + (goalPost.size.width * 2),
            y: frame.midY
        )
        
        addChildren(topObstacle, bottomObstacle, goalPost)

        //-------------------------------------//
        let endPosition = frame.width + (topObstacle.frame.width * 2)
        
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
        // MARK: - OBSTACLE ANIMATIONS
        
        topObstacle.run(moveSequence)
        bottomObstacle.run(moveSequence)
        goalPost.run(moveSequence)
        
        let scaleAction = SKAction.scale(by: 1.2, duration: 3.0)
        topObstacle.run(scaleAction)
        bottomObstacle.run(scaleAction)
    }
    
    
    func startObstacles()
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
    // MARK: - ASSET DESTRUCTION
    
    func destroyPlayer()
    {
        //below doesn't work for reason stated above,
        //but leaving definition up top as it still saves the emitter in memory,
        //solving the lag issue it has if it were generated on the spot
//        if explosionEmitter != nil {
//            explosionEmitter.position = player.position
//            addChild(explosionEmitter)
//        }
        
        if let explosionEmitter = SKEmitterNode(fileNamed: EmitterKeys.playerExplosion) {
            explosionEmitter.position = player.position
            addChild(explosionEmitter)
        }
        
        let sound = SKAction.playSoundFileNamed(
            SoundKeys.explosionWav,
            waitForCompletion: false
        )
        
        run(sound)
        gameOverScreen.alpha = 1
        gameState = .dead
        backgroundMusic.run(SKAction.stop())
        player.removeFromParent()
        speed = 0
    }
    
    //-------------------------------------//
    // MARK: - ASSET CONTACT & DESTRUCTION AND FRAME UPDATES
    
    override func update(_ currentTime: TimeInterval)
    {
        guard player != nil else { return }
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        switch gameState {
            
        case .showingLogo:
            gameState = .playing
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let wait = SKAction.wait(forDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let activatePlayer = SKAction.run { [unowned self] in
                self.player.physicsBody?.isDynamic = true
                self.startObstacles()
            }
            
            let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
            logoScreen.run(sequence)
            
        case .playing:
            player.physicsBody?.velocity = CGVector(
                dx: 0,
                dy: 0
            )
            player.physicsBody?.applyImpulse(CGVector(
                dx: 0,
                dy: 20
            ))
            
        case .dead:
            if let scene = GameScene(fileNamed: NameKeys.gameScene) {
                scene.scaleMode = .resizeFill
                let transition = SKTransition.moveIn(
                    with: SKTransitionDirection.right,
                    duration: 1
                )
                view?.presentScene(scene, transition: transition)
            }
        }
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
}
