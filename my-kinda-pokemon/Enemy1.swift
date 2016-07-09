//
//  Enemy1.swift
//  my-kinda-pokemon
//
//  Created by Hien Tran on 9/07/2016.
//  Copyright © 2016 HienTran. All rights reserved.
//


import Foundation
import UIKit

class Enemy1: UIImageView {
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playStandingAnimation()
    }
    
    func playStandingAnimation(){
        
        self.image = UIImage(named: "enemy1-idle1.png")
        
        self.animationImages = nil
        
        self.animationImages = returnImgArray(alive: "idle")!
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeadAnimation() {
        self.image = UIImage(named: "enemy1-dead5.png")
        
        self.animationImages?.removeAll(keepingCapacity: false)
        
        self.animationImages = returnImgArray(alive: "dead")!
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
    func returnImgArray(alive: String) -> [UIImage]? {
        var imgArray = [UIImage]()
        var maxValue: Int = 4
        if alive == "dead" {
            maxValue = 5
        }
        for x in 1...maxValue{
            if let img = UIImage(named: "enemy1-\(alive)\(x).png") {
                imgArray.append(img)
            }
        }
        return imgArray
    }
}
