//
//  InstructionView.swift
//  FastFingers
//
//  Created by Ryan Billard on 2017-01-29.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//

import Foundation
import UIKit

class InstructionView: UIView {
	let titleLabel = UILabel()
	let instructionsLabel = UILabel()
	let participantsLabel = UILabel()
	let timerLabel = UILabel()
	var time = 4.0 {
		didSet {
			timerLabel.text = "\(time)"
		}
	}

	init(title: String, instructions: String, participants: [String]) {
		super.init(frame: CGRect.zero)
		backgroundColor = .white
		titleLabel.text = title
		titleLabel.numberOfLines = 0
		instructionsLabel.text = instructions
		instructionsLabel.numberOfLines = 0
		participantsLabel.text = participants.joined(separator: "\n")
		participantsLabel.textAlignment = .left
		participantsLabel.numberOfLines = 0
		timerLabel.text = "\(time)"
		timerLabel.textAlignment = .right

		let bottomStack = UIStackView(arrangedSubviews: [participantsLabel, timerLabel])
		bottomStack.axis = .horizontal
		bottomStack.alignment = .bottom
		bottomStack.distribution = .fill

		let mainStack = UIStackView(arrangedSubviews: [UIView(), titleLabel, instructionsLabel, bottomStack])
		mainStack.axis = .vertical
		mainStack.distribution = UIStackViewDistribution.fillProportionally
		mainStack.alignment = .center
		mainStack.translatesAutoresizingMaskIntoConstraints = false

		addSubview(mainStack)

		NSLayoutConstraint.activate([
			mainStack.topAnchor.constraint(equalTo: topAnchor),
			mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
			mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
			mainStack.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}



	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
