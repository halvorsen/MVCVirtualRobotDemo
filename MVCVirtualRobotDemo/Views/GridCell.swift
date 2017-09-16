//
//  GridCell.swift
//  RootDemo
//
//  Created by Aaron Halvorsen on 9/1/17.
//  Copyright © 2017 Right Brothers. All rights reserved.
//

import UIKit

class GridCell: UIView {
    
    public var star = Star()
    
    init(cellSize: CGSize, cellOriginX: CGFloat, cellOriginY: CGFloat, startColor: UIColor) {
        
        super.init(frame: CGRect(x: cellOriginX, y: cellOriginY, width: cellSize.width, height: cellSize.height))
        
        self.backgroundColor = startColor
        
        star = Star(starSize: CGSize(width: self.bounds.width/2, height: self.bounds.width/2), starOriginX: 0, starOriginY: 0, image: #imageLiteral(resourceName: "star"))
        star.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        addSubview(star)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
