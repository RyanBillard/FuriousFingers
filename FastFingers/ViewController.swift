//
//  ViewController.swift
//  FastFingers
//
//  Created by Ryan Billard on 2017-01-28.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, DiscoveryServiceDelegate {
	let createGameButton = UIButton(type: UIButtonType.roundedRect)
	let joinGameButton = UIButton(type: UIButtonType.roundedRect)
	var discoveryService: DiscoveryService?

	override func viewDidLoad() {
		super.viewDidLoad()
        
        let alert = UIAlertController(title: "Skin Type", message: "Please Choose Skin Type", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Fair Skin", style: .default, handler: { (action) in
            //execute some code when this option is selected
            print("Fair Skin")
        }))
        alert.addAction(UIAlertAction(title: "Dark Skin", style: .default, handler: { (action) in
            //execute some code when this option is selected
            print("Dark Skin")
        }))
        
        
        present(alert, animated: true, completion: nil)
        
		createGameButton.backgroundColor = .green
		createGameButton.setTitle("Create Game", for: .normal)
		createGameButton.addTarget(self, action: #selector(createGame), for: .touchUpInside)
		joinGameButton.backgroundColor = .blue
		joinGameButton.setTitle("Join Game", for: .normal)
		joinGameButton.addTarget(self, action: #selector(joinGame), for: .touchUpInside)
		let stackView = UIStackView(arrangedSubviews: [createGameButton, joinGameButton])
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		view.addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.centerYAnchor),
			stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
			stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	dynamic private func joinGame() {
		discoveryService = DiscoveryService(delegate: self)
	}

	dynamic private func createGame() {
		let countdownVC = GameCountdownViewController(nibName: nil, bundle: nil)
		present(countdownVC, animated: true) { 

		}
	}

	func discoveryService(_ service: DiscoveryService, presentBrowserViewController controller: UIViewController) {
		self.present(controller, animated: true) { 

		}
	}

}

