//
//  TeacherRegisterationViewController.swift
//  Attendance Connect
//
//  Created by Neel on 05/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TeacherRegisterationViewController: UIViewController {
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var ref:DatabaseReference?
    
    @IBOutlet weak var nextButonOutlet: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var instituteTextField: UITextField!
    
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        
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
    
    func signUp(){
        
        let newUser = User()
        
        newUser.type = .Teacher
        newUser.emailID = emailTextField.text!
        newUser.username = nameTextField.text!
        password = newPasswordTextField.text!
        confirmPassword = confirmPasswordTextField.text!
        newUser.instituteName = instituteTextField.text!
        
        if password != confirmPassword{
            
            let alert = UIAlertController(title: "No Password Match", message: "The password that you've entered don't match with the password you've confirmed just below. Please retype both passwords once again.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.newPasswordTextField.text = ""
                self.confirmPasswordTextField.text = ""
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else if newUser.emailID == "" || newUser.username == "" || password == "" || confirmPassword == "" || newUser.instituteName == "" {
            
            let alert = UIAlertController(title: "Incomplete Details", message: "There one more field(s) incompelete inside registeration form. All the details asked are required.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            self.activityIndicator.isHidden = false
            self.nextButonOutlet.isHidden = true
            
            Auth.auth().createUser(withEmail: newUser.emailID, password: password!) { (authResult, error) in
                
                
                
                if error != nil{
                    
                    self.activityIndicator.isHidden = true
                    self.nextButonOutlet.isHidden = false
                    
                    print("The error generated when signing up the user is as per the following: \(error)")
                    
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
                            
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "helloTeacherVC") as! HelloTeacherViewController
                            self.present(nextVC, animated: true, completion: nil)
                            self.createNewUserDB()
                            
                        }
                    })
                    
                    
                    
                    
                    
                }
            }
        }
        
        
    }
    
    func createNewUserDB(){
        
        print("Inside the function createNewUserDB")
        
        let newUserID = reformateEmail(email: currentUser.emailID)
        
        let currentReference = ref?.child("Users").child(newUserID)
        
        currentReference?.child("Name").setValue(currentUser.username)
        currentReference?.child("Email").setValue(currentUser.emailID)
        currentReference?.child("Institute").setValue(currentUser.instituteName)
        currentReference?.child("AccountType").setValue("Teacher")
    
        
        emailID = currentUser.emailID
        UserDefaults.standard.set(emailID, forKey: "emailID")
        
        UserDefaults.standard.set(password, forKey: "password")

        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    

}
