//
//  IncomingConnectionManager.swift
//  AirShare
//
//  Created by Wade Sellers on 8/27/16.
//  Copyright © 2016 InsertCoinProductions. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

class IncomingConnectionManager: NSObject {

    private var serviceType : String
    private let myPeerId = MCPeerID(displayName: NSHost.currentHost().localizedName ?? "Default")
    private let serviceBrowser : MCNearbyServiceBrowser

    init(passPhrase: String) {
        self.serviceType = passPhrase
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        super.init()
        serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }

    deinit {
        self.serviceBrowser.stopBrowsingForPeers()
    }

    func stopBrowsing() {
        self.serviceBrowser.stopBrowsingForPeers()
    }

}

extension IncomingConnectionManager : MCNearbyServiceBrowserDelegate {
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print("didn't start browsing for peers because of error: \(error)")
    }

    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found Peer with Id: \(peerID)")
    }

    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer with ID: \(peerID)")
    }
}
