//
//  UIView+Dimmer.swift
//  Pods
//
//  Created by DragonCherry on 5/12/17.
//
//

import UIKit
import SnapKit
import FadeView

fileprivate let kDimmerViewKey                          = "kDimmerViewKey"
fileprivate let kDimmerView                             = "kDimmerView"
fileprivate let kDimmerViewRatio                        = "kDimmerViewRatio"
fileprivate let kDimmerActivityIndicatorView            = "kDimmerActivityIndicatorView"

fileprivate let kDimmerWidthConstraint                  = "kDimmerWidthConstraint"
fileprivate let kDimmerHeightConstraint                 = "kDimmerHeightConstraint"

public enum DimmerEffectDirection {
    case solid
    case fromTop
    case fromLeft
    case fromBottom
    case fromRight
}

// MARK: - Internal Utilities
extension UIView {
    
    fileprivate var dimmerWidthConstraint: LayoutConstraint? {
        set { set(newValue, forKey: kDimmerWidthConstraint) }
        get { return get(kDimmerWidthConstraint) as? LayoutConstraint }
    }
    
    fileprivate var dimmerHeightConstraint: LayoutConstraint? {
        set { set(newValue, forKey: kDimmerHeightConstraint) }
        get { return get(kDimmerHeightConstraint) as? LayoutConstraint }
    }
    
    fileprivate func createDimmerView(color: UIColor = .black, alpha: CGFloat = 0.4) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.alpha = alpha
        return view
    }
    
    fileprivate func createDimmerActivityView(style: UIActivityIndicatorView.Style = .gray) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        return activityIndicator
    }
    
    fileprivate func excludingEdge(with direction: DimmerEffectDirection) -> UIRectEdge {
        switch direction {
        case .fromTop:
            return .bottom
        case .fromLeft:
            return .right
        case .fromBottom:
            return .top
        case .fromRight:
            return .left
        case .solid:
            return .left
        }
    }
    
    fileprivate func clearKVO() {
        
        dimmerView?.removeFromSuperview()
        dimmerActivityView?.removeFromSuperview()
        
        dimmerWidthConstraint = nil
        dimmerHeightConstraint = nil
        
        set(nil, forKey: dimmerKey ?? kDimmerView)
        set(nil, forKey: kDimmerActivityIndicatorView)
        set(nil, forKey: kDimmerViewRatio)
    }
}

// MARK: - Gradient
extension UIView {
    
    private var kUIViewGradientLayer: String { return "kUIViewGradientLayer" }
    
    open func setGradient(_ direction: DimmerEffectDirection, start: CGFloat = 0, end: CGFloat = 1, startAlpha: CGFloat = 1, color: UIColor) {
        
        // 1. init common variables
        let effectLayer = CAGradientLayer()
        effectLayer.frame = bounds
        effectLayer.colors = [
            color.withAlphaComponent(startAlpha).cgColor,
            color.withAlphaComponent(0).cgColor
        ]
        
        // 2. set for each style
        switch direction {
        case .fromTop:
            effectLayer.startPoint = CGPoint(x: 0.5, y: start)
            effectLayer.endPoint = CGPoint(x: 0.5, y: end)
        case .fromLeft:
            effectLayer.startPoint = CGPoint(x: start, y: 0.5)
            effectLayer.endPoint = CGPoint(x: end, y: 0.5)
        case .fromBottom:
            effectLayer.startPoint = CGPoint(x: 0.5, y: 1 - start)
            effectLayer.endPoint = CGPoint(x: 0.5, y: 1 - end)
        case .fromRight:
            effectLayer.startPoint = CGPoint(x: 1 - start, y: 0.5)
            effectLayer.endPoint = CGPoint(x: 1 - end, y: 0.5)
        default:
            effectLayer.startPoint = CGPoint(x: 0.5, y: start)
            effectLayer.endPoint = CGPoint(x: 0.5, y: end)
        }
        
        // 3. check layer
        if let oldLayer = get(kUIViewGradientLayer) as? CAGradientLayer {
            oldLayer.removeFromSuperlayer()
        }
        layer.addSublayer(effectLayer)
        set(effectLayer, forKey: kUIViewGradientLayer)
    }
    
    open func removeGradient() {
        if let gradientLayer = get(kUIViewGradientLayer) as? CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
            set(nil, forKey: kUIViewGradientLayer)
        }
    }
}

// MARK: - Dimming
extension UIView {
    
    var dimmerKey: String? {
        get { return get(kDimmerViewKey) as? String }
        set { set(newValue, forKey: kDimmerViewKey) }
    }
    
    open var dimmingRatio: CGFloat {
        get { return CGFloat((get(kDimmerViewRatio) as? CGFloat) ?? 0) }
        set { set(newValue, forKey: kDimmerViewRatio) }
    }
    
