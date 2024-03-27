//
//  UserInfo.swift
//  snowTruck
//
//  Created by Henrique Semmer on 27/03/24.
//

import Foundation

class UserInfo: ObservableObject {
    
    static let shared = UserInfo()
    
    @Published var totalCoins = 0
    
}
