//
//  StudentRegisterationViewController.swift
//  Attendance Connect
//
//  Created by Neel on 24/07/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class StudentRegisterationViewController: UIViewController {
    
   // var ref:DatabaseReference?
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBOutlet weak var activityIndicator: UIImageView!
    
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var rollNoTextField: UITextField!
    
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        view.endEditing(true)
        let confirmAlert = UIAlertController(title: "Confirm Registeration", message: "Your entered data will be send to Attendance Connect servers. The sensitive information such as password will be in encrypted form.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Sign Up", style: .default, handler: {
            action in
            
            self.signUp()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        confirmAlert.addAction(cancelAction)
        confirmAlert.addAction(confirmAction)
        
        self.present(confirmAlert, animated: true, completion: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ref = Database.database().reference()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse,.repeat], animations: {
            self.activityIndicator.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, completion: nil)
    }

    
   
    
    func signUp(){
        
        let newUser = User()
        
        newUser.type = .Student
        newUser.emailID = emailTextField.text!
        newUser.username = nameTextField.text!
        password = newPasswordTextField.text!
        confirmPassword = confirmPasswordTextField.text!
        newUser.ID = rollNoTextField.text!
        
        if password != confirmPassword{
            
            let alert = UIAlertController(title: "No Password Match", message: "The password that you've entered don't match with the password you've confirmed just below. Please retype both passwords once again.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.newPasswordTextField.text = ""
                self.confirmPasswordTextField.text = ""
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else if newUser.emailID == "" || newUser.username == "" || password == "" || confirmPassword == "" || newUser.ID == "" {
            
            let alert = UIAlertController(title: "Incomplete Details", message: "There one more field(s) incompelete inside registeration form. All the details asked are required.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            UIView.animate(withDuration: 0.3) {
                self.activityIndicator.alpha = 1
            }
            
            self.nextButtonOutlet.isHidden = true
            self.backButtonOutlet.isHidden = true
            
            Auth.auth().createUser(withEmail: newUser.emailID, password: password!) { (authResult, error) in
                
                
                
                if error != nil{
                    
                    self.nextButtonOutlet.isHidden = false
                    self.backButtonOutlet.isHidden = false
                    
                    UIView.animate(withDuration: 0.3) {
                        self.activityIndicator.alpha = 0
                    }
                    
                    print("The error generated when signing up the user is as per the following: \(error!)")
                    
                    let alert = UIAlertController(title: "Cannot Register", message: "\(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    
                    currentUser = newUser
                    let request = Auth.auth().currentUser?.createProfileChangeRequest()
                    
                    request?.displayName = currentUser.username
                    request?.commitChanges(completion: { (error) in
                        if error != nil{
                            
                            let alert = UIAlertController(title: "Cannot Register", message: "There was an error setting up your username. Please re-enter your credentials.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            self.nameTextField.text = ""
                            self.newPasswordTextField.text = ""
                            self.confirmPasswordTextField.text = ""
                        }
                        else{
                            
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "helloUser") as! HelloUserViewController
                            self.present(nextVC, animated: true, completion: nil)
                            UserDefaults.standard.set(password, forKey: "password")
                            UserDefaults.standard.set(emailID, forKey: "emailID")
                            //self.createNewUserDB()
                            
                        }
                    })

                    
                    
                    
                    
                }
            }
        }
        
        
    }
    
  /*  func createNewUserDB(){
        
       // ref?.child("Students").child(currentUser.username).child("Roll").setValue(currentUser.ID)
    //ref?.child("Students").child(currentUser.username).child("Class").setValue(currentUser.classGrade)
        let currentReference = ref?.child("Students").childByAutoId()

        currentReference?.child("Name").setValue(currentUser.username)
        currentReference?.child("Roll").setValue(currentUser.ID)
        currentReference?.child("Email").setValue(currentUser.emailID)
        
        
        
    }*/
    
    func isValidUsername(){
        
        //ref?.child("Students").que
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

}
