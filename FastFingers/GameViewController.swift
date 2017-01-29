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
	var instructionView: InstructionView?
	let broadcaster: Bool

	init(withSession session: MCSession, broadcaster: Bool = false) {
		self.session = session
		self.broadcaster = broadcaster
		super.init(nibName: nil, bundle: nil)
		instructionView = createInstructionView()
		session.delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		guard let instructionView = instructionView else { return }
		instructionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(instructionView)
		NSLayoutConstraint.activate([
			instructionView.topAnchor.constraint(equalTo: view.topAnchor),
			instructionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			instructionView.leftAnchor.constraint(equalTo: view.leftAnchor),
			instructionView.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
		self.instructionView = instructionView
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if broadcaster {
			send("start")
			startInstructionTimer()
		}
	}

	func send(_ message: String) {
		guard let data = message.data(using: .ascii) else { return }
		send(data, to: session.connectedPeers)
	}

	func send(_ data: Data, to peers: [MCPeerID]) {
		do {
			try session.send(data, toPeers: peers, with: MCSessionSendDataMode.reliable)
		} catch {
			print("Error \(error)")
		}
	}

	func receive(_ data: Data, from: MCPeerID) {
		let message = parse(data)
		switch message {
		case "start":
			startInstructionTimer()
		default:
			break
		}
	}

	func parse(_ data: Data) -> String {
		return String(bytes: data, encoding: .ascii) ?? ""
	}

	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		if session.connectedPeers.count > 1 {
			let destinations = session.connectedPeers.filter { $0 != peerID || $0 != DiscoveryService.PeerID }
			send(data, to: destinations)
		}
		DispatchQueue.main.async {
			self.receive(data, from: peerID)
		}
	}

	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {

	}

	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

	}

	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

	}

	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {

	}

	func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
		certificateHandler(true)
	}

	func createInstructionView() -> InstructionView {
		return InstructionView(title: "", instructions: "", participants: [])
	}

	func startInstructionTimer() {
		Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
			guard let instructionView = self.instructionView else { return }
			instructionView.time -= 1
			if instructionView.time <= 0 {
				timer.invalidate()
				DispatchQueue.main.async {
					UIView.animate(withDuration: 0.33, animations: {
						instructionView.alpha = 0.0
					}, completion: { _ in
						self.startGame()
					})
				}

			}
		}
	}

	func startGame() {

	}
}
