//
//  CGSize+Ext.swift
//  snowTruck
//
//  Created by Henrique Semmer on 15/04/24.
//

import Foundation

extension CGSize {
    func reduceMultiplied(lhs: CGSize, rhs: Double) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}
