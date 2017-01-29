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
	static let PeerID = MCPeerID(displayName: UIDevice.current.identifierForVendor?.uuidString ?? "")

	let browser: MCNearbyServiceBrowser
	let browserViewController: MCBrowserViewController
	weak var delegate: DiscoveryServiceDelegate?


	init(delegate: DiscoveryServiceDelegate) {
		self.delegate = delegate
		browser = MCNearbyServiceBrowser(peer: DiscoveryService.PeerID, serviceType: DiscoveryService.GameService)
		browserViewController = MCBrowserViewController(browser: browser, session: MCSession(peer: DiscoveryService.PeerID, securityIdentity: nil, encryptionPreference: .none))
		super.init()
		browserViewController.delegate = self
		browserViewController.minimumNumberOfPeers = 1
		browserViewController.maximumNumberOfPeers = 1
		self.delegate?.discoveryService(self, presentBrowserViewController: browserViewController)
		browser.startBrowsingForPeers()
	}

	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		print(browserViewController.session.connectedPeers)
		browserViewController.dismiss(animated: true) {
			self.delegate?.discoveryService(self, didFinishWithSession: browserViewController.session)
		}
	}

	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		browserViewController.dismiss(animated: true) {
		}
	}

	func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
		return true
	}
}
