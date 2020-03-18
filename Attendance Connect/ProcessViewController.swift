//
//  ProcessViewController.swift
//  Attendance Connect
//
//  Created by Neel on 01/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProcessViewController: UIViewController {

    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIImageView!
    
    
    @IBOutlet weak var retryButtonOutlet: UIButton!
    
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        
        activityIndicator.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.activityLabel.text = "Please Wait..."
            self.activityLabel.textColor = UIColor.gray
            self.activityIndicator.alpha = 1
        })
        retryButtonOutlet.alpha = 0
        retryButtonOutlet.isHidden = true
        
        autoLogin()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retryButtonOutlet.isHidden = true

    }

    override func viewDidAppear(_ animated: Bool) {
        
        ref = Database.database().reference()
        
            if loggedIn{
                print("Performing Auto Login")
                autoLogin()
            }else{
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "splashViewController") as! ViewController
                self.present(nextVC, animated: true, completion: nil)
            }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat,.autoreverse], animations: {
            self.activityIndicator.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, completion: {
            (success) in
            //self.activityIndicator.transform = CGAffineTransform(rotationAngle: 0)
        })
    }
    
    func autoLogin(){
        
        
 
        Auth.auth().signIn(withEmail: emailID!, password: password!) { (autResult, error) in
            
            if error != nil{
            
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.activityLabel.text = "Unexpected error occured while logging you in"
                    self.retryButtonOutlet.isHidden = false
                    self.activityLabel.textColor = UIColor.red
                    self.activityIndicator.alpha = 0
                    self.retryButtonOutlet.alpha = 1
                }, completion: { (action) in
                    self.activityIndicator.isHidden = true
                    
                })
                
            }
            else{
                print("Email ID: \(emailID)")
                print("SIGNED IN")
                self.retriveUserInfo(completionHandler: { (success) in
                    
                    if success == true{
                       /* printRetrivedInfo()
                        saveCurrentUserData()
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarVC") as! TabBarViewController
                        self.present(nextVC, animated: true, completion: nil)*/
                        
                        //NEW//
                      
                        saveCurrentUserData()
                        
                        //Later on when making this app offline, the data stored inside the databaseType UserDefault persistance to be used for comparision
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
                        
                        //Same procedure to follow when NSError? is not nil
                        UIView.animate(withDuration: 0.5, animations: {
                            
                            retriveCurrentUserDataLocally()
                            
                            self.activityLabel.text = "Please check the interent connection."
                            self.retryButtonOutlet.isHidden = false
                            self.activityLabel.textColor = UIColor.red
                            self.activityIndicator.alpha = 0
                            self.retryButtonOutlet.alpha = 1
                        }, completion: { (action) in
                            self.activityIndicator.isHidden = true
                            
                        })
                    }
                })
                
                
                
            }
        }
        
    }
    
    
    func retriveUserInfo(completionHandler:@escaping (Bool)->()){
        
        let query = reformateEmail(email: emailID!)
        
        print("Inside retriveUserInfo method")
        
        
        databaseHandle = ref?.child("Users").child(query).observe(.childAdded, with: { (snapshot) in
            
           // print("Snapshot exists: \(snapshot.exists())")
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
