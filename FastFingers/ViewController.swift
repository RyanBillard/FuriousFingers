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

        view.backgroundColor = UIColor.white

		let logoLabel = UILabel(frame: CGRect(x: 0, y: 80 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5))

		logoLabel.text = "Furious Fingers"
		logoLabel.textColor = UIColor.black
		logoLabel.font = UIFont(name: "AvenirNext-Medium", size: 45)
		logoLabel.textAlignment = .center

		let logoImg = UIImage(named: "hourglass")
		let logoImgView = UIImageView(image: logoImg)
		logoImgView.frame = CGRect(x: logoLabel.bounds.width/2 - 50, y: 120, width: 100, height: 100)

		logoLabel.addSubview(logoImgView)
		self.view.addSubview(logoLabel)

		createGameButton.backgroundColor = UIColor.black
		createGameButton.titleLabel?.textColor = UIColor.white
		createGameButton.tintColor = UIColor.white
		createGameButton.clipsToBounds = true
		createGameButton.layer.cornerRadius = 10
		createGameButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20)
		createGameButton.setTitle("Create Game", for: .normal)
		createGameButton.addTarget(self, action: #selector(createGame), for: .touchUpInside)

		joinGameButton.backgroundColor = UIColor.black
		joinGameButton.titleLabel?.textColor = UIColor.white
		joinGameButton.tintColor = UIColor.white
		joinGameButton.clipsToBounds = true
		joinGameButton.layer.cornerRadius = 10
		joinGameButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20)
		joinGameButton.setTitle("Join Game", for: .normal)
		joinGameButton.addTarget(self, action: #selector(joinGame), for: .touchUpInside)

		let stackView = UIStackView(arrangedSubviews: [createGameButton, joinGameButton])
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.spacing = 30
		view.addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 75),
			stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 55),
			stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -55),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75)
			])
	}

//	override func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear(animated)
//
//		// Check if nickname is in UserDefaults
//		let defaults = UserDefaults.standard
//
//		if let name = defaults.string(forKey: "nickname") {
//			print(name)
//		}
//
//		else {
//			let alert = UIAlertController(title: "Name", message: "Please choose a nickname", preferredStyle: .alert)
//
//			alert.addTextField { (textField) in
//				textField.text = "Your name"
//			}
//
//			alert.addAction(UIAlertAction(title: "Go", style: .default, handler: { (action) in
//
//				// Add to db
//				var request = URLRequest(url: URL(string: "https://furiousfingers.herokuapp.com/users")!)
//				request.httpMethod = "POST"
//
//				let device_id = UIDevice.current.identifierForVendor!.uuidString
//				let nickname = alert.textFields![0]
//				let postString = "device_id=" + String(device_id)! + "&nickname=" + nickname.text!
//
//				request.httpBody = postString.data(using: .utf8)
//				let task = URLSession.shared.dataTask(with: request) { data, response, error in
//					guard let data = data, error == nil else {
//						print("error=\(error)")
//						return
//					}
//
//					if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {                         print("statusCode should be 200, but is \(httpStatus.statusCode)")
//						print("response = \(response)")
//					}
//
//					let responseString = String(data: data, encoding: .utf8)
//					print("responseString = \(responseString)")
//				}
//				task.resume()
//
//				// Set default
//				defaults.set(nickname.text, forKey: "nickname")
//
//
//			}))
//
//			self.present(alert, animated: true, completion: nil)
//		}
//	}


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

	func discoveryService(_ service: DiscoveryService, didFinishWithSession session: MCSession) {
		let gameVC = OverUnderViewController(withSession: session)
		present(gameVC, animated: true) {

		}
	}
}

