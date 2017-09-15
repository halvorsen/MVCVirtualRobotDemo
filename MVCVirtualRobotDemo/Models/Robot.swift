//
//  Robot.swift
//  MVCVirtualRobotDemo
//
//  Created by Aaron Halvorsen on 9/14/17.
//  Copyright © 2017 Aaron Halvorsen. All rights reserved.
//

import Foundation

public enum MovementAction {
    case rotateToFaceRight,rotateToFaceLeft,rotateToFaceUp,rotateToFaceDown,moveVertical,moveHorizontal
}

struct Robot {
    
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
    public var name: String?
    private var speed: Float = 1.0
    private var anglularVelocity: Float = 10.0
    private var homeLocation: (Float,Float) = (0.0,0.0)
    
    private enum RobotFaceDirection {
        case up, down, left, right
    }
    private var direction: RobotFaceDirection = .up
    
    
    
    init(){}
    
    init(_center: (x:Float,y:Float), _size: (Float,Float), _speed: Float, _name: String?) {
        homeLocation = _center
        locationCenter = _center
        speed = _speed
        name = _name
        size = _size
    }
    private func angleOfRotation(start:RobotFaceDirection,end:RobotFaceDirection) -> Float {
        switch start {
        case .up:
            switch end {
            case .down: return Float.pi
            case .left: return Float.pi/2
            case .right: return Float.pi/2
            case .up: return 0
            }
        case .down:
            switch end {
            case .up: return Float.pi
            case .left: return Float.pi/2
            case .right: return Float.pi/2
            case .down: return 0
            }
        case .left:
            switch end {
            case .down: return Float.pi/2
            case .up: return Float.pi/2
            case .right: return Float.pi
            case .left: return 0
            }
        case .right:
            switch end {
            case .down: return Float.pi/2
            case .left: return Float.pi
            case .up: return Float.pi/2
            case .right: return 0
            }
        }
    }
    
    private enum Step {
        case rotationUpOrDown, moveUpOrDown, rotationLeftOrRight, moveLeftOrRight
    }
    private var myStep: Step = .rotationUpOrDown
    private var instructions = [(MovementAction,Double)]()
    public mutating func instructionsToLocation(x:Float,y:Float) -> [(action:MovementAction,animationTime:Double)] {
        
        switch myStep {
        case .rotationUpOrDown:
            instructions.removeAll()
            let yMovement = y - locationOfCenterY
            if yMovement > 1 && direction != .down {
                instructions.append((.rotateToFaceDown, Double(angleOfRotation(start: direction, end: .down)/anglularVelocity)))
                    myStep = .moveUpOrDown
                direction = .down
                  let _ = instructionsToLocation(x: x, y: y)
                
            } else if yMovement < -1 && direction != .up {
                instructions.append((.rotateToFaceUp, Double(angleOfRotation(start: direction, end: .up)/anglularVelocity)))
                myStep = .moveUpOrDown
                direction = .up
                let _ = instructionsToLocation(x: x, y: y)
                
            } else if (yMovement > 1 && direction == .down) || (yMovement < -1 && direction == .up) {
                myStep = .moveUpOrDown
                let _ = instructionsToLocation(x: x, y: y)
            } else {
                myStep = .rotationLeftOrRight
                let _ = instructionsToLocation(x: x, y: y)
            }
            
        case .moveUpOrDown:
            
            let yMovement = y - locationOfCenterY
            instructions.append((.moveVertical,Double(abs(yMovement/speed))))
            myStep = .rotationLeftOrRight
            let _ = instructionsToLocation(x: x, y: y)
            
        case .rotationLeftOrRight:
            
            let xMovement = x - locationOfCenterX
            if xMovement > 1 && direction != .right {
                instructions.append((.rotateToFaceRight, Double(angleOfRotation(start: direction, end: .right)/anglularVelocity)))
                    myStep = .moveLeftOrRight
                direction = .right
                    let _ = instructionsToLocation(x: x, y: y)
                
            } else if xMovement < -1 && direction != .left {
                instructions.append((.rotateToFaceLeft, Double(angleOfRotation(start: direction, end: .left)/anglularVelocity)))
                myStep = .moveLeftOrRight
                direction = .left
                let _ = instructionsToLocation(x: x, y: y)
                
            } else if (xMovement > 1 && direction == .right) || (xMovement < -1 && direction == .left) {
                myStep = .moveLeftOrRight
                let _ = instructionsToLocation(x: x, y: y)
            } else {
                myStep = .rotationUpOrDown
                //complete & set up for next
                return instructions
            }
            
        case .moveLeftOrRight:
            
            let xMovement = x - locationOfCenterX
            instructions.append((.moveHorizontal,Double(abs(xMovement/speed))))
            myStep = .rotationUpOrDown
            //complete & set up for next
            return instructions
        }
        return instructions
    }
    
    public mutating func goHome() -> [(action:MovementAction,animationTime:Double)] {
        return instructionsToLocation(x:homeLocation.0,y:homeLocation.1)
    }
}




