//
//  GameViewController.swift
//  FastFingers
//
//  Created by Ryan Billard on 2017-01-29.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GameViewController: UIViewController, MCSessionDelegate {
	let session: MCSession

	init(withSession session: MCSession) {
		self.session = session
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func send(_ data: Data, to peers: [MCPeerID]) {
		do {
			try session.send(data, toPeers: peers, with: MCSessionSendDataMode.reliable)
		} catch {
			print("Error \(error)")
		}
	}

	func receive(_ data: Data, from: MCPeerID) {

	}

	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		if session.connectedPeers.count > 1 {
			let destinations = session.connectedPeers.filter { $0 != peerID || $0 != DiscoveryService.PeerID }
			send(data, to: destinations)
		}
		receive(data, from: peerID)
	}

	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {

	}

	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

	}

	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

	}

	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {

	}
}
