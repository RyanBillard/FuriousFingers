//
//  OverUnderView.swift
//  FastFingers
//
//  Created by Ryan Billard on 2017-01-29.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//

import Foundation
import UIKit

class OverUnderView: UIView {
	let mainCard = UILabel()
	let lowerButton = UIButton()
	let higherButton = UIButton()
	let smallCards = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]

	init() {
		super.init(frame: CGRect.zero)
		backgroundColor = .white

		mainCard.font = UIFont.systemFont(ofSize: 80)

		smallCards.forEach { label in
			label.font = UIFont.systemFont(ofSize: 20)
			label.layer.borderColor = UIColor.black.cgColor
			label.layer.cornerRadius = 4.0
			label.clipsToBounds = true
			label.layer.borderWidth = 2.0
			NSLayoutConstraint.activate([
				label.widthAnchor.constraint(equalToConstant: 30),
				label.heightAnchor.constraint(equalToConstant: 50)
			])
			label.textAlignment = .center
		}

		lowerButton.setTitle("LOWER", for: .normal)
		lowerButton.setTitleColor(.black, for: .normal)
		higherButton.setTitle("HIGHER", for: .normal)
		higherButton.setTitleColor(.black, for: .normal)

		let buttonStack = UIStackView(arrangedSubviews: [lowerButton, higherButton])
		buttonStack.axis = .horizontal
		buttonStack.distribution = .fill
		buttonStack.spacing = 20

		let cardStack = UIStackView(arrangedSubviews: smallCards)
		cardStack.axis = .horizontal
		cardStack.distribution = .equalSpacing
		cardStack.spacing = 20

		let mainStack = UIStackView(arrangedSubviews: [UIView(), mainCard, UIView(), buttonStack, UIView(), cardStack, UIView()])
		mainStack.axis = .vertical
		mainStack.distribution = UIStackViewDistribution.equalCentering
		mainStack.alignment = .center
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		addSubview(mainStack)

		NSLayoutConstraint.activate([
			mainStack.topAnchor.constraint(equalTo: topAnchor),
			mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
			mainStack.leftAnchor.constraint(equalTo: leftAnchor),
			mainStack.rightAnchor.constraint(equalTo: rightAnchor)
		])
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


}
