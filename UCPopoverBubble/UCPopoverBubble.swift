//
//  UCPopoverBubble.swift
//  BlockTalk
//
//  Created by Christian Floisand on 2018-02-13.
//  Copyright © 2018 Uppercut. All rights reserved.
//

import UIKit


enum UCPopoverArrowDirection {
    case none
    case up, down, left, right
}


//# MARK: - UCPopoverBubble
class UCPopoverBubble: UIViewController {
    let arrowDirection: UCPopoverArrowDirection
    
    var color: UIColor? {
        set {
            view.backgroundColor = newValue
            _arrowLayer?.fillColor = newValue?.cgColor
        }
        get {
            return view.backgroundColor
        }
    }
    
    var cornerRadius: CGFloat {
        set {
            view.layer.cornerRadius = newValue
        }
        get {
            return view.layer.cornerRadius
        }
    }
    
    var font: UIFont {
        set {
            _textLabel.font = newValue
        }
        get {
            return _textLabel.font
        }
    }
    
    var textColor: UIColor {
        set {
            _textLabel.textColor = newValue
        }
        get {
            return _textLabel.textColor
        }
    }
    
    var buttonHandler: ((UCPopoverBubble,Int)->())?
    
    
    weak private var _arrowLayer: CAShapeLayer?
    weak private var _textLabel: UILabel!
    
    private var _centerOffset: CGPoint!
    private var _centerXConstraint: NSLayoutConstraint!
    private var _centerYConstraint: NSLayoutConstraint!
    
    static private var CONTENT_INSET: CGFloat = 12.0
    static private var MIN_EDGE_MARGIN: CGFloat = 4.0
    static private var ANIMATION_START_SCALE: CGFloat = 0.7
    static private var ANIMATION_END_SCALE: CGFloat = 0.7
    static private var ANIMATION_START_ALPHA: CGFloat = 0.1
    
