//
//  ViewController.swift
//  MCS
//
//  Created by Jessica Cavazos on 11/7/15.
//  Copyright © 2015 Jessica Cavazos. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var viewBlackScreen: UIView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var pickerTimer: UIPickerView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var timer = NSTimer()
    let pickerMin = [0, 1, 5, 10, 15, 20, 30]
    let pickerSec = [5, 15, 30, 40]
    var time: NSInteger?
    var caller: [NSManagedObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldName.delegate = self
        pickerTimer.dataSource = self
        pickerTimer.delegate = self
        self.photoImageView.backgroundColor = UIColor.grayColor()
        
        photoImageView.layer.cornerRadius = photoImageView.frame.size.height/2
        photoImageView.layer.borderColor = UIColor(red: 0, green: 122, blue: 225, alpha: 0).CGColor
        photoImageView.layer.borderWidth = 0.5
        photoImageView.clipsToBounds = true
        
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Caller")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            caller = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if caller?.count != 0{
            photoImageView.image = UIImage(data: (caller![0].valueForKey("picture") as! NSData))
            textFieldName.text = caller![0].valueForKey("name") as? String
        } else {
            textFieldName.text = "Javier"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Set Call
    @IBAction func SetCall(sender: AnyObject) {
        time = pickerMin[pickerTimer.selectedRowInComponent(0)]*60 + pickerSec[pickerTimer.selectedRowInComponent(1)]
        print(time)
        if (time != 0){
        let alert = UIAlertController(title: "Attention!", message: "Please don't Lock or close the application", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                self.viewBlackScreen.hidden = false
               self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(self.time!), target: self, selector: Selector("StartCallProcess"), userInfo: nil, repeats: false)
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
        }
        
    }
    
    @IBAction func openPhotoLibrary(sender: AnyObject) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    func saveInformation(image: UIImage){
            let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Caller")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            caller = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if caller?.count != 0{
            let managedObject = caller![0]
            managedObject.setValue(textFieldName.text, forKey: "name")
            managedObject.setValue(UIImageJPEGRepresentation(photoImageView.image!, 1), forKey: "picture")
        } else {
            let entity =  NSEntityDescription.entityForName("Caller",
            inManagedObjectContext:managedContext)
            let callers = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            callers.setValue(UIImageJPEGRepresentation(photoImageView.image!, 1), forKey: "picture")
            callers.setValue(textFieldName.text, forKey: "name")
        
        }
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func StartCallProcess(){
        viewBlackScreen.hidden = true
        self.performSegueWithIdentifier("StartCall", sender: self)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0){
            return pickerMin.count
        } else {
            return pickerSec.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0){
            return "\(pickerMin[row])"
        } else {
            return "\(pickerSec[row])"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StartCall"){
            let destinationviewcontroller = segue.destinationViewController as! CallingViewController
            destinationviewcontroller.name = textFieldName.text!
            destinationviewcontroller.image = photoImageView.image
        }
    }
    
}

extension ViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        textFieldName.resignFirstResponder()
        if let image = photoImageView.image{
            saveInformation(image)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}


