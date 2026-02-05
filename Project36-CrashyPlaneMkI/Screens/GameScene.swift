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
        createSky()
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
    
    
    func createSky()
    {
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
}
