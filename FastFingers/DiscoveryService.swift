//
//  DiscoveryService.swift
//  FastFingers
//
//  Created by Ryan Billard on 2017-01-28.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol DiscoveryServiceDelegate: class {
	func discoveryService(_ service: DiscoveryService, presentBrowserViewController controller: UIViewController)
	func discoveryService(_ service: DiscoveryService, didFinishWithSession session: MCSession)
}


class DiscoveryService: NSObject, MCBrowserViewControllerDelegate {
	static let GameService = "fastfinger-game"
	static let PeerID = MCPeerID(displayName: UIDevice.current.name)

	let browser: MCNearbyServiceBrowser
	let browserViewController: MCBrowserViewController
	weak var delegate: DiscoveryServiceDelegate?


	init(delegate: DiscoveryServiceDelegate) {
		self.delegate = delegate
		browser = MCNearbyServiceBrowser(peer: DiscoveryService.PeerID, serviceType: DiscoveryService.GameService)
		browserViewController = MCBrowserViewController(browser: browser, session: MCSession(peer: DiscoveryService.PeerID))
		super.init()
		browserViewController.delegate = self
		browserViewController.minimumNumberOfPeers = 1
		browserViewController.maximumNumberOfPeers = 1
		self.delegate?.discoveryService(self, presentBrowserViewController: browserViewController)
		browser.startBrowsingForPeers()
	}

	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		print(browserViewController.session.connectedPeers)
		browser.stopBrowsingForPeers()
		browserViewController.dismiss(animated: true) {

		}
	}

	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		browser.stopBrowsingForPeers()
		browserViewController.dismiss(animated: true) { 
			self.delegate?.discoveryService(self, didFinishWithSession: browserViewController.session)
		}
	}

	func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
		return true
	}
}
