//
//  ConnectionManager.swift
//  AirShare
//
//  Created by Wade Sellers on 8/27/16.
//  Copyright © 2016 InsertCoinProductions. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

class ConnectionManager: NSObject {

    // Maybe the passphrase?
    private var serviceType = "Wade-AirShare"

    // What will be displayed in Bonjour
    private let myPeerId = MCPeerID(displayName: NSHost.currentHost().localizedName ?? "Default")

    // What broadcasts a service on Bonjour
    private let serviceAdvertiser : MCNearbyServiceAdvertiser

    // What looks for a service
    private let serviceBrowser : MCNearbyServiceBrowser

    private var discovery = [String:String]()

    // This enables and manages communication between peers in session
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        session.delegate = self
        return session
    }()

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

}

// MARK: - Advertiser Delegate
extension ConnectionManager : MCNearbyServiceAdvertiserDelegate {
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("did not start advertising peer because of error: \(error)")
    }

    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        print("received invitation from peer: \(peerID)")
        invitationHandler(true, session)
    }
}

// MARK: - Browser Delegate
extension ConnectionManager : MCNearbyServiceBrowserDelegate {
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print("didn't start browsing for peers because of error: \(error)")
    }

    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found Peer with Id: \(peerID)")
        print("Invite Peer with Id: \(peerID)")
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
    }

    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer with ID: \(peerID)")
    }

}

// discovers the state of our session
extension MCSessionState {

    func stringValue() -> String {
        switch(self) {
        case .NotConnected: return "Not Connected"
        case .Connecting: return "Connecting"
        case .Connected: return "Connected"
        }
    }
}

extension ConnectionManager : MCSessionDelegate {
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        print("peer: \(peerID) didChangeState: \(state.stringValue())")
    }

    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        print("Did receive date: \(data)")
    }

    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Did receive stream: \(stream)")
    }

    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        print("Did finish receiving resource with name \(resourceName)")
    }

    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        print("Did start receiving resource with name \(resourceName)")
    }
}
