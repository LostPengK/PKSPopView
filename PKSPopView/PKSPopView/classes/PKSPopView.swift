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

public class PKSPopView: UIView {
    
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
    
    ///direction
    public var panDirection: PKSPanGestureRecognizerDirection = .none
    
    /// pan to hide min distance percent. less than this,content view will back to origin place,otherwise content will hide. default is 0.1;
    public var panToHideMinPerecent: CGFloat = 0.1
    
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
    public var userPaned: Bool = false
    
    ///panedPercent
    private var panedPercent: CGFloat = 0.0
    
    ///gesture
    private var panGesture: UIPanGestureRecognizer?
    private var tapGesture: UITapGestureRecognizer?
    
    typealias showCompletionBlock = () -> Void
    typealias hideCompletionBlock = () -> Void
    
    var showCompletionBlock: showCompletionBlock?
    var hideCompletionBlock: hideCompletionBlock?
    
    private var changeOffsetX:CGFloat = 0.0
    private var changeOffsetY:CGFloat = 0.0
    private var lastX:CGFloat = 0.0
    private var lastY:CGFloat = 0.0
    
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
    
    internal func prepare(_ sView: UIView!){
        
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
        
        if self.userTouchActionEnable{
            if self.panGesture == nil {
                self.tapGesture  = UITapGestureRecognizer(target: self, action: Selector(("tapCoverView")))
            }
            self.coverView.addGestureRecognizer(self.tapGesture!)
        }
        else{
            guard self.tapGesture != nil else { return }
            self.coverView.removeGestureRecognizer(self.tapGesture!)
        }
        
        
        if (self.enablePanContentViewToHide) {
            if self.panGesture == nil {
                self.panGesture  = UIPanGestureRecognizer(target: self, action: Selector(("panContentView:")))
            }
            self.addGestureRecognizer(self.panGesture!)
          }else{
            if (self.panGesture != nil) {
                self.removeGestureRecognizer(self.panGesture!)
            }
        }
    }
    
    @objc private func tapCoverView(){
        
        if self.userTouchActionEnable {
            self.hideContentView()
        }
        
    }
    
    @objc private func panContentView(_ gesture: UIPanGestureRecognizer!){
        
        if (enablePanContentViewToHide == false || self.contentView == nil) {
            return
        }
        
        let touchPoint = gesture.location(in: gesture.view!)
        
        if (gesture.state == .began){
            lastX = touchPoint.x;
            lastY = touchPoint.y;
            
            userPaned = true;
        }
        
        var alphaFactor:CGFloat = 0.0
        if (gesture.state == .changed){
            let currentX = touchPoint.x
            changeOffsetX = currentX - lastX
            lastX = currentX
            
            let currentY = touchPoint.y
            changeOffsetY = currentY - lastY
            lastY = currentY
            
            var centerX = self.contentView!.center.x
            var centerY = self.contentView!.center.y
            
            switch self.panDirection {
            case .top:
                centerY = self.contentView!.center.y + changeOffsetY
                centerY = centerY <= self.contentOriginFrame!.midY  ? centerY : self.contentView!.center.y
            case .left:
                centerX = self.contentView!.center.x + changeOffsetX;
                centerX = centerX <= self.contentOriginFrame!.midX ? centerX : self.contentView!.center.x
            case .bottom:
                centerY = self.contentView!.center.y + changeOffsetY
                centerY = centerY > self.contentOriginFrame!.midY ? centerY : self.contentView!.center.y
            case .right:
                centerX = self.contentView!.center.x + changeOffsetX
                centerX = centerX > self.contentOriginFrame!.midX ? centerX : self.contentView!.center.x
            case .none:
                print("you need special the direction")
            }
        
            self.contentView!.center = CGPoint(x: centerX, y: centerY)
            var offset:CGFloat = 0.0
            
            if (self.panDirection == .top || self.panDirection == .bottom) {
                offset = self.contentView!.frame.midY - self.contentOriginFrame!.midY
                panedPercent = CGFloat(fabsf(Float(offset) / Float(self.contentView!.frame.height)))
                alphaFactor = 1.0 - panedPercent
            }else if (self.panDirection == .left || self.panDirection == .right) {
                offset = self.contentView!.frame.midX  - self.contentOriginFrame!.midX
                panedPercent = CGFloat(fabsf(Float(offset)/Float(self.contentView!.frame.width)))
                alphaFactor = 1.0 - panedPercent
            }
            let alpha = alphaFactor * self.backAlpha
            print("alphaFactor===\(alphaFactor)),alpha===\(alpha)")
            self.coverView.alpha = alpha
        }
        
        gesture.setTranslation(.zero, in: self)
        
        if gesture.state == .ended || gesture.state == .cancelled {
            var percent:Float = 0.0;
            if (self.panDirection == .top || self.panDirection == .bottom) {
                percent = fabsf(Float(self.contentView!.frame.midY)  - Float(self.contentOriginFrame!.midY))/Float(self.contentOriginFrame!.height)
            }else if (self.panDirection == .left || self.panDirection == .right) {
                percent = fabsf(Float(self.contentView!.frame.midX - self.contentOriginFrame!.minX))/Float(self.contentOriginFrame!.width)
            }
            
            let hide = percent >= Float(self.panToHideMinPerecent) ? true : false
            if (hide) {//计算剩余时间
                hideContentView()
            }else{//回到原始位置
                UIView.animate(withDuration: TimeInterval(self.duration) , animations: {
                    self.contentView!.frame = self.contentOriginFrame!
                    self.coverView.alpha = self.backAlpha
                }) { (finish) in
                    
                }
            }
            
            userPaned = false
            panedPercent = 0.0
        }
        
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
        case .fromLeft:
            addShowAnimatioFromLeft()
        case .fromBottom:
            addShowAnimationFromBottom()
        case .fromRight:
            addShowAnimationFromRight()
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
        
        var frame = self.contentView?.frame
        let frame1 = self.contentView?.frame
        frame!.origin.y = -frame!.size.height
        self.contentView?.frame = frame!
        
        UIView.animate(withDuration: TimeInterval(self.duration), animations: {
            self.contentView?.frame = frame1!
        }) { (finish) in
            
        }
   
    }
    
