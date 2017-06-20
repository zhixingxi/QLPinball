//
//  ViewController.swift
//  QLPinball
//
//  Created by MQL-IT on 2017/6/20.
//  Copyright © 2017年 MQL-IT. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    /// 球数组
    fileprivate lazy var balls = [UIImageView]()
    /// UIDynamicAnimator对象, 物理元素行为的容器
    fileprivate var animatorContainer: UIDynamicAnimator!
    /// 重力动作
    fileprivate var gravityBehavior: UIGravityBehavior!
    /// 碰撞动作
    fileprivate var collisionBehavior: UICollisionBehavior!
    /// 动力元素行为
    fileprivate var dynamicItemBehavior: UIDynamicItemBehavior!
    /// CoreMotion管理器
    fileprivate let motionManager = CMMotionManager()
    
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建球元素
        creatBalls()
        //添加元素特性
        creatBehavior()
        //捕捉设备motion
        // 设置捕捉间隔
        motionManager.deviceMotionUpdateInterval = 0.005
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) {[weak self] (motion, error) in
            let yaw = motion?.attitude.yaw
            let pitch = motion?.attitude.pitch
            let roll = motion?.attitude.roll
            guard let yw = yaw,
                let ptch = pitch,
                let rll = roll else { return }
            let rotation = atan2(ptch, rll)
            self?.gravityBehavior.angle = CGFloat(rotation)
            
            print("yaw: \(yw)\n pitch: \(ptch)\n roll:\(rll)\n rotation:\(rotation)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

}

//MARK: - 创建球 和 物理元素行为
extension ViewController {
    // 球(元素)
    fileprivate func creatBalls() {
        // 创建12个球
        for _ in 0...12 {
            let ball = UIImageView()
            let i = (Int)(arc4random() % 8)
            print(i)
            ball.image = UIImage(named: "ball-\(i).jpg")
            // 设置球的大小
            let width: CGFloat = 40.0
            ball.layer.cornerRadius = width / 2
            ball.layer.masksToBounds = true
            let x = arc4random() % (UInt32)(self.view.bounds.size.width - width)
            ball.frame = CGRect(x: CGFloat(x), y: 0, width: width, height: width)
            // 添加球到视图和数组
            view.addSubview(ball)
            balls.append(ball)
        }
    }
    
    // 元素行为
    fileprivate func creatBehavior() {
        //容器
        animatorContainer = UIDynamicAnimator(referenceView: self.view)
        
        //重力
        gravityBehavior = UIGravityBehavior(items: balls)
        animatorContainer.addBehavior(gravityBehavior)
        
        // 碰撞
        collisionBehavior = UICollisionBehavior(items: balls)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animatorContainer.addBehavior(collisionBehavior)
        
        //元素行为
        dynamicItemBehavior = UIDynamicItemBehavior(items: balls)
        dynamicItemBehavior.allowsRotation = true
        // 弹性
        dynamicItemBehavior.elasticity = 0.7
        animatorContainer.addBehavior(dynamicItemBehavior)
        
    }
}

