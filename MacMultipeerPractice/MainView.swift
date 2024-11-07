//
//  MainView.swift
//  MacMultipeerPractice
//
//  Created by Jin Lee on 11/7/24.
//

import SwiftUI

struct MainView: View {
    
    var vm = MainViewModel()
    
    var body: some View {
        VStack {
            if vm.loginManager.isLoggedIn {
                MainMainView(vm: vm)
            } else {
                LoginView(vm: vm)
            }
        }
        .frame(width: 300, height: 200)
    }
    
    func LogOutButton() -> some View {
        Button {
            vm.loginManager.logout()
            print(vm.loginManager.isLoggedIn)
        } label: {
            Text("로그아웃")
        }
    }
}

struct LoginView: View {
    @State private var nickname: String = ""
    var vm: MainViewModel

    var body: some View {
        VStack(spacing: 30) {
            TextField("Enter Nickname", text: $nickname)
            
            Button {
                vm.loginManager.saveNickname(nickname)
                vm.multipeerManager.changePeerID(displayName: nickname)
            } label: {
                Text("접속")
            }
            .disabled(nickname.isEmpty)
        }
        .padding()
    }
}

struct MainMainView: View {
    
    var vm: MainViewModel
    
    var body: some View {
        VStack {
            HStack {
                ForEach(vm.multipeerManager.foundPeers, id: \.self) { peer in
                    Text(peer.displayName)
                        .onTapGesture {
                            vm.multipeerManager.joinRoom(peerID: peer)
                        }
                }
            }
            HStack {
                Button {
                    vm.multipeerManager.startAdvertising()
                } label: {
                    Text("광고")
                }
                Button {
                    vm.multipeerManager.startBrowsing()
                } label: {
                    Text("검색")
                }
            }
            ForEach(vm.multipeerManager.connectedPeers, id: \.self) { peer in
                Text(peer.displayName)
            }
            Text(vm.multipeerManager.currentApp ?? "No App")
        }
    }
}
