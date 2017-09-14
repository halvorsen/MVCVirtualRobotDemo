//
//  Delegates.swift
//  RootDemo
//
//  Created by Aaron Halvorsen on 9/4/17.
//  Copyright © 2017 Right Brothers. All rights reserved.
//

import UIKit

protocol StarDelegate: class {
    func highlightStar(view: UIView)
    func pulse(highlightedView: UIView)
}

protocol RobotDelegate: class {
    func relocateRobot(robotView: RobotView)
}
