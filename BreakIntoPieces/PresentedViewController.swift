//
//  PresentedViewController.swift
//  BreakIntoPieces
//
//  Created by Sharma Elanthiraiyan on 17/08/15.
//  Copyright (c) 2015 Sharma Elanthiraiyan. All rights reserved.
//

import UIKit
struct BrokenPiece {
    let image: UIImage
    let frame: CGRect
}

class PresentedViewController: UIViewController {
    var animator: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func close(sender: AnyObject) {
        
        
        let image = imageWithView(self.view)
        
        if let parentView = self.presentingViewController?.view {
            let imageView = UIImageView(image: imageWithView(parentView))
            self.view.addSubview(imageView)
        }
        
        let containerView = UIView(frame: self.view.frame)
        self.view.addSubview(containerView)
        animator = UIDynamicAnimator(referenceView: containerView)
        
        let brokenPieces = splitIntoPieces(image)
        var imageViews = [UIImageView]()
        for piece in brokenPieces {
            let imageView = UIImageView(image: piece.image)
            imageView.frame = piece.frame
            containerView.addSubview(imageView)
            
            imageViews.append(imageView)
        }
        
        
        let elasticityBehaviuor = UIDynamicItemBehavior(items: imageViews)
        elasticityBehaviuor.elasticity = 0.1
//        animator.addBehavior(elasticityBehaviuor)
        
        let collision = UICollisionBehavior(items: imageViews)
        collision.addBoundaryWithIdentifier("boundary", forPath: UIBezierPath(rect: containerView.frame))
        animator.addBehavior(collision)
        
        let pushFromLeft = UIPushBehavior(items: imageViews, mode: .Instantaneous)
        pushFromLeft.setAngle(( 2 * CGFloat(M_PI)), magnitude: 0.1)
//        animator.addBehavior(pushFromLeft)
        
        let pushFromRight = UIPushBehavior(items: imageViews, mode: .Instantaneous)
        pushFromRight.setAngle(3/4 * (CGFloat(M_PI)), magnitude: 0.1)
        animator.addBehavior(pushFromRight)
        
        let pushFromBottom = UIPushBehavior(items: imageViews, mode: .Instantaneous)
        pushFromBottom.setAngle((1/2 * CGFloat(M_PI)), magnitude: 0.4)
//        animator.addBehavior(pushFromBottom)
        
        
        var triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            collision.removeAllBoundaries()
            
            let gravityBehaviour = UIGravityBehavior(items: imageViews)
            gravityBehaviour.magnitude = 0.2
            self.animator.addBehavior(gravityBehaviour)
        })
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64(NSEC_PER_SEC) * 4)), dispatch_get_main_queue(), { () -> Void in
            self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
    
    
    func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, UIScreen.mainScreen().scale)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func splitIntoPieces(image: UIImage) -> [BrokenPiece] {
        
        let height = image.size.height * image.scale
        let width  = image.size.width * image.scale
        
        var subImages = [BrokenPiece]()
        
        let rows = 30 as CGFloat
        let clms = 20 as CGFloat
        
        for(var y = 0 as CGFloat; y < rows; y++) {
            for(var x = 0.0 as CGFloat; x < clms; x++) {
                let frame = CGRectMake((width / clms) * x, (height / rows) * y, (width / clms), (height / rows));
                
                var subimageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
                if let subImage = UIImage(CGImage: subimageRef, scale: 0.0, orientation: .Up) {
                    let frame  = CGRectMake((image.size.width / clms) * x, (image.size.height / rows) * y, (image.size.width / clms), (image.size.height / rows))
                    let brokenPiece = BrokenPiece(image: subImage, frame: frame)
                    subImages.append(brokenPiece)
                }
            }
        }
        return subImages
    }
}
