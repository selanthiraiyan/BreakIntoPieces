//
//  PresentedViewController.swift
//  BreakIntoPieces
//
//  Created by Sharma Elanthiraiyan on 17/08/15.
//  Copyright (c) 2015 Sharma Elanthiraiyan. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {
    var animator: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func close(sender: AnyObject) {
        
        
        let image = imageWithView(self.view)
        
        let containerView = UIView(frame: self.view.frame)
        containerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(containerView)
        animator = UIDynamicAnimator(referenceView: containerView)
        animator.delegate = self
        
        let brokenPieces = splitIntoPieces(image)
        var imageViews = [UIImageView]()
        for piece in brokenPieces {
            let imageView = UIImageView(image: piece.image)
            imageView.frame = piece.frame
            containerView.addSubview(imageView)
            
            imageViews.append(imageView)
            
        }
        
        
        let elasticityBehaviuor = UIDynamicItemBehavior(items: imageViews)
        elasticityBehaviuor.elasticity = 0.5
        animator.addBehavior(elasticityBehaviuor)
        
        let collision = UICollisionBehavior(items: imageViews)
        collision.addBoundaryWithIdentifier("top", fromPoint: containerView.frame.origin, toPoint: CGPointMake(containerView.frame.width, containerView.frame.origin.y))
        collision.addBoundaryWithIdentifier("left", fromPoint: containerView.frame.origin, toPoint: CGPointMake(containerView.frame.origin.x, containerView.frame.height))
        collision.addBoundaryWithIdentifier("right", fromPoint: CGPointMake(containerView.frame.width, containerView.frame.origin.y), toPoint: CGPointMake(containerView.frame.width, containerView.frame.height))
        animator.addBehavior(collision)
        
        let pushFromLeft = UIPushBehavior(items: imageViews, mode: .Instantaneous)
        pushFromLeft.setAngle(-180, magnitude: 1.0)
        animator.addBehavior(pushFromLeft)
        
        let pushFromRight = UIPushBehavior(items: imageViews, mode: .Instantaneous)
        pushFromRight.setAngle(180, magnitude: 1.0)
        animator.addBehavior(pushFromRight)

        let gravityBehaviour = UIGravityBehavior(items: imageViews)
        animator.addBehavior(gravityBehaviour)
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
        
        let rows = 12 as CGFloat
        let clms = 12 as CGFloat
        
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

extension PresentedViewController: UIDynamicAnimatorDelegate  {
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        dismissViewControllerAnimated(false, completion: nil)
    }
}
