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
                
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let playerTexture = SKTexture(imageNamed: PlayerKeys.player1)
        //testing push
    }
}
