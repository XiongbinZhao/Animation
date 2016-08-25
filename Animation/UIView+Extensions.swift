//
//  UIView+Addition.swift
//
//  Created by Jack Zhao on 2016-08-09.
//  Copyright © 2016 Jack Zhao. All rights reserved.
//

import UIKit

extension UIView {
    var width: CGFloat {
        return self.frame.size.width
    }
    
    func setWidth(value: CGFloat) {
        var frame = self.frame
        frame.size.width = value
        self.frame = frame
    }
    
    var height: CGFloat {
        return self.frame.size.height
    }
    
    func setHeight(value: CGFloat) {
        var frame = self.frame
        frame.size.height = value
        self.frame = frame
    }
    
    var top: CGFloat {
        return self.frame.origin.y
    }
    
    func setTop(value: CGFloat) {
        var frame = self.frame
        frame.origin.y = value
        self.frame = frame
    }
    
    var right: CGFloat {
        return self.frame.origin.x + width
    }
    
    func setRight(value: CGFloat) {
        var frame = self.frame
        frame.origin.x = value - width
        self.frame = frame
    }
    
    var bottom: CGFloat {
        return top + height
    }
    
    func setBottom(value: CGFloat) {
        var frame = self.frame
        frame.origin.y = value - height
        self.frame = frame
    }
    
    var left: CGFloat {
        return self.frame.origin.x
    }
    
    func setLeft(value: CGFloat) {
        var frame = self.frame
        frame.origin.x = value
        self.frame = frame
    }
    
}
