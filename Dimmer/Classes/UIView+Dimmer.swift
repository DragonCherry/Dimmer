//
//  UIView+Loading.swift
//  Pods
//
//  Created by DragonCherry on 3/17/17.
//
//

import UIKit
import TinyLog
import PureLayout
import UIViewKVO

fileprivate let kDimmerLayoutConstraints		= "kUIViewAttachLayoutConstraints"
fileprivate let kUIViewAttachActivityIndicator      = "kUIViewAttachActivityIndicator"
fileprivate let kUIViewAttachActivityIndicatorDim   = "kUIViewAttachActivityIndicatorDim"

public enum UIViewEffectDirection {
    case solid
    case fromTop
    case fromLeft
    case fromBottom
    case fromRight
}

fileprivate let kUIViewDimViewIdentifier = "kUIViewDimViewIdentifier"
fileprivate let kUIViewDimRatioIdentifier = "kUIViewDimRatioIdentifier"

public extension UIView {
    
    public func showLoading(alpha: CGFloat = 0, style: UIActivityIndicatorViewStyle = .gray) {
        if let _ = self.viewForKey(kUIViewAttachActivityIndicator) {
            // do nothing
        } else {
            let dim = UIView(frame: bounds)
            attach(dim, key: kUIViewAttachActivityIndicatorDim)
            dim.backgroundColor = .black
            dim.alpha = alpha
            dim.autoPinEdgesToSuperviewEdges()
            
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: style)
            attach(indicator, key: kUIViewAttachActivityIndicator)
            indicator.startAnimating()
            indicator.autoSetDimensions(to: CGSize(width: 40, height: 40))
            indicator.autoCenterInSuperview()
        }
    }
    
    public func loadingDimView() -> UIView? {
        return viewForKey(kUIViewAttachActivityIndicatorDim)
    }
    
    public func loadingIndicatorView() -> UIView? {
        return viewForKey(kUIViewAttachActivityIndicator)
    }
    
    public func hideLoading() {
        if let _ = viewForKey(kUIViewAttachActivityIndicator) {
            _ = detach(key: kUIViewAttachActivityIndicator, fade: true)
        }
        if let _ = viewForKey(kUIViewAttachActivityIndicatorDim) {
            _ = detach(key: kUIViewAttachActivityIndicatorDim, fade: true)
        }
    }
}



public extension UIView {

    public var dimmer: UIView {
        let view = UIView()
	
	return view
    }
    
    public func dim(_ from: UIViewEffectDirection = .solid, ratio: CGFloat = 1, alpha: CGFloat = 0.4, duration: TimeInterval = 0.25, completion: ((CGFloat) -> Void)? = nil) {
        
        func moveDimView(_ dimView: UIView) {
            var fixedRatio: CGFloat = ratio
            if ratio > 1 {
                fixedRatio = 1
            }
            if ratio < 0 {
                fixedRatio = 0
            }
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {
                    
                    var origin: CGPoint!
                    var dimWidth: CGFloat = 0
                    var dimHeight: CGFloat = 0
                    
                    switch from {
                    case .solid:
                        dimWidth = self.bounds.width
                        dimHeight = self.bounds.height
                    case .fromTop, .fromBottom:
                        dimWidth = self.bounds.width
                        dimHeight = fixedRatio * self.height
                    case .fromLeft, .fromRight:
                        dimWidth = fixedRatio * self.width
                        dimHeight = self.bounds.height
                    }
                    
                    switch from {
                    case .solid, .fromTop, .fromLeft:
                        origin = CGPoint.zero
                    case .fromBottom:
                        origin = CGPoint(x: 0, y: self.height - dimHeight)
                    case .fromRight:
                        origin = CGPoint(x: self.width - dimWidth, y: 0)
                    }
                    
                    dimView.frame = CGRect(origin: origin, size: CGSize(width: dimWidth, height: dimHeight))
                    self.set(fixedRatio, forKey: kUIViewDimRatioIdentifier)
                    
                }, completion: { finished in
                    if finished {
                        completion?(fixedRatio)
                    }
                }
            )
            set(cgfloat(fixedRatio), forKey: kUIViewDimRatioIdentifier)
        }
        
        if let dimView = viewForKey(kUIViewDimViewIdentifier) {
            moveDimView(dimView)
        } else {
            
            let dimView = UIView(frame: CGRect(origin: CGPoint.zero, size: bounds.size))
            dimView.alpha = alpha
            dimView.backgroundColor = .black
            
            var origin: CGPoint!
            var dimWidth: CGFloat = 0
            var dimHeight: CGFloat = 0

            switch from {
            case .solid, .fromTop, .fromLeft:
                origin = CGPoint.zero
            case .fromBottom:
                origin = CGPoint(x: 0, y: height)
            case .fromRight:
                origin = CGPoint(x: width, y: 0)
            }
            
            switch from {
            case .solid:
                dimWidth = bounds.width
                dimHeight = bounds.height
            case .fromTop, .fromBottom:
                dimWidth = bounds.width
                dimHeight = 0
            case .fromLeft, .fromRight:
                dimWidth = 0
                dimHeight = bounds.height
            }
            
            dimView.frame = CGRect(origin: origin, size: CGSize(width: dimWidth, height: dimHeight))
            attach(dimView, key: kUIViewDimViewIdentifier)
            moveDimView(dimView)
        }
    }
    
    public func undim(_ animated: Bool = true) {
        detach(key: kUIViewDimViewIdentifier, fade: animated)
    }
    
    public func dimRatio() -> CGFloat {
        return cgfloat(get(kUIViewDimRatioIdentifier))
    }
}