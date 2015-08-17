//
//  BreakIntoPiecesSegue.swift
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

class BreakIntoPiecesSegue: UIStoryboardSegue {
    
    override func perform() {
        if let sourceVC = sourceViewController as? UIViewController {
            if let destinationVC = destinationViewController as? UIViewController {
                
                
                let image = imageWithView(sourceVC.view!)

                sourceVC.addChildViewController(destinationVC)
                sourceVC.view!.addSubview(destinationVC.view!)
                
                let animator = UIDynamicAnimator(referenceView: destinationVC.view!)

                let containerView = UIView(frame: destinationVC.view!.frame)
                destinationVC.view!.addSubview(containerView)
                
                let gravityBehaviour = UIGravityBehavior(items: [containerView])
                animator.addBehavior(gravityBehaviour)
                
                let brokenPieces = splitIntoPieces(image)
                for piece in brokenPieces {
                    let imageView = UIImageView(image: piece.image)
                    imageView.frame = piece.frame
                    containerView.addSubview(imageView)

                }
                
                
            }
        }
        
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
        
        let rows = 10 as CGFloat
        let clms = 10 as CGFloat
        
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