    private func addShowAnimatioFromLeft(){
        var frame = self.contentView!.frame
        let frame1 = self.contentOriginFrame
        frame.origin.x = -frame.size.width
        self.contentView!.frame = frame
        
        UIView.animate(withDuration: TimeInterval(self.duration) , animations: {
            self.contentView!.frame = frame1!
        }) { (finish) in

        }
        
    }
    
    private func addShowAnimationFromBottom(){
        var frame = self.contentOriginFrame;
        let frame1 = self.contentOriginFrame;
        
        frame?.origin.y = self.frame.size.height;
        self.contentView!.frame = frame!;
        
        UIView.animate(withDuration: TimeInterval(self.duration) , animations: {
            self.contentView!.frame = frame1!
        }) { (finish) in
            
        }
   
    }
    
    private func addShowAnimationFromRight(){
        var frame = self.contentView!.frame;
        let frame1 = self.contentView!.frame;
        frame.origin.x = self.frame.size.width;
        self.contentView!.frame = frame;
        
        UIView.animate(withDuration: TimeInterval(self.duration) , animations: {
            self.contentView!.frame = frame1
        }) { (finish) in
            
        }
    }
}

extension PKSPopView{
 
    public func addHideAnimationToContnetView() {
        switch self.hideAnimationStyle {
        case .scale:
            addDetaultHideAnimation()
        case .toTop:
            addHideAnimationToTop()
        case .toLeft:
            addHideAnimatioToLeft()
        case .toBottom:
            addHideAnimationToBottom()
        case .toRight:
            addHideAnimationToRight()
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
        var frame = self.contentView!.frame;
        frame.origin.y = -frame.size.height;
        let hDuration = userPaned ? self.duration * (1-panedPercent) : self.duration;
        
        UIView.animate(withDuration: TimeInterval(hDuration) , animations: {
            self.contentView!.frame = frame;
            self.coverView.alpha =  0.0;
        }) { (finish) in
            self.hide()
        }
        
    }
    
    private func addHideAnimatioToLeft(){
        
        var frame = self.contentView?.frame;
        frame!.origin.x = -frame!.size.width;
        let hDuration = userPaned ? self.duration * (1-panedPercent) : self.duration;
        UIView.animate(withDuration: TimeInterval(hDuration) , animations: {
            self.contentView?.frame = frame!;
            self.coverView.alpha =  0.0;
        }) { (finish) in
            self.hide()
        }
        
    }
    
    private func addHideAnimationToBottom(){
        var  frame = self.contentView!.frame;
        frame.origin.y = self.frame.size.height;
        let hDuration = userPaned ? self.duration * (1-panedPercent) : self.duration;
        
        UIView.animate(withDuration: TimeInterval(hDuration) , animations: {
            self.contentView!.frame = frame;
            self.coverView.alpha =  0.0;
        }) { (finish) in
            self.hide()
        }
        
    }
    
    private func addHideAnimationToRight(){
        var frame = self.contentView!.frame
        frame.origin.x = self.frame.size.width
        
        let hDuration = userPaned ? self.duration * (1-panedPercent) : self.duration;
        UIView.animate(withDuration: TimeInterval(hDuration) , animations: {
            self.contentView!.frame = frame
            self.coverView.alpha =  0.0
        }) { (finish) in
            self.hide()
        }
        
    }
    
    private func hide(){
        self.contentView?.removeFromSuperview()
        self.removeFromSuperview()
    }
}
