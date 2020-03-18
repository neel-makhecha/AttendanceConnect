//
//  AttendanceCodeViewController.swift
//  Attendance Connect
//
//  Created by Neel on 19/09/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

class AttendanceCodeViewController: UIViewController {

    @IBOutlet weak var codeLabel: UILabel!
    
    var ref:DatabaseReference?
    var codeActivated = Bool()
    
    @IBOutlet weak var codeLengthSegment: UISegmentedControl!
    
    
    @IBOutlet weak var activateCodeButtonOutlet: UIButton!
    
    
    @IBOutlet weak var regenerateCodeButtonOutlet: UIButton!
    
    
    @IBAction func backTapped(_ sender: Any) {
        
        if codeActivated{
            let alert = UIAlertController(title: "Code is Active", message: "You cannot go back when the code is active. Please de-activate the code and try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        codeLengthSegment.selectedSegmentIndex = 1
        codeLabel.text = "\(generateAttendanceCode(codeLength: 12))"
        

    }
    
    
    @IBAction func segmentTapped(_ sender: Any) {
        
        switch codeLengthSegment.selectedSegmentIndex{
            
        case 0: codeLabel.text = "\(generateAttendanceCode(codeLength: 7))"
        case 1: codeLabel.text = "\(generateAttendanceCode(codeLength: 12))"
        case 2: codeLabel.text = "\(generateAttendanceCode(codeLength: 15))"
        default: codeLabel.text = "Unable to display code"
            
            
        }
        
        
    }
    
    
    @IBAction func activateCode(_ sender: Any) {
        
        if codeActivated == false{
            
            ref?.child("Classes").child(selectedClassID).child("Registeration Code").setValue("\(codeLabel.text!)")
            
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self.regenerateCodeButtonOutlet.alpha = 0
                self.activateCodeButtonOutlet.alpha = 0
                
                self.codeActivated = true
            }) { (success) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.activateCodeButtonOutlet.backgroundColor = UIColor.red
                    self.activateCodeButtonOutlet.titleLabel?.text = "Deactivate Code"
                    self.activateCodeButtonOutlet.alpha = 1
                })
            }
            
        }else{
            
            ref?.child("Classes").child(selectedClassID).child("Registeration Code").setValue("")
            
           
            
            UIView.animate(withDuration: 0.5, animations: {
                self.activateCodeButtonOutlet.alpha = 0
                self.activateCodeButtonOutlet.backgroundColor = UIColor.orange
                
            }) { (success) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.activateCodeButtonOutlet.titleLabel?.text = "Activate Code Again"
                    self.codeActivated = false
                    self.activateCodeButtonOutlet.alpha = 1
                    self.regenerateCodeButtonOutlet.alpha = 1

                })
            }
            
            
        }
        
    }
    
    
    @IBAction func regenerateCode(_ sender: Any) {
        
        switch codeLengthSegment.selectedSegmentIndex{
            
        case 0: codeLabel.text = "\(generateAttendanceCode(codeLength: 7))"
        case 1: codeLabel.text = "\(generateAttendanceCode(codeLength: 12))"
        case 2: codeLabel.text = "\(generateAttendanceCode(codeLength: 15))"
        default: codeLabel.text = "Unable to display code"
            
            
        }
        
    }
    
    func generateAttendanceCode(codeLength:Int)->String{
        
        let availableCharacters:NSString = "abcdefghijklmnopqrstuwxyz1234567890"
        
        var randomString : NSMutableString = NSMutableString(capacity: codeLength)
        
        
        for _ in 1...codeLength{
            
            var rand = arc4random_uniform((UInt32(availableCharacters.length-1)))
            randomString.appendFormat("%C", availableCharacters.character(at: Int(rand)))
            
        }
        
        let code = String(randomString)
        
        return code
        
    }
    
 

}
