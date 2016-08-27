//
//  ViewControllerB.swift
//  Animation
//
//  Created by Jack Zhao on 2016-08-24.
//  Copyright © 2016 XiongbinZhao. All rights reserved.
//

import UIKit

class ViewControllerB: UIViewController {
    
    var mView: AnimatedActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mView = AnimatedActivityIndicatorView(frame: CGRect(x: 0, y: 64, width: self.view.width, height: self.view.height - 64))
        self.view.backgroundColor = UIColor.grayColor()
        self.view.addSubview(mView)
    }
    
    override func viewDidAppear(animated: Bool) {
        mView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {

    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
