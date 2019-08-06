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

public enum PKSShowAnimationStyle {
    case scale,fromTop,fromLeft,fromBottom,fromRight
}

public enum PKSHideAnimationStyle {
    case scale,toTop,toLeft,toBottom,toRight
}

public enum PKSPanGestureRecognizerDirection {
    case top,left,bottom,right,none
}

public struct PKSAutoLayoutStyle: OptionSet {
    public let rawValue: Int
    static let center = PKSAutoLayoutStyle(rawValue: 1<<0)
    static let top = PKSAutoLayoutStyle(rawValue: 1<<1)
    static let left = PKSAutoLayoutStyle(rawValue: 1<<2)
    static let bottom = PKSAutoLayoutStyle(rawValue: 1<<3)
    static let right = PKSAutoLayoutStyle(rawValue: 1<<4)
    
    public init(rawValue:Int) {
        self.rawValue = rawValue
    }
}

public class PKSConfig {
    
    public static let shared = PKSConfig()
    
    ///default is 0.35
    public var duration: CGFloat  = 0.35
    
    /// default is scale
    public var showAnimationStyle: PKSShowAnimationStyle = .scale
    
    /// default is scale
    public var hideAnimationStyle: PKSHideAnimationStyle = .scale
    
    ///default is true
    public var userTouchActionEnable: Bool = true
    
    ///default is true
    public var addShowAnimation: Bool = true
    
    ///default is true
    public var addHideAnimation: Bool = true
    
    ///default is false
    public var useAutoLayout: Bool = false
    
    ///default is center
    public var layoutPositon: PKSAutoLayoutStyle =  [.center]
    
    ///default is black
    public var backColor: UIColor = .black
    
    ///default is 0.75;
    public var backAlpha: CGFloat = 0.75
    
    ///default is zero;
    public var contentViewInsets: UIEdgeInsets = .zero
    
    ///default is zero;
    public var popViewInsets: UIEdgeInsets = .zero
    
    ///enable user pan to hide contentview.default is NO. works only when allowUserPanContentView is YES
    public var enablePanContentViewToHide: Bool = false
    
    /// pan to hide min distance percent. less than this,content view will back to origin place,otherwise content will hide. default is 0.1;
    public var panToHideMinPerecent: CGFloat = 0.1
    
}
