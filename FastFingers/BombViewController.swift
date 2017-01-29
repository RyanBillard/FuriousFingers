//
//  BombView.swift
//  FastFingers
//
//  Created by Nikola Draca on 2017-01-29.
//  Copyright © 2017 Ryan Billard. All rights reserved.
//
import Foundation
import UIKit

class BombViewController: UIViewController {
    
    var location = CGPoint(x: 0, y:0)
    var bombView = UIImageView()
    var ticker = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
//    override func createInstructionView() -> InstructionView {
//        return InstructionView(title: "Tick Tock", instructions: "Slide the bomb off your screen to give it to a friend. Dont't be the last one holding onto it when it goes off!", participants: session.connectedPeers.map({ $0.displayName }))
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first! as UITouch
        location = touch.location(in: self.view)
        bombView.center = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first! as UITouch
        location = touch.location(in: self.view)
        bombView.center = location
        
        if (location.x < 0.3*(UIScreen.main.bounds.width)) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.bombView.center.x = -200
            }, completion: nil)
            
            bombView.removeFromSuperview()
            
            // broadcast bomb pass

        }
        
        else if (location.x > 0.7*(UIScreen.main.bounds.width)) {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.bombView.center.x = UIScreen.main.bounds.width + 200
            }, completion: nil)
            
            bombView.removeFromSuperview()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.2 * UIScreen.main.bounds.height))
        title.text = "Tick, tock"
        title.font = UIFont(name: "AvenirNext-Medium", size: 30)
        title.textAlignment = .center
        
        ticker.backgroundColor = UIColor(red:1.00, green:0.77, blue:0.54, alpha:1.0)
        
        
        let bombImg = UIImage(named: "bomb")
        let bombView = UIImageView(image: bombImg)
        
        self.bombView = bombView
        
        self.view.addSubview(ticker)
        self.view.addSubview(self.bombView)
        self.view.addSubview(title)

        
        
        bombView.center = self.view.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 5, delay: 0, options: .curveLinear, animations: {
            self.ticker.center.y = UIScreen.main.bounds.height + self.ticker.frame.height / 2
        }, completion: nil)
    }
}