    static private var DEFAULT_COLOR = UIColor.black.withAlphaComponent(0.62)
    static private var DEFAULT_CORNER_RADIUS: CGFloat = 12.0
    static private var DEFAULT_SHADOW_OPACITY: Float = 0.7
    static private var DEFAULT_SHADOW_OFFSET = CGSize(width: 0.0, height: 2.0)
    static private var DEFAULT_TEXT_COLOR = UIColor.white
    static private var DEFAULT_BUTTON_COLOR = UIColor(red: 70.0/255.0, green: 128.0/255.0, blue: 196.0/255.0, alpha: 1.0)
    
    
    init(withArrowDirection arrowDirection: UCPopoverArrowDirection) {
        self.arrowDirection = arrowDirection
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(withText text: String, arrowDirection: UCPopoverArrowDirection = .none) {
        self.init(withArrowDirection: arrowDirection)
        
        let label = UILabel.uc_defaultLabel(withText: text)
        view.addSubview(label)
        
        let inset = UCPopoverBubble.CONTENT_INSET
        label.leadingAnchor.constraint(equalTo: label.superview!.leadingAnchor, constant: inset).isActive = true
        label.trailingAnchor.constraint(equalTo: label.superview!.trailingAnchor, constant: -inset).isActive = true
        label.topAnchor.constraint(equalTo: label.superview!.topAnchor, constant: inset).isActive = true
        label.bottomAnchor.constraint(equalTo: label.superview!.bottomAnchor, constant: -inset).isActive = true
        _textLabel = label
        
        if arrowDirection != .none {
            let arrowDim = CGSize(width: 16.0, height: 16.0)
            let arrowPath = CGMutablePath()
            
            switch arrowDirection {
            case .up, .down:
                let arrowBaseY = (arrowDirection == .up ? 0.0 : -arrowDim.height)
                let arrowPointY = (arrowDirection == .up ? -arrowDim.height : 0.0)
                arrowPath.move(to: CGPoint(x: 0.0, y: arrowBaseY))
                arrowPath.addLine(to: CGPoint(x: arrowDim.width/2.0, y: arrowPointY))
                arrowPath.addLine(to: CGPoint(x: arrowDim.width, y: arrowBaseY))
            case .left, .right:
                let arrowBaseX = (arrowDirection == .right ? 0.0 : arrowDim.width)
                let arrowPointX = (arrowDirection == .right ? arrowDim.width : 0.0)
                arrowPath.move(to: CGPoint(x: arrowBaseX, y: -arrowDim.height))
                arrowPath.addLine(to: CGPoint(x: arrowPointX, y: -arrowDim.height/2.0))
                arrowPath.addLine(to: CGPoint(x: arrowBaseX, y: 0.0))
            default: break
            }
            
            arrowPath.closeSubpath()
            
            let arrowLayer = CAShapeLayer()
            arrowLayer.fillColor = UCPopoverBubble.DEFAULT_COLOR.cgColor
            arrowLayer.frame = CGRect(x: 0.0, y: 0.0, width: arrowDim.width, height: arrowDim.height)
            arrowLayer.path = arrowPath
            
            view.layer.addSublayer(arrowLayer)
            _arrowLayer = arrowLayer
        }
    }
    
    convenience init(withText text: String, buttonTitles: [String]) {
        var buttons: [UIButton] = []
        for title in buttonTitles {
            let button = UIButton.uc_defaultButton(withTitle: title)
            buttons.append(button)
        }
        
        self.init(withText: text, buttons: buttons)
    }
    
    convenience init(withText text: String, buttons: [UIButton]) {
        self.init(withArrowDirection: .none)
        
        let label = UILabel.uc_defaultLabel(withText: text)
        view.addSubview(label)
        
        let inset = UCPopoverBubble.CONTENT_INSET
        label.leadingAnchor.constraint(equalTo: label.superview!.leadingAnchor, constant: inset).isActive = true
        label.trailingAnchor.constraint(equalTo: label.superview!.trailingAnchor, constant: -inset).isActive = true
        label.topAnchor.constraint(equalTo: label.superview!.topAnchor, constant: inset).isActive = true
        _textLabel = label
        
        assert(buttons.count > 0, "")
        
        var lastButton: UIButton?
        var buttonTag = 0
        for button in buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = buttonTag
            button.addTarget(self, action: #selector(__buttonPressed(_:)), for: .touchUpInside)
            
            view.addSubview(button)
            
            if button.constraints.count == 0 {
                button.leadingAnchor.constraint(equalTo: button.superview!.leadingAnchor, constant: inset).isActive = true
                button.trailingAnchor.constraint(equalTo: button.superview!.trailingAnchor, constant: -inset).isActive = true
            } else {
                button.centerXAnchor.constraint(equalTo: button.superview!.centerXAnchor).isActive = true
            }
            
            if lastButton != nil {
                button.topAnchor.constraint(equalTo: lastButton!.bottomAnchor, constant: 8.0).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: inset).isActive = true
            }
            
            buttonTag += 1
            lastButton = button
        }
        
        lastButton!.bottomAnchor.constraint(equalTo: lastButton!.superview!.bottomAnchor, constant: -inset).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = UCPopoverBubble.DEFAULT_COLOR
        v.layer.cornerRadius = UCPopoverBubble.DEFAULT_CORNER_RADIUS
        v.layer.shadowOpacity = UCPopoverBubble.DEFAULT_SHADOW_OPACITY
        v.layer.shadowOffset = UCPopoverBubble.DEFAULT_SHADOW_OFFSET
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if arrowDirection != .none {
            assert(_arrowLayer != nil, "Missing arrow layer when arrow direction is not 'none'.")
            let arrowDim = _arrowLayer!.frame.size
            
            // NOTE(christian): Get the layout size matching the constraints instead of using the view's frame directly in case the popover is being presented
            // with animation, since the animation of the view's transform affects its frame, causing the calculations here to be wrong for its final position.
            // i.e. The _final_ size/origin values need to be used to calculate the arrow's position, or else it will be wrong when animating the popover.
            let layoutSize = view.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
            
            let centerX = layoutSize.width/2.0 - arrowDim.width/2.0
            let centerY = layoutSize.height/2.0 + arrowDim.height/2.0
            var frameOrigin: CGPoint!
            
            switch arrowDirection {
            case .up:
                _centerOffset.y += (layoutSize.height/2.0 + arrowDim.height)
                frameOrigin = CGPoint(x: centerX, y: 0.0)
            case .down:
                _centerOffset.y -= (layoutSize.height/2.0 + arrowDim.height)
                frameOrigin = CGPoint(x: centerX, y: layoutSize.height + arrowDim.height)
            case .left:
                _centerOffset.x += (layoutSize.width/2.0 + arrowDim.width)
                frameOrigin = CGPoint(x: -arrowDim.width, y: centerY)
            case .right:
                _centerOffset.x -= (layoutSize.width/2.0 + arrowDim.width)
                frameOrigin = CGPoint(x: layoutSize.width, y: centerY)
            default: break
            }
            
            // NOTE(christian): Calculate the popover's layout origin based on it's center and size calculated above in case presentation is animated.
            let center = CGPoint(x: view.center.x + _centerOffset.x, y: view.center.y + _centerOffset.y)
            let layoutOrigin = CGPoint(x: center.x - layoutSize.width/2.0, y: center.y - layoutSize.height/2.0)
            
            let minEdgeMargin = UCPopoverBubble.MIN_EDGE_MARGIN
            if arrowDirection == .up || arrowDirection == .down {
                if layoutOrigin.x < minEdgeMargin {
                    frameOrigin.x += (layoutOrigin.x - minEdgeMargin)
                }
                
                let rightEdgeX = layoutOrigin.x + layoutSize.width
                if rightEdgeX > view.superview!.frame.width - minEdgeMargin {
                    frameOrigin.x += (rightEdgeX - view.superview!.frame.width + minEdgeMargin)
                }
            }
            
            if arrowDirection == .left || arrowDirection == .right {
                if layoutOrigin.y < minEdgeMargin {
                    frameOrigin.y += (layoutOrigin.y - minEdgeMargin)
                }
                
                let bottomEdgeY = layoutOrigin.y + layoutSize.height
                if bottomEdgeY > view.superview!.frame.height - minEdgeMargin {
                    frameOrigin.y += (bottomEdgeY - view.superview!.frame.height + minEdgeMargin)
                }
            }
            
            _arrowLayer?.frame = CGRect(x: frameOrigin.x, y: frameOrigin.y, width: arrowDim.width, height: arrowDim.height)
        }
        
        _centerXConstraint.constant = _centerOffset.x
        _centerYConstraint.constant = _centerOffset.y
    }
    
