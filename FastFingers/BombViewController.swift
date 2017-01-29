//
//  BombView.swift
//  FastFingers
//
//  Created by Nikola Draca on 2017-01-29.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//
import Foundation
import UIKit
import MultipeerConnectivity

class BombViewController: GameViewController {
	var finished = false

	var gameView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var bombView = UIImageView(image: UIImage(named: "bomb"))
    var ticker = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

	override func createInstructionView() -> InstructionView {
		return InstructionView(title: "Tick, tock", instructions: "Slide the bomb off your screen to give it to a friend. Don't be the last one holding onto it when it goes off!", participants: session.connectedPeers.map({ $0.displayName }))
	}

	override func startGame() {

		let title = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.2 * UIScreen.main.bounds.height))
		title.text = "Tick, tock"
		title.font = UIFont(name: "AvenirNext-Medium", size: 30)
		title.textAlignment = .center

		ticker.backgroundColor = UIColor(red:1.00, green:0.77, blue:0.54, alpha:1.0)

		bombView.isUserInteractionEnabled = true


		gameView.addSubview(ticker)
		gameView.addSubview(title)


		gameView.alpha = 0.0
		view.addSubview(gameView)

		UIView.animate(withDuration: 0.33, animations: { 
			self.gameView.alpha = 1.0
		}) { _ in
			if self.broadcaster {
				self.receiveBomb()
			}
			self.startTicker()
		}
	}

	func startTicker() {
		UIView.animate(withDuration: 5, delay: 0, options: .curveLinear, animations: {
			self.ticker.center.y = UIScreen.main.bounds.height + self.ticker.frame.height / 2
		}, completion: { _ in
			self.determineWinner()
		})
	}

	func passBomb(from peer: MCPeerID) {
		if broadcaster {
			let destinations = (session.connectedPeers + [session.myPeerID]).filter( { $0 != peer } )
			let index = Int(arc4random_uniform(UInt32(destinations.count)))
			let destination = destinations[index]
			if destination == session.myPeerID {
				receiveBomb()
			} else {
				sendSingleMessage("receive-bomb", to: destination)
			}
		} else {
			sendBroadcastMessage("pass-bomb")
		}
	}

	func receiveBomb() {
		gameView.addSubview(self.bombView)
		bombView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panned(gestureRecognizer:))))
		bombView.center = gameView.center
	}

	override func receive(_ message: String, from: MCPeerID) {
		switch message {
		case "receive-bomb":
			receiveBomb()
		case "pass-bomb":
			if broadcaster {
				passBomb(from: from)
			}
		case "win":
			if broadcaster {
				for winner in session.connectedPeers.filter({ $0 != from }) {
					sendSingleMessage("win", to: winner)
				}
			}
			won()
		default:
			super.receive(message, from: from)
		}
	}

	func panned(gestureRecognizer: UIPanGestureRecognizer) {
		guard !finished else { return }
		switch gestureRecognizer.state {
		case .began, .changed:
			let location = gestureRecognizer.location(in: gameView)
			bombView.center = location

			if (location.x < 0.1*(UIScreen.main.bounds.width)) {
				UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
					self.bombView.center.x -= 200
				}, completion: { _ in
					self.bombView.removeFromSuperview()
					self.passBomb(from: self.session.myPeerID)
				})
			}

			else if (location.x > 0.9*(UIScreen.main.bounds.width)) {
				UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
					self.bombView.center.x += 200
				}, completion: { _ in
					self.bombView.removeFromSuperview()
					self.passBomb(from: self.session.myPeerID)
				})
			}

		default:
			break
		}
	}

	func determineWinner() {
		finished = true
		let delayTime = DispatchTime.now() + .seconds(2)
		DispatchQueue.main.asyncAfter(deadline: delayTime) {
			if self.bombView.superview != nil {
				self.lost()
				self.sendBroadcastMessage("win")
			}
		}
	}
}
