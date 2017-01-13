//
//  ShakeViewController.swift
//  Swift-POP
//
//  Created by Chris Hu on 17/1/13.
//  Copyright © 2017年 icetime17. All rights reserved.
//

import UIKit


private protocol Shakable {

}

extension Shakable where Self: UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 4, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 4, y: center.y))
        layer.add(animation, forKey: "position")
    }
}

class ShakeImageView: UIImageView, Shakable {
    
}

class ShakeButton: UIButton, Shakable {

}


class ShakeViewController: UIViewController {

    var shakeImageView: ShakeImageView!
    var shakeBtn: ShakeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initImageView()
        
        initBtn()
    }
    
    func initImageView() {
        shakeImageView = ShakeImageView(frame: CGRect(x: (view.frame.width - 200) / 2, y: 100, width: 200, height: 200))
        shakeImageView.image = UIImage(named: "Model.png")
        view.addSubview(shakeImageView)
    }
    
    func initBtn() {
        shakeBtn = ShakeButton(frame: CGRect(x: (view.frame.width - 100) / 2, y: shakeImageView.frame.maxY + 20, width: 100, height: 30))
        shakeBtn.backgroundColor = UIColor.lightGray
        shakeBtn.setTitle("Shake", for: .normal)
        view.addSubview(shakeBtn)
        shakeBtn.addTarget(self, action: #selector(ShakeViewController.actionShake), for: .touchUpInside)
    }
    
    func actionShake() {
        shakeBtn.shake()
        shakeImageView.shake()
    }
}
