//
//  MultipeerManager.swift
//  MacMultipeerPractice
//
//  Created by Jin Lee on 11/7/24.
//

import MultipeerConnectivity
import Foundation

@Observable
class MultipeerManager: NSObject {
    // 내 피어 ID
    var myPeerID = MCPeerID(displayName: "dd")
    
    // 서비스 타입
    let serviceType = "flashlight" // 서비스 타입은 고유해야 합니다.
    
    // 세션, 광고자, 브라우저 초기화
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    // 발견된 피어와 연결된 피어를 관리
    var foundPeers: [MCPeerID] = []
    var connectedPeers: [MCPeerID] = []
    var isAdvertising = false
    var isBrowsing = false
    
    override init() {
        super.init()
        
        myPeerID = MCPeerID(displayName: "peer\(Int.random(in: 1...100))")
        
        // 세션 초기화
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        // 광고자 설정
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        
        // 브라우저 설정
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser.delegate = self
    }
    
    // 광고 시작
    func startAdvertising() {
        advertiser.startAdvertisingPeer()
        isAdvertising = true
    }
    
    // 광고 중지
    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
        isAdvertising = false
    }
    
    // 브라우징 시작
    func startBrowsing() {
        browser.startBrowsingForPeers()
        isBrowsing = true
    }
    
    // 브라우징 중지
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
        isBrowsing = false
    }
    
    // 방에 참여
    func joinRoom(peerID: MCPeerID) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func sendAppInfo(appName: String) {
        let appData = appName.data(using: .utf8)
        
        for peerID in connectedPeers {
            do {
                try session.send(appData!, toPeers: [peerID], with: .reliable)
            } catch {
                print("Error sending app info: \(error)")
            }
        }
    }
    
    // 연결 끊기
    func disconnect() {
        // 모든 연결된 피어와의 연결 끊기
        session.disconnect()
        
        // 연결된 피어 목록을 비우기
        connectedPeers.removeAll()
    }
}

// MARK: - MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate

extension MultipeerManager: MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    // 세션 상태 변화 감지
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            if state == .connected {
                if !self.connectedPeers.contains(peerID) {
                    self.connectedPeers.append(peerID)
                }
            } else if state == .notConnected {
                self.connectedPeers.removeAll { $0 == peerID }
            }
        }
    }
    
    // 데이터 수신
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
            if let appName = String(data: data, encoding: .utf8) {
                // 받은 앱 이름을 출력하거나 처리
                print("Received app info: \(appName) from \(peerID.displayName)")
            }
        }
    
    // 오류 처리
    func session(_ session: MCSession, didFailWithError error: Error) {
        print("Session failed with error: \(error.localizedDescription)")
    }
    
    // 연결된 피어로부터의 스트림 수신
    func session(_ session: MCSession, didReceive stream: InputStream, fromPeer peerID: MCPeerID) {}
    
    // 리소스 수신 시작 및 완료
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    // 브라우저에서 피어 발견
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if !self.foundPeers.contains(peerID) {
                self.foundPeers.append(peerID)
            }
        }
    }
    
    // 브라우저에서 피어 연결 끊김
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.foundPeers.removeAll { $0 == peerID }
        }
    }

    // 초대 요청 수락
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session) // 초대 수락
    }
}
