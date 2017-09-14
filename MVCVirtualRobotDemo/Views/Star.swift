//
//  Star.swift
//  RootDemo
//
//  Created by Aaron Halvorsen on 9/1/17.
//  Copyright © 2017 Right Brothers. All rights reserved.
//

import UIKit

class Star: UIImageView {

    init() {super.init(frame: CGRect.zero)}
    
    
    init(starSize: CGSize, starOriginX: CGFloat, starOriginY: CGFloat, starAlpha: CGFloat = 0.0) {
        super.init(frame: CGRect(x: starOriginX, y: starOriginY, width: starSize.width, height: starSize.height))
        self.backgroundColor = .clear
        self.image = #imageLiteral(resourceName: "star")
        self.alpha = starAlpha
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
