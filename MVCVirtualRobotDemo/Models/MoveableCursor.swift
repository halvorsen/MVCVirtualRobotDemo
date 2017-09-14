//
//  Star.swift
//  MVCVirtualRobotDemo
//
//  Created by Aaron Halvorsen on 9/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation

struct MovableCursor {
    public var locationOfCenterX: Float {
        return locationCenter.0
    }
    public var locationOfCenterY: Float {
        return locationCenter.1
    }
    public var width: Float {
        return size.0
    }
    public var height: Float {
        return size.1
    }
    private var size: (Float,Float) = (1.0,1.0)
    
    public var locationCenter: (Float,Float) = (1.0,1.0)
    
    public var isBlinking: Bool = true
    
    init(){}
    
    init(_size: (Float,Float), _center: (Float,Float)) {
        size = _size
        locationCenter = _center
    }
}
