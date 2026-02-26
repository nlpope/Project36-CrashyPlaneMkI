//  File: Constants+Utils.swift
//  Project: Project36-CrashyPlaneMkI
//  Created by: Noah Pope on 2/3/26.

import Foundation

enum CollisionBitMasks: UInt32
{
    /** raw values for physics body bitmasks should be
     integers that are double the value of the previous case */
    case player = 1
    case rockObstacle = 2
    case ground = 4
}

enum TextureKeys
{
    static let logo = "logo"
    static let gameOver = "gameover"

    static let heliFrame1 = "heliFrame1"
    static let heliFrame2 = "heliFrame2"
    static let heliFrame3 = "heliFrame3"
    
    static let background = "background"
    static let ground = "ground"
    static let rockObstacle = "rock"
    static let cactusObstacle = "cactus"
}

enum NameKeys
{
    static let player = "player"
    static let ground = "ground"
    static let rock = "rock"
    static let cactus = "cactus"
    static let goalPost = "goalPost"
    static let gameScene = "GameScene"
}

enum FontKeys
{
    static let optimaExtraBlack = "optima-ExtraBlack"
}

enum SoundKeys
{
    static let coinWav = "coin.wav"
    static let explosionWav = "explosion.wav"
}

enum EmitterKeys
{
    static let playerExplosion = "PlayerExplosion.sks"
    static let spark = "spark.png"
}
