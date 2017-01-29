//
//  OverUnderViewController.swift
//  FastFingers
//
//  Created by Ryan Billard on 2017-01-29.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import UIKit

class OverUnderViewController: GameViewController {
	let gameView = OverUnderView()

	var winners: [MCPeerID] = []
	var done = false
	var deck = Deck()
	var cards: [Int] = [] {
		didSet {
			updateCardView()
		}
	}
	var index = 0 {
		didSet {
			updateCardView()
		}
	}

	func updateCardView() {
		guard cards.count == gameView.smallCards.count else { return }
		for (i, label) in gameView.smallCards.enumerated() {
			label.text = "\(cards[i])"
			if i < index {
				label.backgroundColor = UIColor.green.withAlphaComponent(0.5)
			} else if i == index {
				label.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
			} else {
				label.backgroundColor = .white
			}
		}
		guard index < cards.count else { return }
		gameView.mainCard.text = "\(cards[index])"
	}


	override func createInstructionView() -> InstructionView {
		return InstructionView(title: "Over Under", instructions: "You have a deck of cards ranging from 1 to 10. Each player is assigned five cards, and for each card must guess if the next card drawn from the deck will be higher or lower. Get it right and you move on to your next card. Get it wrong and you head back to the start. First to get through all five of their cards wins!", participants: session.connectedPeers.map({ $0.displayName }))
	}

	override func startGame() {
		super.startGame()
		gameView.lowerButton.addTarget(self, action: #selector(lower), for: .touchUpInside)
		gameView.higherButton.addTarget(self, action: #selector(higher), for: .touchUpInside)

		cards = [deck.drawCard(), deck.drawCard(), deck.drawCard(), deck.drawCard(), deck.drawCard()]
		gameView.alpha = 0.0
		gameView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(gameView)
		NSLayoutConstraint.activate([
			gameView.topAnchor.constraint(equalTo: view.topAnchor),
			gameView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			gameView.leftAnchor.constraint(equalTo: view.leftAnchor),
			gameView.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
		UIView.animate(withDuration: 0.33) { 
			self.gameView.alpha = 1.0
		}
	}

	dynamic private func lower() {
		guard !done else { return }
		let new = deck.drawCard()
		let old = cards[index]
		cards[index] = new
		if new < old {
			if index == cards.count - 1 {
				finished()
			} else {
				index += 1
			}
		} else {
			index = 0
		}
	}

	dynamic private func higher() {
		guard !done else { return }
		let new = deck.drawCard()
		let old = cards[index]
		cards[index] = new
		if new > old {
			if index == cards.count - 1 {
				finished()
			} else {
				index += 1
			}
		} else {
			index = 0
		}
	}

	func finished() {
		done = true
		if broadcaster {
			recordWinner(session.myPeerID)
		} else {
			sendBroadcastMessage("finished")
		}
	}

	func recordWinner(_ winner: MCPeerID) {
		guard broadcaster else { return }
		if winner == session.myPeerID {
			won()
		} else {
			lost()
			sendSingleMessage("won", to: winner)
		}
		for loser in session.connectedPeers.filter({ $0 != winner && $0 != session.myPeerID }) {
			sendSingleMessage("lost", to: loser)
		}
	}

	override func receive(_ message: String, from: MCPeerID) {
		switch message {
		case "finished":
			recordWinner(from)
		default:
			super.receive(message, from: from)
		}
	}
}

struct Deck {
	var cards: [Int]

	init() {
		cards = Deck.newDeck()
	}

	static func newDeck() -> [Int] {
		var deck: [Int] = []
		for i in 1...10 {
			for _ in 0...4 {
				deck.append(i)
			}
		}
		return deck
	}

	mutating func drawCard() -> Int {
		if cards.count <= 0 {
			cards = Deck.newDeck()
		}
		let index = Int(arc4random_uniform(UInt32(cards.count)))
		return cards.remove(at: index)
	}
}
