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
	var time = 12.0 {
		didSet {
			timerLabel.text = "\(time)"
		}
	}

	init(title: String, instructions: String, participants: [String]) {
		super.init(frame: CGRect.zero)
		backgroundColor = .white
		titleLabel.text = title
		titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 40)
        
        let logoImg = UIImage(named: "faq")
        let logoImgView = UIImageView(image: logoImg)
        logoImgView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 50, y: 120, width: 70, height: 70)
        logoImgView.contentMode = .scaleAspectFit

        
		instructionsLabel.text = instructions
		instructionsLabel.numberOfLines = 0
        
		participantsLabel.text = participants.joined(separator: "\n")
		participantsLabel.textAlignment = .left
		participantsLabel.numberOfLines = 0
        
		timerLabel.text = "\(time)"
		timerLabel.textAlignment = .right
		timerLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)

		let bottomStack = UIStackView(arrangedSubviews: [participantsLabel, timerLabel])
		bottomStack.axis = .horizontal
		bottomStack.alignment = .bottom
		bottomStack.distribution = .fill

		let mainStack = UIStackView(arrangedSubviews: [UIView(), titleLabel, logoImgView, instructionsLabel, bottomStack])
		mainStack.axis = .vertical
		mainStack.distribution = UIStackViewDistribution.fillProportionally
		mainStack.alignment = .center
		mainStack.translatesAutoresizingMaskIntoConstraints = false

		addSubview(mainStack)

		NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 40),
			mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
			mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
			mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
		])
	}



	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
