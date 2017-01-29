//
//  BroadcastService.swift
//  FastFingers
//
//  Created by Ryan Billard on 2017-01-28.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Foundation

protocol BroadcastServiceDelegate: class {
	func broadcastService(_ service: BroadcastService, receivedConnectionFromPeer peer: String) -> Void
}

class BroadcastService: NSObject, MCNearbyServiceAdvertiserDelegate {
	static let GameService = "fastfinger-game"
	static let PeerID = MCPeerID(displayName: UIDevice.current.name)
	let advertiser: MCNearbyServiceAdvertiser
	let session: MCSession
	weak var delegate: BroadcastServiceDelegate?

	override init() {
		advertiser = MCNearbyServiceAdvertiser(peer: BroadcastService.PeerID, discoveryInfo: nil, serviceType: BroadcastService.GameService)
		session = MCSession(peer: BroadcastService.PeerID)
		super.init()
		advertiser.delegate = self
		advertiser.startAdvertisingPeer()
	}

	func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {

	}

	func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
		guard session.connectedPeers.count < 4 else {
			invitationHandler(false, nil)
			return
		}
		delegate?.broadcastService(self, receivedConnectionFromPeer: peerID.displayName)
		invitationHandler(true, session)
	}
}

