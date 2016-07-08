//
//  DragImage.swift
//  my-kinda-pokemon
//
//  Created by Hien Tran on 7/07/2016.
//  Copyright © 2016 HienTran. All rights reserved.
//

import Foundation
import UIKit

class DragImage: UIImageView {
    
    var originalPosition: CGPoint!
    
    var dropTarget: UIView?
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.superview)
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget {
            let position = touch.location(in: self.superview?.superview)
            // CGRectContainsPoint(CGRect rect, CGPoint point) -- Objective C
            if target.frame.contains(position) {
                //var notif = Notification(name: "onTargetDropped" as Name)
                //print("Here")
                //Noti
                NotificationCenter.default().post(name: "onTargetDropped" as NSNotification.Name, object: nil)
                 //NotificationCenter.default.post(NSNotification(name: "onTargetDropped" as NSNotification.Name, object: nil) as Notification)
            }
        }
        self.center = originalPosition
    }
}
