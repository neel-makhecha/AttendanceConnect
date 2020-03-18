//
//  RegisterAttendanceViewController.swift
//  Attendance Connect
//
//  Created by Neel on 20/09/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

class RegisterAttendanceViewController: UIViewController {
    
    var ref:DatabaseReference?
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var enterCodeLabel: UILabel!
    
    
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    
    
    var attendanceCode:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        //Retrive Attendance Code for verification
        ref?.child("Classes").child(selectedClassID).observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == "Registeration Code"{
                
                self.attendanceCode = snapshot.value as! String
                
            }
        })
        
        ref?.child("Classes").child(selectedClassID).observe(.childChanged, with: { (snapshot) in
            
            if snapshot.key == "Registeration Code"{
                
                self.attendanceCode = snapshot.value as! String
                
            }
        })

        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if animated{
            print("Attendance Code: \(attendanceCode)")
        }
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        if codeTextField.text != ""{
            
            if codeTextField.text! == attendanceCode{
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.topImageView.alpha = 0
                    self.enterCodeLabel.alpha = 0
                    self.codeTextField.alpha = 0
                    self.registerButtonOutlet.alpha = 0
                }) { (success) in
                    
                    if success{
                        self.enterCodeLabel.text = "Done"
                        self.topImageView.image = UIImage(named: "done")
                        self.topImageView.alpha = 1
                        self.enterCodeLabel.alpha = 1
                        self.cancelButtonOutlet.titleLabel?.text = "Back"
                    }
                }
                
            }
                
            else{
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.topImageView.alpha = 0
                    self.enterCodeLabel.alpha = 0
                    self.codeTextField.alpha = 0
                    self.registerButtonOutlet.alpha = 0
                }) { (success) in
                    
                    if success{
                        self.enterCodeLabel.text = "Try Again!"
                        self.codeTextField.text = ""
                        self.topImageView.image = UIImage(named: "close")
                        self.topImageView.alpha = 1
                        self.registerButtonOutlet.alpha = 1
                        self.enterCodeLabel.alpha = 1
                        self.codeTextField.alpha = 1
                    }
                }
                
            }
            
        }
        
        else{
            
            let alert = UIAlertController(title: "Enter Code", message: "You haven't entered the code yet. Enter the code given by your teacher of this class to register your attendance. You will not be able to register attendance once your teacher de-activates the code.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func scanQRTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Not Availble", message: "This feature is not yet avaiable in this alpha version of Attendance Connect. Update to the latest alpha version, which may include this feature.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
