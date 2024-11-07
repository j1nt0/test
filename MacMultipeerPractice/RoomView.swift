//
//  RoomView.swift
//  MacMultipeerPractice
//
//  Created by Jin Lee on 11/7/24.
//


import SwiftUI

struct RoomView: View {
    
    var multipeerManager: MultipeerManager
    @State private var isFlashlightOn = false
    
    var body: some View {
        ZStack {
            Color(.white)
            VStack {
                Button {
                    isFlashlightOn.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(isFlashlightOn ? .red : .green)
                        Image(systemName: "flashlight.off.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.white)
                    }
                }
                ForEach(multipeerManager.connectedPeers, id: \.self) { peer in
                    VStack {
                        Text("\(peer.displayName)")
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onDisappear {
            multipeerManager.stopAdvertising()
        }
    }
    
}

#Preview {
    RoomView(multipeerManager: .init())
}
