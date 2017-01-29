//
//  GameCountdownViewController.swift
//  FastFingers
//
//  Created by Ryan Billard on 2017-01-29.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import UIKit

class GameCountdownViewController: UIViewController, BroadcastServiceDelegate {
	var broadcastService: BroadcastService?
	let usersList = UIStackView()
	let timerLabel = UILabel()
	var time = 10


	override func viewDidLoad() {
		super.viewDidLoad()
        
		view.backgroundColor = .white
		broadcastService = BroadcastService()
		broadcastService?.delegate = self
		let title = UILabel()
		title.text = "Connected Users:"
		usersList.addArrangedSubview(title)
		usersList.axis = .vertical
		usersList.distribution = .equalSpacing
		usersList.alignment = .center

		let stackView = UIStackView(arrangedSubviews: [timerLabel, usersList])
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.backgroundColor = .white
		view.addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.topAnchor),
			stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
			stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			])
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
			self.timerLabel.text = "\(self.time)"
			self.time -= 1
			if self.time <= 0 {
				timer.invalidate()
				self.startGame()
			}
		})
		timer.fire()
	}

	func broadcastService(_ service: BroadcastService, receivedConnectionFromPeer peer: String) {
		print("connected from \(peer)")
		let label = UILabel()
		label.text = peer
		usersList.addArrangedSubview(label)
	}

	func startGame() {
		guard let broadcastService = self.broadcastService, broadcastService.session.connectedPeers.count >= 1 else { return }
		let gameVC = BombViewController(withSession: broadcastService.session, broadcaster: true)
		self.present(gameVC, animated: true) {

		}
	}

}
