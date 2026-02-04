//  File: SKScene+Ext.swift
//  Project: Project36-CrashyPlaneMkI
//  Created by: Noah Pope on 2/4/26.

import UIKit
import SpriteKit

extension SKScene
{
    func addChildren(_ nodes: SKNode...)
    {
        for node in nodes {
            self.addChild(node)
        }
    }
}
