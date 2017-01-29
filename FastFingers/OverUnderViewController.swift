//
//  OverUnderViewController.swift
//  FastFingers
//
//  Created by Ryan Billard on 2017-01-29.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//

import Foundation
import UIKit

class OverUnderViewController: GameViewController {
	override func createInstructionView() -> InstructionView {
		return InstructionView(title: "Over Under", instructions: "You have a deck of cards with 4 suits ranging from 1 to 10. Each player is assigned five cards, and for each card must guess if the next card drawn from the deck will be higher or lower. Get it right and you move on to your next card. Get it wrong and you head back to the start. First to get through all five of their cards wins!", participants: session.connectedPeers.map({ $0.displayName }))
	}

	override func startGame() {
		super.startGame()
		
	}
}
