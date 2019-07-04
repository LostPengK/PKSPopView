//
//   路漫漫其修远兮，吾将上下而求索
//
//   PKSConfig.swift
//   PKSPopView
//
//   Created  by pengkang on 2019/7/4
//   Copyright © 2019 qhht. All rights reserved.
//
    

import Foundation
import UIKit

enum PKSShowAnimationStyle {
    case scale,fromTop,FromLeft,FromBottom,FromRight
}

enum PKSHideAnimationStyle {
    case scale,toTop,toLeft,toBottom,toRight
}

enum PKSPanGestureRecognizerDirection {
    case top,left,bottom,right
}

struct PKSAutoLayoutStyle: OptionSet {
    let rawValue: UInt
    static let center = PKSAutoLayoutStyle(rawValue: 0<<0)
    static let top = PKSAutoLayoutStyle(rawValue: 1<<0)
    static let left = PKSAutoLayoutStyle(rawValue: 3<<0)
    static let bottom = PKSAutoLayoutStyle(rawValue: 3<<0)
    static let right = PKSAutoLayoutStyle(rawValue: 4<<0)
}

class PKSConfig {
    
    static let shared = PKSConfig()
    
    ///default is 0.35
    public var duration: CGFloat  = 0.35
    
    /// default is scale
    var showAnimationStyle: PKSShowAnimationStyle = .scale
    
    /// default is scale
    var hideAnimationStyle: PKSHideAnimationStyle = .scale
    
    ///default is true
    var userTouchActionEnable: Bool = true
    
    ///default is true
    var addShowAnimation: Bool = true
    
    ///default is true
    var addHideAnimation: Bool = true
    
    ///default is false
    var useAutoLayout: Bool = false
    
    ///default is center
    var layoutPositon: PKSAutoLayoutStyle =  [.center]
    
    ///default is black
    var backColor: UIColor = .black
    
    ///default is 0.75;
    var backAlpha: CGFloat = 0.75
    
    ///default is zero;
    var contentViewInsets: UIEdgeInsets = .zero
    
    ///default is zero;
    var popViewInsets: UIEdgeInsets = .zero
    
    ///enable user pan to hide contentview.default is NO. works only when allowUserPanContentView is YES
    var enablePanContentViewToHide: Bool = false
    
    /// pan to hide min distance percent. less than this,content view will back to origin place,otherwise content will hide. default is 0.1;
    var panToHideMinPerecent: CGFloat = 0.1
    
    private init(){
        /// duration default is 0.35
      
    }
}
