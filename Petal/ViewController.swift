//
//  ViewController.swift
//  Petal
//
//  Created by Jing Xiao on 10/6/14.
//  Copyright (c) 2014 Jing Xiao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var background: UIImageView!
    @IBOutlet var sky: UIImageView!

    @IBOutlet var petal1: UIImageView!
    @IBOutlet var petal2: UIImageView!
    @IBOutlet var petal3: UIImageView!
    @IBOutlet var petal4: UIImageView!
    @IBOutlet var petal5: UIImageView!
    @IBOutlet var petal6: UIImageView!
    @IBOutlet var petal7: UIImageView!
    @IBOutlet var flowerCenter: UIImageView!
    @IBOutlet var flowerStalk: UIImageView!
  
    var petal1Center: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var petal2Center: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var petal3Center: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var petal4Center: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var petal5Center: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var petal6Center: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var petal7Center: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    let petalPlayer: AVAudioPlayer
    let pluckPlayer: AVAudioPlayer
    
    required init(coder aDecoder: NSCoder) {
        let petalPath = NSBundle.mainBundle().pathForResource("route29", ofType: "mp3")
        let petalURL = NSURL(fileURLWithPath: petalPath!)
        petalPlayer = AVAudioPlayer(contentsOfURL: petalURL, error: nil)
        petalPlayer.prepareToPlay()
        
        let pluckPath = NSBundle.mainBundle().pathForResource("pluck-short", ofType: "mp3")
        let pluckURL = NSURL(fileURLWithPath: pluckPath!)
        pluckPlayer = AVAudioPlayer(contentsOfURL: pluckURL, error: nil)
        pluckPlayer.prepareToPlay()
        
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petalPlayer.play()
        println("playing the petal audio")
        
        petal1Center = self.petal1!.center
        petal2Center = self.petal2!.center
        petal3Center = self.petal3!.center
        petal4Center = self.petal4!.center
        petal5Center = self.petal5!.center
        petal6Center = self.petal6!.center
        petal7Center = self.petal7!.center
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: { () -> Void in
            var backgroundFrame = self.background.frame
            backgroundFrame.origin.y += backgroundFrame.size.height/1.7
            self.background.frame = backgroundFrame
            }, completion: { finished in
                //println("Background...")
        })
    }
    
    @IBAction func handleRegrow(recognizer: UITapGestureRecognizer) {
        self.petal1!.center = petal1Center
        self.petal2!.center = petal2Center
        self.petal3!.center = petal3Center
        self.petal4!.center = petal4Center
        self.petal5!.center = petal5Center
        self.petal6!.center = petal6Center
        self.petal7!.center = petal7Center
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self.view)
        recognizer.view!.center = CGPoint(x: recognizer.view!.center.x + translation.x, y: recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)
        pluckPlayer.play()
    
        if recognizer.state == UIGestureRecognizerState.Ended {
            
            self.animate(recognizer.view!)
        }
    }
    
    func animate(view: UIView) {
        println(view.center.y)
        println(self.view.frame.size.height)
        
        let path = UIBezierPath()
        path.moveToPoint(view.center)
        
        
        
        var offsetXInit: CGFloat = -20
        var offsetYInit: CGFloat = 50
        var offsetXCtrl1: CGFloat = 70
        var offsetYCtrl1: CGFloat = 50
        var offsetXEnd: CGFloat = 110
        var offsetYEnd: CGFloat = 90
        
        let petalDropRate: CGFloat = 4.0
        let additionalPetalDropRate: CGFloat = 1.5
        let frameHeight: CGFloat = self.view.frame.size.height
        let initialHeight = view.center.y
        let initialPoint = view.center
        
        var controlPoint1
        = CGPoint(x: initialPoint.x + offsetXInit,
            y: initialPoint.y + offsetYInit)
        var controlPoint2 = CGPoint(x: controlPoint1.x + offsetXCtrl1,
            y: controlPoint1.y + offsetYCtrl1)
        var endPoint = CGPoint(x: initialPoint.x + offsetXEnd,
            y: initialPoint.y + offsetYEnd)
        
        path.addCurveToPoint(endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        while (endPoint.y < self.view.frame.size.height) {
            controlPoint1.x = endPoint.x - offsetXInit
            controlPoint1.y = endPoint.y + offsetYInit
            controlPoint2.x = controlPoint1.x - offsetXCtrl1
            controlPoint2.y = controlPoint1.y + offsetYCtrl1
            endPoint.x = endPoint.x - offsetXEnd
            endPoint.y = endPoint.y + offsetYEnd
            
            path.addCurveToPoint(endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            
            
            controlPoint1.x = endPoint.x + offsetXInit
            controlPoint1.y = endPoint.y + offsetYInit
            controlPoint2.x = controlPoint1.x + offsetXCtrl1
            controlPoint2.y = controlPoint1.y + offsetYCtrl1
            endPoint.x = endPoint.x + offsetXEnd
            endPoint.y = endPoint.y + offsetYEnd
            
            path.addCurveToPoint(endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.CGPath
        animation.duration = CFTimeInterval(petalDropRate + ((frameHeight - initialHeight) / frameHeight) *  additionalPetalDropRate) //3.5
        view.layer.addAnimation(animation, forKey: nil)
        view.center = endPoint
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
