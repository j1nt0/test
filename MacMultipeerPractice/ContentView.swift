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
        NavigationStack {
            ZStack {
                Color(.black)
                VStack(spacing: 30) {
                    NavigationLink {
                        RoomView(multipeerManager: multipeerManager)
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 100)
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 100)
                    .simultaneousGesture(TapGesture().onEnded {
                        multipeerManager.startAdvertising()
                    })
                    VStack(spacing: 30) {
                        ForEach(multipeerManager.foundPeers, id: \.self) { peerID in
                            NavigationLink {
                                RoomView(multipeerManager: multipeerManager)
                            } label: {
                                if multipeerManager.myPeerID != peerID {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(height: 100)
                                            .foregroundStyle(.white)
                                        Text("\(peerID.displayName)")
                                    }
                                }
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                multipeerManager.joinRoom(peerID: peerID)
                            })
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .ignoresSafeArea()
            .onAppear {
                multipeerManager.disconnect()
                multipeerManager.startBrowsing()
            }
        }
    }
}

#Preview {
    ContentView()
}
