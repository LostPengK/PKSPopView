//
//   路漫漫其修远兮，吾将上下而求索
//
//   PKSPopView.swift
//   PKSPopView
//
//   Created  by pengkang on 2019/7/4
//   Copyright © 2019 qhht. All rights reserved.
//
    

import UIKit

class PKSPopView: UIView {

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
    public var enablePanContentViewToHide: Bool = false {
        didSet {
            
        }
    }
    
    /// pan to hide min distance percent. less than this,content view will back to origin place,otherwise content will hide. default is 0.1;
    var panToHideMinPerecent: CGFloat = 0.1
    
    ///contentView
    public var superContainerView: UIView?
    
    ///contentView
    public var contentView: UIView?
    
    ///coverView
    private lazy var coverView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    ///contentOriginFrame
    private var contentOriginFrame: CGRect?
    
    ///user paned or not
    private var userPaned: Bool = false
    
    ///panedPercent
    private var panedPercent: CGFloat = 0.0
    
    ///gesture
    private var panGesture: UIPanGestureRecognizer?
    
    typealias showCompletionBlock = () -> Void
    typealias hideCompletionBlock = () -> Void
    
    public var showCompletionBlock: showCompletionBlock?
    public var hideCompletionBlock: hideCompletionBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: .zero)
        self.initData()
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initData(){
        let share = PKSConfig.shared
        self.duration = share.duration;
        self.userTouchActionEnable = share.userTouchActionEnable;
        self.addHideAnimation = share.addHideAnimation;
        self.addShowAnimation = share.addShowAnimation;
        self.showAnimationStyle = share.showAnimationStyle;
        self.hideAnimationStyle = share.hideAnimationStyle;
        self.layoutPositon = share.layoutPositon;
        self.contentViewInsets = share.contentViewInsets;
        self.popViewInsets = share.popViewInsets;
        self.backAlpha = share.backAlpha;
        self.backColor = share.backColor;
        self.duration = share.duration;
        self.panToHideMinPerecent = share.panToHideMinPerecent;
        self.enablePanContentViewToHide = share.enablePanContentViewToHide;
        self.useAutoLayout = share.useAutoLayout;
    }
    
    private func setupSubviews() {
      
        self.addSubview(self.coverView)
    }
    
    public func prepare(_ sView: UIView!){
        
        self.superContainerView = sView
        self.superContainerView?.addSubview(self)
        
        self.userPaned = false;
        self.panedPercent = 0;
        self.isUserInteractionEnabled = true;
        self.frame =  self.superContainerView?.bounds.inset(by: self.popViewInsets) ?? .zero ;
        self.coverView.frame = self.bounds.inset(by: self.contentViewInsets)
        self.coverView.alpha = 0.0;
        self.coverView.backgroundColor = self.backColor
        self.layer.removeAllAnimations()
        self.contentView?.layer.removeAllAnimations()
        
        addSubview(self.contentView!)
        
    }
    
    private func layoutContentView(){
        
    }
    
    public func showOnView(_ view: UIView? ){
        
        guard view != nil else { return }
        guard self.contentView != nil else { return }
        
        prepare(view)
        
        if self.useAutoLayout {
            layoutContentView()
        }
        
        self.contentOriginFrame =  self.contentView!.frame
        
        if self.addShowAnimation {
            addShowAnimationToContnetView()
        }
        
        UIView.animate(withDuration: Double(self.duration), animations: {
            self.coverView.alpha = self.backAlpha
        }) { (finish) in
            self.showCompletionBlock?()
        }
        
    }
 
    public func hideContentView(){
        if self.addHideAnimation{
            addHideAnimationToContnetView()
            return
        }
        
        hide()
    }
}

extension PKSPopView{
    public func addShowAnimationToContnetView() {
        switch self.showAnimationStyle {
        case .scale:
            addDetaultShowAnimation()
        case .fromTop:
            addShowAnimationFromTop()
        case .FromLeft:
            addShowAnimatioFromLeft()
        case .FromBottom:
            addShowAnimationFromBottom()
        case .FromRight:
            addShowAnimationFromRight()
        default:
            addDetaultShowAnimation()
        }
    }
    
    private func addDetaultShowAnimation(){
        let baseAni: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        baseAni.duration = TimeInterval(self.duration)
        baseAni.repeatCount = 1
        baseAni.fromValue = NSNumber(value: 0.01)
        baseAni.toValue = NSNumber(value: 1)
        baseAni.fillMode = .forwards
        baseAni.isRemovedOnCompletion = true
        baseAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.contentView?.layer.add(baseAni, forKey: "scale")
    }
    
    private func addShowAnimationFromTop(){
        
    }
    
    private func addShowAnimatioFromLeft(){
        var frame = self.contentView!.frame
        let frame1 = self.contentView!.frame
        frame.origin.x = -frame.size.width
        self.contentView!.frame = frame
        
        UIView.animate(withDuration: TimeInterval(self.duration) , animations: {
            self.contentView!.frame = frame1;
        }) { (finish) in
            
        }
        
    }
    
    private func addShowAnimationFromBottom(){
        
    }
    
    private func addShowAnimationFromRight(){
        
    }
  
}

extension PKSPopView{
 
    public func addHideAnimationToContnetView() {
        switch self.hideAnimationStyle {
        case .scale:
            addDetaultHideAnimation()
        case .toTop:
            addShowAnimationFromTop()
        case .toLeft:
            addShowAnimatioFromLeft()
        case .toBottom:
            addShowAnimationFromBottom()
        case .toRight:
            addShowAnimationFromRight()
        default:
            addDetaultHideAnimation()
        }
    }
    
    private func addDetaultHideAnimation(){
        let baseAni: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        baseAni.duration = TimeInterval(self.duration)
        baseAni.repeatCount = 1
        baseAni.fromValue = NSNumber(value: 1)
        baseAni.toValue = NSNumber(value: 0.0)
        baseAni.fillMode = .forwards
        baseAni.isRemovedOnCompletion = true
        baseAni.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.contentView?.layer.add(baseAni, forKey: "scale")
        
        let hDuration:CGFloat = userPaned ? self.duration * (1-panedPercent) : self.duration;
        UIView.animate(withDuration: TimeInterval(hDuration) , animations: {
            self.coverView.alpha =  0.0;
        }) { (finish) in
            self.hide()
        }
        
    }
    
    private func addHideAnimationToTop(){
        
    }
    
    private func addHideAnimatioToLeft(){
        
    }
    
    private func addHideAnimationToBottom(){
        
    }
    
    private func addHideAnimationToRight(){
        
    }
    
    private func hide(){
        self.contentView?.removeFromSuperview()
    }
}