    @objc private func __buttonPressed(_ sender: Any?) {
        let button = sender as! UIButton
        buttonHandler?(self, button.tag)
    }
    
    
    //# MARK: Public interface
    
    func present(animated: Bool) {
        if let visibleVC = UCGetVisibleViewController() {
            present(inViewController: visibleVC, animated: animated)
        }
    }
    
    func present(inViewController viewController: UIViewController, animated: Bool) {
        let parentView = viewController.view!
        let at = parentView.center
        
        present(inViewController: viewController, at: at, animated: animated)
    }
    
    func present(at: CGPoint, animted: Bool) {
        if let visibleVC = UCGetVisibleViewController() {
            present(inViewController: visibleVC, at: at, animated: animted)
        }
    }
    
    func present(inViewController viewController: UIViewController, at: CGPoint, animated: Bool) {
        viewController.addChildViewController(self)
        let parentView = viewController.view!
        
        view.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(view)
        _centerXConstraint = view.centerXAnchor.constraint(equalTo: view.superview!.centerXAnchor)
        _centerYConstraint = view.centerYAnchor.constraint(equalTo: view.superview!.centerYAnchor)
        _centerXConstraint.priority = .defaultHigh
        _centerYConstraint.priority = .defaultHigh
        _centerXConstraint.isActive = true
        _centerYConstraint.isActive = true
        
        // NOTE(christian): These constraints prevent the popover from clipping its superview due to its size and position.
        // These constraints have a higher priority than the center positioning constraints, which will cause them to break if
        // these can't be satisfied.
        let minEdgeMargin = UCPopoverBubble.MIN_EDGE_MARGIN
        view.leadingAnchor.constraint(greaterThanOrEqualTo: view.superview!.leadingAnchor, constant: minEdgeMargin).isActive = true
        view.trailingAnchor.constraint(lessThanOrEqualTo: view.superview!.trailingAnchor, constant: -minEdgeMargin).isActive = true
        view.topAnchor.constraint(greaterThanOrEqualTo: view.superview!.topAnchor, constant: minEdgeMargin).isActive = true
        view.bottomAnchor.constraint(lessThanOrEqualTo: view.superview!.bottomAnchor, constant: -minEdgeMargin).isActive = true
        
        _centerOffset = CGPoint(x: at.x - parentView.center.x, y: at.y - parentView.center.y)
        
        if animated {
            let startAlpha = UCPopoverBubble.ANIMATION_START_ALPHA
            let startScale = UCPopoverBubble.ANIMATION_START_SCALE
            view.alpha = startAlpha
            view.transform = CGAffineTransform(scaleX: startScale, y: startScale)
            
            UIView.uc_animate(withDuration: 0.3, timingFunc: UCEasing.easeOutBack, animations: {
                self.view.uc_transform = CGAffineTransform.identity
                self.view.uc_alpha = 1.0
            }, completion: {
                self.didMove(toParentViewController: viewController)
            })
        } else {
            didMove(toParentViewController: viewController)
        }
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        self.willMove(toParentViewController: nil)
        
        if animated {
            let endScale = UCPopoverBubble.ANIMATION_END_SCALE
            UIView.uc_animate(withDuration: 0.26, timingFunc: UCEasing.easeOutQuad, animations: {
                self.view.uc_transform = CGAffineTransform(scaleX: endScale, y: endScale)
                self.view.uc_alpha = 0.0
            }, completion: {
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
                completion?()
            })
        } else {
            view.removeFromSuperview()
            removeFromParentViewController()
            completion?()
        }
    }
    
}


