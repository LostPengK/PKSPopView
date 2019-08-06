//
//   路漫漫其修远兮，吾将上下而求索
//
//   AutoLayoutView.swift
//   PKSPopView
//
//   Created  by pengkang on 2019/8/6
//   Copyright © 2019 qhht. All rights reserved.
//
    

import Foundation
import UIKit

class AutoLayoutView:UIView  {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override  var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
}
