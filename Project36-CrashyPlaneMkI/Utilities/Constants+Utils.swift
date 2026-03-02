//  File: Constants+Utils.swift
//  Project: Project36-CrashyPlaneMkI
//  Created by: Noah Pope on 2/3/26import Foundation

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
    
    static let ladybug = "ladybug"
    static let ladybugFly = "ladybugFly"
}

enum NameKeys
{
    static let player = "player"
    static let ladybug = "ladybug"
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

enum EmitterKeys
{
    static let destroyPlayer = "destroyPlayer.sks"
    static let consumeLadybug = "consumeLadybug.sks"
}

enum SoundKeys
{
    static let coinWav = "coin.wav"
    static let destroyPlayerWav = "explosion.wav"
}
