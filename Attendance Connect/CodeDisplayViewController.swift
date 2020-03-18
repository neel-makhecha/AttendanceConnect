//
//  CodeDisplayViewController.swift
//  Attendance Connect
//
//  Created by Neel on 15/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

class CodeDisplayViewController: UIViewController {
    
    
    @IBOutlet weak var classnameTextView: UILabel!
    
    var ref:DatabaseReference?
    
    var previousVC:NewClassViewController!
    
    @IBOutlet weak var codeTextView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        classnameTextView.text = currentClassName!
        codeTextView.text = currentClassCode!
        registerClassWithTeacherID()
        
        
        
    }
    
    func registerClassWithTeacherID(){
        
        let query = reformateEmail(email: emailID!)
        
        ref?.child("Users").child(query).child("Classes").child(currentClassCode!).setValue(currentClassName!)
        
        ref?.child("Classes").child(currentClassCode!).child("Details").child("Teacher").setValue(query)
        
        ref?.child("Classes").child(currentClassCode!).child("Details").child("Classname").setValue(currentClassName!)
        
            let path = ref?.child("Classes").child(currentClassCode!).child("Schedule")
        
            path?.child("Monday").child("09:10")
            path?.child("Tuesday").child("09:10")
            path?.child("Wednesday").child("09:10")
            path?.child("Thursday").child("09:10")
            path?.child("Friday").child("09:10")
            path?.child("Saturday").child("09:10")
        
        
        
    }

}