    open var isDimming: Bool {
        if let dimmerView = dimmerView, !dimmerView.isHidden && dimmingRatio > 0 {
            return true
        } else {
            return false
        }
    }
    
    open var dimmerView: UIView? {
        get { return get(dimmerKey ?? kDimmerView) as? UIView }
        set {
            if let newDimmerView = newValue {
                if let oldDimmerView = dimmerView {
                    if oldDimmerView !== newDimmerView {
                        clearKVO()
                    }
                }
                set(newDimmerView, forKey: dimmerKey ?? kDimmerView)
            } else {
                if let _ = dimmerView {
                    clearKVO()
                }
            }
        }
    }
    
    open var dimmerActivityView: UIView? {
        get { return get(kDimmerActivityIndicatorView) as? UIView }
        set {
            if let newDimmerActivityView = newValue {
                if let oldDimmerActivityView = dimmerActivityView {
                    if oldDimmerActivityView !== newDimmerActivityView {
                        clearKVO()
                    }
                }
                set(newDimmerActivityView, forKey: kDimmerActivityIndicatorView)
            } else {
                if let _ = dimmerActivityView {
                    clearKVO()
                }
            }
        }
    }
    
    open func dim(animated: Bool = true, direction: DimmerEffectDirection = .solid, color: UIColor = .black, alpha: CGFloat = 0.4, ratio: CGFloat = 1, completion: ((CGFloat) -> Void)? = nil) {
        
        let updateRatio: (() -> Void) = {
            if self.dimmingRatio != ratio {
                switch direction {
                case .fromTop, .fromBottom:
                    self.dimmerHeightConstraint?.constant = ratio
                case .fromLeft, .fromRight:
                    self.dimmerWidthConstraint?.constant = ratio
                default:
                    break
                }
                self.dimmingRatio = ratio
            }
        }
        
        if let _ = self.dimmerView {
            updateRatio()
        } else {
            let dimmer = createDimmerView(color: color, alpha: alpha)
            if animated {
                fadeInSubview(dimmer)
            } else {
                addSubview(dimmer)
            }
            
            dimmer.snp.remakeConstraints { (make) in
                if direction == .solid {
                    make.edges.equalToSuperview()
                } else {
                    let edge = self.excludingEdge(with: direction)
                    switch edge {
                    case .top:
                        make.leading.equalToSuperview()
                        make.bottom.equalToSuperview()
                        make.trailing.equalToSuperview()
                    case .left:
                        make.top.equalToSuperview()
                        make.bottom.equalToSuperview()
                        make.trailing.equalToSuperview()
                    case .bottom:
                        make.top.equalToSuperview()
                        make.leading.equalToSuperview()
                        make.trailing.equalToSuperview()
                    case .right:
                        make.top.equalToSuperview()
                        make.leading.equalToSuperview()
                        make.bottom.equalToSuperview()
                    default:
                        break
                    }
                    switch direction {
                    case .fromTop, .fromBottom:
                        let constraint = make.height.equalToSuperview().multipliedBy(ratio)
                        dimmerHeightConstraint = constraint.constraint.layoutConstraints.first
                    case .fromLeft, .fromRight:
                        let constraint = make.width.equalToSuperview().multipliedBy(ratio)
                        dimmerWidthConstraint = constraint.constraint.layoutConstraints.first
                    default:
                        break
                    }
                }
            }
            dimmerView = dimmer
            updateRatio()
        }
    }
    
    open func undim(animated: Bool = true) {
        if animated {
            dimmerView?.fadeOutFromSuperview(completion: {
                self.clearKVO()
            })
        } else {
            dimmerView?.removeFromSuperview()
            clearKVO()
        }
    }
}

// MARK: - Loading
extension UIView {
    
    open var isLoading: Bool {
        if let _ = get(kDimmerActivityIndicatorView), dimmingRatio > 0 {
            return true
        } else {
            return false
        }
    }
    
    open func showLoading(animated: Bool = true, customView: UIView? = nil, color: UIColor = .black, alpha: CGFloat = 0.4, style: UIActivityIndicatorView.Style = .gray) {
        dim(animated: animated, direction: .solid, color: color, alpha: alpha)
        if let _ = self.dimmerActivityView {
            // already loading
        } else if let view = customView {
            if animated {
                fadeInSubview(view)
            } else {
                addSubview(view)
            }
            view.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
            dimmerActivityView = view
        } else {
            let dimmerActivity = createDimmerActivityView(style: style)
            if animated {
                fadeInSubview(dimmerActivity)
            } else {
                addSubview(dimmerActivity)
            }
            dimmerActivity.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
            dimmerActivity.startAnimating()
            dimmerActivityView = dimmerActivity
        }
    }
    
    open func hideLoading(animated: Bool = true) {
        undim(animated: animated)
    }
}


