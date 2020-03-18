//
//  LoginViewController.swift
//  Attendance Connect
//
//  Created by Neel on 20/07/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var progressActivityIndicator: UIImageView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    
    @IBOutlet weak var loginSegmentController: UISegmentedControl!
    
    @IBOutlet weak var nextButtonProperty: UIButton!
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        
        
        view.endEditing(true)
        
        if emailField.text! == ""{
            
            let alert = UIAlertController(title: "Email ID not Entered", message: "Please provide the email ID using which you've registered previously. If you have not registered already, please consider registering first to start using Attendance CONNECT.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else if passwordField.text! == ""{
            
            let alert = UIAlertController(title: "Password not Entered", message: "Enter the password which you've entered while registering with Attendance CONNECT.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            UIView.animate(withDuration: 0.2, animations: {
                self.nextButtonProperty.alpha = 0
                self.progressActivityIndicator.alpha = 1
                
            })
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (authenticationData, error) in
                
                
            
                if error != nil{
                    
                    print("Error While Signing IN: \(error)")
                    let alert = UIAlertController(title: "Cannot Sign In", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.nextButtonProperty.alpha = 1
                            self.progressActivityIndicator.alpha = 0
                        })
                    })

                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
        
                    
                }
                else{
                    
                    emailID = self.emailField.text!
                    password = self.passwordField.text!
                    
                    self.retriveUserInfo(completionHandler: { (done) in
                        
                        print("Out of retriving state")
                        
                        if done{
                            
                            emailID = self.emailField.text!
                            password = self.passwordField.text!
                            loggedIn = true
                            
                            currentUser.emailID = emailID!
                            
                            UserDefaults.standard.set(emailID, forKey: "emailID")
                            UserDefaults.standard.set(password, forKey: "password")
                            UserDefaults.standard.set(loggedIn, forKey: "loggedIn")
                            saveCurrentUserData()
                            
                            if currentUser.type == .Student{
                                
                                databaseType = "Student"
                                UserDefaults.standard.set(databaseType, forKey: "databaseType")
                                print("Presenting the tabVC")
                                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarVC") as! TabBarViewController
                                self.present(nextVC, animated: true, completion: nil)
                                
                            }else if currentUser.type == .Teacher{
                                
                                print("Current user is a Teacher")
                                UserDefaults.standard.set(databaseType, forKey: "databaseType")
                                
                                print("Presenting the tabVC for teachers")
                                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "teachersTabBar") as! TabTeachersViewController
                                self.present(nextVC, animated: true, completion: nil)
                                
                            }
                            
                           
                            
                            
                            
                           

                        }
                        else{
                            
                            let errorAlert = UIAlertController(title: "Cannot Sign In", message: "The data for this account does not exist. Please recheck CONNECT ID type and select \"Student\" or \"Teacher\" which ever is your ID type.", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.nextButtonProperty.alpha = 1
                                    self.progressActivityIndicator.alpha = 0
                                })
                            })
                            
                            errorAlert.addAction(okAction)
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                    })
                    
                    
                    
                }
            }
            
        }
        
        
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
                
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "whoRUVC") as! WhoRUViewController
        self.present(nextVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        ref = Database.database().reference()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse,.repeat], animations: {
            self.progressActivityIndicator.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, completion: nil)
    }
    
    
    @IBAction func passwordReturnTapped(_ sender: Any) {
        print("RETURN TAPPED FROM KEYBOARD")
        nextButtonTapped(sender)
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    func retriveUserInfo(completionHandler:@escaping (Bool)->()){
        
        let query = reformateEmail(email: emailID!)
        
        print("Inside retriveUserInfo method")
        
        
        databaseHandle = ref?.child("Users").child(query).observe(.childAdded, with: { (snapshot) in
            
            print("Snapshot exists: \(snapshot.exists())")
            if snapshot.exists(){
            let key = snapshot.key
            switch key{
            
            
                
            case "Age": currentUser.age = snapshot.value as! String
            case "Class": currentUser.classGrade = snapshot.value as! String
            case "Email": currentUser.emailID = snapshot.value as! String
            case "Institute": currentUser.instituteName = snapshot.value as! String
            case "Name": currentUser.username = snapshot.value as! String
            case "Roll": currentUser.ID = snapshot.value as! String
            
            case "AccountType": let accountType = snapshot.value as! String
            if accountType == "Student"{
                currentUser.type = .Student
            }
            else if accountType == "Teacher"{
                currentUser.type = .Teacher
            }
                        print("Everything went perfect")
                        completionHandler(true)
                
                
            default: print("Default statement under switch executed")
              //  completionHandler(false)
                
            }
            }
            else{
                
                print("Cannot fetch in information NEW NEW")
                completionHandler(false)

            }
        }){
            (error) in
            
            print("Unable to fetch the data, went to error")
            completionHandler(false)
            
        }
        
        
        
        
        
        
    }

}
