//
//  ObstacleContactDelegate.swift
//  snowTruck
//
//  Created by Henrique Semmer on 26/03/24.
//

import SpriteKit

protocol ObstacleContactDelegate: AnyObject {
    func deleteObstacle(obstacle: SKShapeNode)
}
