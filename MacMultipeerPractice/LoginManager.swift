//
//  LoginManager.swift
//  MacMultipeerPractice
//
//  Created by Jin Lee on 11/8/24.
//

import SwiftUI

@Observable
class LoginManager {
    var nickname: String?
        
    var isLoggedIn: Bool {
        nickname != nil
    }
    
    func saveNickname(_ nickname: String) {
        self.nickname = nickname
    }
    
    func logout() {
        self.nickname = nil
    }
}
