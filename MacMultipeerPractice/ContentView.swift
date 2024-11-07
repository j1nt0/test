//
//  ContentView.swift
//  MacMultipeerPractice
//
//  Created by Jin Lee on 11/7/24.
//

import SwiftUI

struct ContentView: View {
    
    private var multipeerManager = MultipeerManager()
    
    var body: some View {
        VStack {
            HStack {
                ForEach(multipeerManager.foundPeers, id: \.self) { peer in
                    Text(peer.displayName)
                        .onTapGesture {
                            multipeerManager.joinRoom(peerID: peer)
                        }
                }
            }
            HStack {
                Button {
                    multipeerManager.startAdvertising()
                } label: {
                    Text("광고")
                }
                Button {
                    multipeerManager.startBrowsing()
                } label: {
                    Text("찾기")
                }
            }
            HStack {
                ForEach(multipeerManager.connectedPeers, id: \.self) { peer in
                    Text(peer.displayName)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
