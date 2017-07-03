//
//  MPCManager.swift
//  AirShare
//
//  Created by Wade Sellers on 2/9/17.
//  Copyright © 2017 InsertCoinProductions. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

protocol MPCManagerDelegate {
    func foundPeer()
    func lostPeer()
    func invitationWasReceived(fromPeer: String)
    func connectedWithPeer(peerID: MCPeerID)
}

class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate,MCNearbyServiceAdvertiserDelegate {

    enum ServiceTypeIdentifier: String {
        case Airshare = "airshare"
    }

    var peer: MCPeerID!
    var session: MCSession!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!

    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession)->Void)!

    var delegate: MPCManagerDelegate?

    override init() {
        super.init()

        peer = MCPeerID(displayName: Host.current().localizedName!)
        session = MCSession(peer: peer)
        session.delegate = self

        browser = MCNearbyServiceBrowser(peer: peer, serviceType: ServiceTypeIdentifier.Airshare.rawValue)
        browser.delegate = self

        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: ServiceTypeIdentifier.Airshare.rawValue)
    }

}
