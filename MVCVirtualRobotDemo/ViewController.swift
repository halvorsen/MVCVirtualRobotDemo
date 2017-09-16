//
//  ViewController.swift
//  RootDemo
//
//  Created by Aaron Halvorsen on 9/1/17.
//  Copyright © 2017 Right Brothers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var starModel = MovableCursor()
    var destinationStar = Star()
    var robotView = RobotView()
    var robotModel = Robot()
    let myGridView = GridView()
    var myStarDelegate : StarDelegate?
    var myUIController : UIController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myGridView)
        starModel = MovableCursor(_size: (Float(myGridView.cells[0].bounds.width/2),Float(myGridView.cells[0].bounds.width/2)), _center: (Float(myGridView.center.x),Float(myGridView.center.y)))
        robotModel = Robot(_center: (Float(myGridView.cells[3].center.x),Float(myGridView.cells[3].center.y)), _size: (Float(myGridView.cells[0].bounds.width/4),Float(myGridView.cells[0].bounds.width/4)), _speed: 100.0, _name: "ROOT")
        
        robotView = RobotView(robotSize: CGSize(width: CGFloat(robotModel.width), height: CGFloat(robotModel.height)), robotOriginX: CGFloat(robotModel.locationOfCenterX-robotModel.width/2), robotOriginY: CGFloat(robotModel.locationOfCenterY-robotModel.height/2))
        robotView.layer.zPosition = 2
        view.addSubview(robotView)
        
        destinationStar = Star(starSize: CGSize(width: CGFloat(starModel.width), height: CGFloat(starModel.height)), starOriginX: CGFloat(starModel.locationOfCenterX-starModel.width/2), starOriginY: CGFloat(starModel.locationOfCenterY-starModel.height/2), starAlpha: 1.0)
        destinationStar.layer.zPosition = 1
        view.addSubview(destinationStar)
        
        myGridView.cells[3].backgroundColor = CustomColor.purpleHues.1
        
        myUIController = UIController(_robotModel: robotModel, _starModel: starModel, _view: view, _destinationStar: destinationStar, _robotView: robotView, _myGridView: myGridView)
        myStarDelegate = myUIController
        myStarDelegate?.highlightStar(view: destinationStar)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



