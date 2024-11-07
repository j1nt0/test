//
//  MainViewModel.swift
//  MacMultipeerPractice
//
//  Created by Jin Lee on 11/8/24.
//

import Foundation

@Observable
class MainViewModel {
    var appTrackingManager = AppTrackingManager()
    var multipeerManager = MultipeerManager()
    var loginManager = LoginManager()
}