//# MARK: - Utilities

fileprivate func UCGetVisibleViewController() -> UIViewController? {
    var visibleVC: UIViewController?
    let keyWindow = UIApplication.shared.keyWindow
    if let rootVC = keyWindow?.rootViewController {
        if rootVC.isKind(of: UINavigationController.self) {
            visibleVC = (rootVC as! UINavigationController).visibleViewController
        } else if rootVC.isKind(of: UITabBarController.self) {
            visibleVC = (rootVC as! UITabBarController).selectedViewController
        } else if rootVC.isKind(of: UIViewController.self) {
            visibleVC = rootVC
            while visibleVC?.presentedViewController != nil {
                visibleVC = visibleVC?.presentedViewController
            }
        }
    } else {
        assertionFailure("[UCPopoverBubble] No root view controller found on key window.")
    }
    
    assert(visibleVC != nil, "[UCPopoverBubble] Could not determine visible view controller from current view controller hierarchy.")
    return visibleVC
}


//# MARK: - Extensions

extension UILabel {
    class func uc_defaultLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        return label
    }
}

extension UIButton {
    class func uc_defaultButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        
        return button
    }
}


//# MARK: - Custom UIView animation

extension UIView {

    var uc_alpha: CGFloat {
        set {
            let baseValue = self.alpha
            let targetValue = newValue
            
            if let latestState = ucAnimationStates.last {
                let alphaUpdateBlock = latestState.propertyUpdateBlock(withTweenBlock: { t in
                    let val = UCLerp(a: baseValue, t: t, b: targetValue)
                    self.alpha = val
                })
                
                __uc_addAnimationPropertyTimer(toState: latestState, withUpdateBlock: alphaUpdateBlock)
            }
        }
        
        get {
            return self.alpha
        }
    }
    
