//
//  ViewController.swift
//  MCS
//
//  Created by Jessica Cavazos on 11/7/15.
//  Copyright © 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import AudioToolbox

class CallingViewController: UIViewController {
    
    var ringtoneAudio = AVAudioPlayer()
    var name = ""
    var image:UIImage?
    
    @IBOutlet weak var textfieldName: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:Round Image
        imageview.image = image!
        imageview.layer.cornerRadius = imageview.frame.size.height/2
        imageview.clipsToBounds = true
        
        textfieldName.text = "     " + name
        let path = NSBundle.mainBundle().pathForResource("ringtone", ofType: "mp3")
        do {
            ringtoneAudio = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!))
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print("Something bad happened. Try catching specific errors to narrow things down")
        }
        ringtoneAudio.play()
        
        //vibrate
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AcceptCall"{
            let destinationviewcontroller = segue.destinationViewController as! CallViewController
            destinationviewcontroller.name = name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Accept(sender: AnyObject) {
        ringtoneAudio.stop()
        ringtoneAudio.currentTime = 0
        performSegueWithIdentifier("AcceptCall", sender: self)
    }
    
    @IBAction func DeclineCall(sender: AnyObject) {
        ringtoneAudio.stop()
        ringtoneAudio.currentTime = 0
        performSegueWithIdentifier("CancelCall", sender: self)
    }
}

