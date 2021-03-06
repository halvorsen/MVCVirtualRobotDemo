//
//  GridView.swift
//  RootDemo
//
//  Created by Aaron Halvorsen on 9/1/17.
//  Copyright © 2017 Right Brothers. All rights reserved.
//

import UIKit

class GridView4x4: UIView {
    
    public var cells = [GridCell]()
    private var gridViewWidth: CGFloat {
        if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
            return UIScreen.main.bounds.height
        } else {
            return UIScreen.main.bounds.width
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    init(marginsWidth: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: gridViewWidth, height: gridViewWidth))
        let margin = marginsWidth
        let cellWidth: CGFloat = CGFloat(Int((self.bounds.size.width - 5*margin)/4))
        for i in 0..<4 {
            for j in 0..<4 {
                
                let newGridCell = GridCell(cellSize: CGSize(width: cellWidth, height: cellWidth),
                                           cellOriginX: (cellWidth + margin)*CGFloat(i) + margin,
                                           cellOriginY: (cellWidth + margin)*CGFloat(j) + margin,
                                           startColor: CustomColor.purpleHues.2)
                
                addSubview(newGridCell)
                
                cells.append(newGridCell)
                
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