    var uc_transform: CGAffineTransform {
        set {
            let baseValue = self.transform
            let targetValue = newValue
            
            if let latestState = ucAnimationStates.last {
                let transformUpdateBlock = latestState.propertyUpdateBlock(withTweenBlock: { t in
                    let val = CGAffineTransform(a: UCLerp(a: baseValue.a, t: t, b: targetValue.a),
                                                b: UCLerp(a: baseValue.b, t: t, b: targetValue.b),
                                                c: UCLerp(a: baseValue.c, t: t, b: targetValue.c),
                                                d: UCLerp(a: baseValue.d, t: t, b: targetValue.d),
                                                tx: UCLerp(a: baseValue.tx, t: t, b: targetValue.tx),
                                                ty: UCLerp(a: baseValue.ty, t: t, b: targetValue.ty))
                    self.transform = val
                })
                
                __uc_addAnimationPropertyTimer(toState: latestState, withUpdateBlock: transformUpdateBlock)
            }
        }
        
        get {
            return self.transform
        }
    }
    
    class func uc_animate(withDuration duration: TimeInterval, timingFunc:@escaping (CGFloat,CGFloat) -> TimeInterval, animations:() -> Void, completion:@escaping () -> Void) {
        let state = UCAnimationState(withDuration: duration)
        state.timingFunc = timingFunc
        state.completionFunc = completion
        
        ucAnimationStates.append(state)
        
        animations()
        
        state.launchQueuedAnimations()
    }
    
    private func __uc_addAnimationPropertyTimer(toState state: UCAnimationState, withUpdateBlock updateBlock: (Timer) -> Void) {
        let timer = Timer(timeInterval: ucAnimationFrameTime, target: self, selector: #selector(__uc_updateAnimationFrame(_:)), userInfo: updateBlock, repeats: true)
        state.timers.append(timer)
    }
    
    @objc private func __uc_updateAnimationFrame(_ timer: Timer) {
        let updateBlock: (Timer) -> Void = timer.userInfo as! (Timer) -> Void
        updateBlock(timer)
    }
}

fileprivate class UCAnimationState {
    var timingFunc: ((CGFloat,CGFloat) -> TimeInterval)?
    var completionFunc: (() -> Void)?
    var timers: [Timer] = []
    
    private var _duration: TimeInterval
    private var _timersCompleted: Int
    
    
    init(withDuration duration: TimeInterval) {
        _duration = duration
        _timersCompleted = 0
    }
    
    func launchQueuedAnimations() {
        for timer in timers {
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        }
    }
    
    func checkAndCompleteTimerIfNeeded(_ timer: Timer, withCurrentTime currentTime: TimeInterval) {
        if currentTime >= _duration {
            timer.invalidate()
            
            _timersCompleted += 1
            if _timersCompleted == timers.count {
                completionFunc!()
                
                completionFunc = nil
                timingFunc = nil
                timers.removeAll()
                _timersCompleted = 0
                
                if let index = ucAnimationStates.index(where: { state -> Bool in
                    return state === self
                }) {
                    ucAnimationStates.remove(at: index)
                }
            }
        }
    }
    
    func propertyUpdateBlock(withTweenBlock tweenBlock: @escaping (TimeInterval) -> Void) -> ((Timer) -> Void) {
        var currentTime = 0.0
        let duration = _duration
        let updateBlock: (Timer) -> Void = { timer in
            currentTime += timer.timeInterval
            let t = self.timingFunc!(CGFloat(currentTime), CGFloat(duration))
            
            tweenBlock(t)
            
            self.checkAndCompleteTimerIfNeeded(timer, withCurrentTime: currentTime)
        }
        
        return updateBlock
    }
    
}

fileprivate var ucAnimationStates: [UCAnimationState] = []
fileprivate let ucAnimationFrameTime = 1.0/60.0 // 60 fps

fileprivate func UCLerp(a: CGFloat, t: TimeInterval, b: CGFloat) -> CGFloat {
    let t = CGFloat(t)
    return (a * (1.0 - t) + b * t)
}


//# MARK: - Easing functions

class UCEasing {
    
    static let easeOutBack: (CGFloat,CGFloat) -> TimeInterval = { t, d in
        let s = 1.70158
        var t = TimeInterval(t)
        t = t/TimeInterval(d) - 1.0
        return (t * t * ((s + 1.0) * t + s) + 1.0)
    }
    
    static let easeOutQuad: (CGFloat,CGFloat) -> TimeInterval = { t, d in
        var t = TimeInterval(t)
        t /= TimeInterval(d)
        return (-1.0 * t * (t - 2.0))
    }
    
}
