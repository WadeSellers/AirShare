//
//  OutgoingConnectionManager.swift
//  AirShare
//
//  Created by Wade Sellers on 8/27/16.
//  Copyright © 2016 InsertCoinProductions. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

class OutgoingConnectionManager: NSObject {

    private var serviceType : String
    private let myPeerId = MCPeerID(displayName: NSHost.currentHost().localizedName ?? "Default")
    private let serviceAdvertiser : MCNearbyServiceAdvertiser

    init(passPhrase: String) {
        self.serviceType = passPhrase
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: self.serviceType)
        super.init()
        serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
    }

    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }

    func stopAdvertising() {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }

}

extension OutgoingConnectionManager : MCNearbyServiceAdvertiserDelegate {
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("did not start advertising peer because of error: \(error)")
    }

    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        print("received invitation from peer: \(peerID)")
    }
}
