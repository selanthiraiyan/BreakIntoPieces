//
//  ViewController.swift
//  BreakIntoPieces
//
//  Created by Sharma Elanthiraiyan on 16/08/15.
//  Copyright (c) 2015 Sharma Elanthiraiyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func begin(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PresentedViewController") as! PresentedViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

