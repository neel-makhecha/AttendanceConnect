//
//  JoinClassViewController.swift
//  Attendance Connect
//
//  Created by Neel on 04/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

class JoinClassViewController: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    var classList = [String]()
    
    @IBOutlet weak var guideLabel: UILabel!
    
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let enteredClassID = classIDTextField.text!
        
        performVisualChanges()
        print("Entered Class ID: \(enteredClassID)")
        
        print("Entered Class ID is present: \(classList.contains(enteredClassID))")
        view.endEditing(true)
        
        
        
        if(classList.contains(enteredClassID)){
            
            let user = reformateEmail(email: currentUser.emailID)
            let currentReference = ref?.child("Users").child(user)
            

        currentReference?.child("Classes").child(enteredClassID).setValue("")
            
            ref?.child("Classes").child(enteredClassID).child("Students").child(user).child("Name").setValue(currentUser.username)
            
            ref?.child("Classes").child(enteredClassID).child("Students").child(user).child("Presents").setValue("0")

            ref?.child("Classes").child(enteredClassID).child("Students").child(user).child("Absents").setValue("0")
            
            ref?.child("Classes").child(enteredClassID).child("Students").child(user).child("Roll").setValue(currentUser.ID)

            ref?.child("Classes").child(enteredClassID).child("Students").child(user).child("Faces").setValue("0")

            
            let alert = UIAlertController(title: "Done", message: "You are now the student of this class", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in

                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            self.revertVisualChanges()
            let alert = UIAlertController(title: "Cannot Find Class", message: "The class with mentioned Class ID does not exist. Please recheck the Class ID for any typing errors.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        

        
        
        
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var classIDTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        print("PRINTING ALL CLASS IDs")
        ref?.child("Classes").observe(.childAdded, with: { (snapshot) in
            
            self.classList.append(snapshot.key)
            print(snapshot.key)
            
        })
        
        print("PRINTING CLASS NAMES")
        


    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    func performVisualChanges(){
        
        UIView.animate(withDuration: 1, animations: {
            self.activityIndicator.alpha = 1
            self.guideLabel.text = "Joining Class..."
            self.addButtonOutlet.alpha = 0
            self.classIDTextField.alpha = 0
        }, completion: nil)
        
    }
    
    func revertVisualChanges(){
        
        UIView.animate(withDuration: 1, animations: {
            self.activityIndicator.alpha = 0
            self.guideLabel.text = "Enter a Class ID provided by your Teacher"
            self.addButtonOutlet.alpha = 1
            self.classIDTextField.alpha = 1
        }, completion: nil)
        
    }
    
}
