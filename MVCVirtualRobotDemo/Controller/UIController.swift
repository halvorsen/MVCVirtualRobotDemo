//
//  UIController.swift
//  RootDemo
//
//  Created by Aaron Halvorsen on 9/4/17.
//  Copyright © 2017 Right Brothers. All rights reserved.
//

import UIKit

class UIController {
    
    fileprivate var timer = Timer()
    fileprivate var changeColorTimer = Timer()
    fileprivate var myStep: Step = .rotationUpOrDown
    fileprivate let speed = Double(UIScreen.main.bounds.width/4)
    fileprivate var rootDirection: RobotDirection = .up
    fileprivate var view = UIView()
    fileprivate var tap = UITapGestureRecognizer()
    fileprivate var pan = UIPanGestureRecognizer()
    fileprivate var destinationStar = UIView()
    fileprivate var robotView = RobotView()
    fileprivate var myGridView = GridView()
    fileprivate var startedPanOnStar = false
    fileprivate var lastCheckedCell : GridCell?
    fileprivate var robotModel = Robot()
    fileprivate var starModel = MovableCursor()
    
    init(_robotModel: Robot, _starModel: MovableCursor, _view: UIView, _destinationStar: UIView, _robotView: RobotView, _myGridView: GridView) {
        
        (view,destinationStar,robotView,myGridView,robotModel,starModel) = (_view,_destinationStar,_robotView,_myGridView,_robotModel,_starModel)
        
        changeColorTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UIController.changeTileColor), userInfo: nil, repeats: true)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(UIController.panFunc(_:)))
        view.addGestureRecognizer(pan)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(UIController.tapFunc(_:)))
        view.addGestureRecognizer(tap)
        
        lastCheckedCell = myGridView.cells[3]
        
    }
    
    
}

//change tile colors
extension UIController {
    @objc fileprivate func changeTileColor() {
        var currentCell : GridCell?
        var currentHue = UIColor.black
        
        for cell in myGridView.cells {
            guard let robotAnimatedLocation = robotView.layer.presentation()?.frame.origin else {print("guarded2");return}
            let centerPoint = view.convert(robotAnimatedLocation, to: myGridView)
            if cell.frame.contains(centerPoint) {
            
                currentCell = cell
                if let backgroundColor = cell.backgroundColor {
                    currentHue = backgroundColor
                }
            }
        }
        guard let current = currentCell,
            let last = lastCheckedCell else {print("guarded1");return}
        if current != last {
            switch currentHue {
            case CustomColor.purpleHues.0:
                current.backgroundColor = CustomColor.purpleHues.2
            case CustomColor.purpleHues.1:
                current.backgroundColor = CustomColor.purpleHues.0
            case CustomColor.purpleHues.2:
                current.backgroundColor = CustomColor.purpleHues.1
            default: print("something went wrong");break
            }
        }
        lastCheckedCell = current
        
    }
}

//gesture recognizer functions
extension UIController {
    @objc fileprivate func tapFunc(_ tap: UITapGestureRecognizer) {
        if destinationStar.frame.contains(tap.location(in: view)) {
            for cell in myGridView.cells {
                cell.star.alpha = 0.1
            }
            Global.delay(bySeconds: 0.2) {
                for cell in self.myGridView.cells {
                    cell.star.alpha = 0.0
                }
            }
        }
    }
    
    
    @objc fileprivate func panFunc(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            if destinationStar.frame.contains(gestureRecognizer.location(in: view)) {
                startedPanOnStar = true
            }
            
            for cell in myGridView.cells {
                cell.star.alpha = 0.1
            }
            
            timer.invalidate()
            
        } else if gestureRecognizer.state == .changed && startedPanOnStar {
            
            let translation = gestureRecognizer.translation(in: self.view)
            destinationStar.center = CGPoint(x: destinationStar.center.x + translation.x, y: destinationStar.center.y + translation.y)
            starModel.locationCenter = (Float(destinationStar.center.x),Float(destinationStar.center.y))
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            
        } else if gestureRecognizer.state == .ended {
            startedPanOnStar = false
            
            for cell in myGridView.cells {
                cell.star.alpha = 0.0
            }
            
            for cell in myGridView.cells {
                if cell.frame.contains(destinationStar.center) {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.destinationStar.center = self.myGridView.convert(cell.center, to: self.view)
                        self.starModel.locationCenter = (Float(self.destinationStar.center.x),Float(self.destinationStar.center.y))
                    }, completion: {_ in
                        self.relocateRobot(robotView: self.robotView)
                    })
                    
                    return
                }
            }
            
        }
        
    }
}

extension UIController: RobotDelegate {
    
    enum RobotDirection {
        case up,down,left,right
    }
    
    enum Step {
        case rotationUpOrDown, moveUpOrDown, rotationLeftOrRight, moveLeftOrRight
    }
    
    internal func moveView(instructions: [(MovementAction,Double)], count: Int, done: @escaping () -> Void) {
        if count < instructions.count {
        UIView.animate(withDuration: instructions[count].1, animations: {
            switch instructions[count].0 {
            case .rotateToFaceUp:
                self.robotView.transform = CGAffineTransform(rotationAngle: 0)
            case .rotateToFaceDown:
                self.robotView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case .rotateToFaceLeft:
                self.robotView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            case .rotateToFaceRight:
                self.robotView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
            case .moveHorizontal:
                self.robotView.center.x = CGFloat(self.starModel.locationOfCenterX)
            case .moveVertical:
                self.robotView.center.y = CGFloat(self.starModel.locationOfCenterY)
                
            }

        }, completion: { _ in
            self.moveView(instructions: instructions, count: count + 1) {done()}
            
        })
        } else {
            done()
        }
    }
    
    internal func relocateRobot(robotView: RobotView) {
        let instructions = robotModel.instructionsToLocation(x:starModel.locationOfCenterX, y:starModel.locationOfCenterY)
        let instructionAmount = instructions.count
        var count = 1
        moveView(instructions: instructions, count: 0, done: {
            robotModel.locationCenter = starModel.locationCenter
            
        })
        
        
        
    }
}

extension UIController: StarDelegate {
    
    internal func highlightStar(view: UIView) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) {_ in
            
            self.pulse(highlightedView: view)
        }
        
    }
    
    internal func pulse(highlightedView: UIView) {
        
        let width = highlightedView.bounds.width
        let height = highlightedView.bounds.height
        let x = highlightedView.frame.origin.x
        let y = highlightedView.frame.origin.y
        
        UIView.animate(withDuration: 0.2) {
            highlightedView.frame = CGRect(x: x - 0.05*width, y: y - 0.05*height, width: 1.1*width, height: 1.1*height)
        }
        Global.delay(bySeconds: 0.2) {
            UIView.animate(withDuration: 0.2) {
                highlightedView.frame = CGRect(x: x, y: y, width: width, height: height)
            }
        }
        
    }
}
