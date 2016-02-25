//
//  PulseAnimationLayer.swift
// Copyright (c) 2016年 _Finder丶Tiwk
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

class PulseAnimationLayer: CAReplicatorLayer {

//MARK: Properties
    /// 脉冲单元图层
    private let pulseLayer = CAShapeLayer()
    
    var radius:CGFloat = 60.0{
        didSet{
            pulseLayer.path  = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: radius*2, height: radius*2)).CGPath
            pulseLayer.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: radius*2, height: radius*2))
        }
    }
    
    override var frame:CGRect{
        didSet{
            pulseLayer.position  = CGPoint(x: CGRectGetWidth(frame)/2, y:CGRectGetHeight(frame)/2)
            pulseLayer.fillColor = UIColor.redColor().CGColor
            pulseLayer.opacity   = 0.0
        }
    }
    
    func groupAnimation() -> CAAnimationGroup{
        // opacity animation
        func opacityAnimation() -> CABasicAnimation{
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = NSNumber(float: 1.0)
            animation.toValue   = NSNumber(float: 0.0)
            return animation
        }
        
        // scaleAnimation animation
        func scaleAnimation() -> CABasicAnimation{
            let animation = CABasicAnimation(keyPath: "transform")
            let t0        = CATransform3DIdentity
            let t1        = CATransform3DScale(t0, 0.0, 0.0, 0.0)
            let t2        = CATransform3DScale(t0, 1.0, 1.0, 1.0)
            
            animation.fromValue = NSValue.init(CATransform3D:t1)
            animation.toValue   = NSValue.init(CATransform3D:t2)
            return animation;
        }
        
        let groupAnimation          = CAAnimationGroup()
        groupAnimation.animations   = [opacityAnimation(),scaleAnimation()]
        groupAnimation.duration     = Double(instanceCount) * instanceDelay
        groupAnimation.autoreverses = false
        groupAnimation.repeatCount  = HUGE
        return groupAnimation
    }
    
    override func layoutSublayers() {
        pulseLayer.addAnimation(groupAnimation(), forKey: "groupAnimation")
        addSublayer(pulseLayer)
    }
}
