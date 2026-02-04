//  File: GameScene.swift
//  Project: Project36-CrashyPlaneMkI
//  Created by: Noah Pope on 2/3/26.

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    var player: SKSpriteNode!
    
    override func didMove(to view: SKView)
    {
        createPlayer()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    //-------------------------------------//
    // MARK: - SUPPORTING METHODS
    
    func createPlayer()
    {
        let playerTextureFrame1 = SKTexture(imageNamed: PlayerKeys.player1)
        player = SKSpriteNode(texture: playerTextureFrame1)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(player)
        
        let playerTextureFrame2 = SKTexture(imageNamed: PlayerKeys.player2)
        let playerTextureFrame3 = SKTexture(imageNamed: PlayerKeys.player3)
        let animation = SKAction.animate(with: [playerTextureFrame1, playerTextureFrame2, playerTextureFrame3], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever)
    }
}
