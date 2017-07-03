//
//  ConnectionManager.swift
//  AirShare
//
//  Created by Wade Sellers on 8/27/16.
//  Copyright © 2016 InsertCoinProductions. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

protocol ConnectionManagerDelegate {
    func connectedDevicesChanged(_ manager : ConnectionManager, connectedDevices: [String])
    func fileAvailable(_ manager : ConnectionManager, fileName: String)
}

class ConnectionManager: NSObject {

    // Maybe the passphrase?
    fileprivate var serviceType = "Wade-AirShare"

    // What will be displayed in Bonjour
    fileprivate let myPeerId = MCPeerID(displayName: Host.current().localizedName ?? "Default")

    // What broadcasts a service on Bonjour
    fileprivate let serviceAdvertiser : MCNearbyServiceAdvertiser

    // What looks for a service
    fileprivate let serviceBrowser : MCNearbyServiceBrowser

    fileprivate var discovery = [String:String]()

    // This enables and manages communication between peers in session
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.required)
        session.delegate = self
        return session
    }()

    var delegate : ConnectionManagerDelegate?

    // MARK: - Object Lifecycle
    override init() {
        // Initializers
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: discovery, serviceType: self.serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: self.serviceType)
        super.init()

        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self

    }

    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }

    func startServices() {
        discovery["Awesome"] = "Possum"
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }

    func stopServices() {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }

//    func advertiseMe() {
//        This may not be needed yet.
//    }

  // TODO: Here we will provide the function for passing data through to receiving user
    func sendFile(_ fileName : String) {
//        if session.connectedPeers.count > 0 {
//            var error : NSError?
//            if !session.send
//        }
    }

}

// MARK: - Advertiser Delegate
extension ConnectionManager : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("did not start advertising peer because of error: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("received invitation from peer: \(peerID)")
        invitationHandler(true, session)
    }
}

// MARK: - Browser Delegate
extension ConnectionManager : MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didn't start browsing for peers because of error: \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found Peer with Id: \(peerID)")
        print("Invite Peer with Id: \(peerID)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer with ID: \(peerID)")
    }

}

// discovers the state of our session
extension MCSessionState {

    func stringValue() -> String {
        switch(self) {
        case .notConnected: return "Not Connected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        }
    }
}

extension ConnectionManager : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer: \(peerID) didChangeState: \(state.stringValue())")
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Did receive date: \(data)")
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Did receive stream: \(stream)")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print("Did finish receiving resource with name \(resourceName)")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Did start receiving resource with name \(resourceName)")
    }
}
