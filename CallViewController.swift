//
//  ViewController.swift
//  MCS
//
//  Created by Jessica Cavazos on 11/7/15.
//  Copyright © 2015 Jessica Cavazos. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    var time: NSInteger = 0
    var name = " "
    var callTimer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        labelName.text = name
        
        //MARK: Call Timer
        callTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("CallTime"), userInfo: nil, repeats: true)
    }
    
    
    //MARK: Call Time
    func CallTime(){
        time += 1
        let minutes = time/60
        let seconds = time%60
        labelTimer.text = "\(minutes):0\(seconds)"
    }

    @IBAction func EndCall(sender: AnyObject) {
        callTimer.invalidate()
        time = 0
        performSegueWithIdentifier("toSettings", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

