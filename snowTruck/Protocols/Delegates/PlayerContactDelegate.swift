//
//  PlayerContactDelegate.swift
//  snowTruck
//
//  Created by Henrique Semmer on 26/03/24.
//

import Foundation

protocol PlayerContactDelegate: AnyObject {
    func gameOver()
    func moveLandslideUp()
    func reduceSpeed()
    
    func reduceGas()
    
    func addCoin(object: ObjectNode)
    func addGas(object: ObjectNode)
}
