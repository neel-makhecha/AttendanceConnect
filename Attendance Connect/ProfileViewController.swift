//
//  ProfileViewController.swift
//  Attendance Connect
//
//  Created by Neel on 31/07/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {


    @IBOutlet weak var profilePhotoOutlet: UIButton!

    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var rollLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    
    @IBOutlet weak var classLabel: UILabel!
    
    
    @IBOutlet weak var instituteLabel: UILabel!
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let confirmationAlert = UIAlertController(title: "Are you sure that you want to sign out?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOut = UIAlertAction(title: "Sign Out", style: .default) { (action) in
            do{
                try Auth.auth().signOut()
                self.processSignOut()
                
                //Deleting all the Settings and Data
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UserDefaults.standard.synchronize()
                
                let filename = getDocumentsDirectory().appendingPathComponent("profilePhoto.png")
                
                let filemanager = FileManager.default
                
                if filemanager.fileExists(atPath: filename.absoluteString){
                    do{
                        print("Deleting the profile photo")
                        try filemanager.removeItem(at: filename)
                        
                    }catch{
                        print("Error deleting the previous profile photo")
                        
                    }
                }else{
                    print("Cannot find any file to delete")
                }

                
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "splashViewController") as! ViewController
                
                self.present(nextVC, animated: true, completion: nil)
                
            
                
            }catch{
                
                let alert = UIAlertController(title: "Cannot Sign Out", message: "Unable to sign out at this moment. Please try again later.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Sign Out", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        }
        
        confirmationAlert.addAction(cancel)
        confirmationAlert.addAction(signOut)
        self.present(confirmationAlert, animated: true, completion: nil)
        
        
    }
    var image:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = currentUser.username
        rollLabel.text = currentUser.ID
        
        ageLabel.text = currentUser.age
        classLabel.text = currentUser.classGrade
        instituteLabel.text = currentUser.instituteName
        
        let filename = getDocumentsDirectory().appendingPathComponent("profilePhoto.png")
        
        var savedProfilePhoto = UIImage(contentsOfFile: filename.path)
        
        profilePhotoOutlet.imageView?.image = savedProfilePhoto?.circleMasked
        
        if profilePhotoURL == nil{
            catchPhotoURL = Auth.auth().currentUser?.photoURL
            UserDefaults.standard.set(catchPhotoURL, forKey: "profilePhotoURL")
        }else{
            catchPhotoURL = profilePhotoURL

        }
        
        let session = URLSession(configuration: .default)
        
        let downloadPhoto = session.dataTask(with: catchPhotoURL!) { (data, response, error) in
            
            if error != nil{
                
                let alert = UIAlertController(title: "Error", message: "Could not load the profile photo", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            if let res = response as? HTTPURLResponse{
                
                print("Image is being downloaded with response code: \(res.statusCode)")
                
                if let imageData = data{
                    self.image = UIImage(data: imageData)
                    
                    //Updating the persistant profile photo
                     //filename = getDocumentsDirectory().appendingPathComponent("profilePhoto.png")
                    try? imageData.write(to: filename)
                    
                    
                    savedProfilePhoto = UIImage(contentsOfFile: filename.path)
                    
                    
                    self.profilePhotoOutlet.setImage(savedProfilePhoto?.circleMasked, for: .normal)

                    
                }
                else{
                    
                    print("The image downloaded is found to be nil while unwrapping")
                    let alert = UIAlertController(title: "No Image", message: "Could not load the profile photo as the image data is nil when unwrapping.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else{
                print("Couldn't get any reponse from HTTP servers.")
                let alert = UIAlertController(title: "No Response", message: "Could not load the profile photo as HTTP server is not responding.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        downloadPhoto.resume()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
            let filename = getDocumentsDirectory().appendingPathComponent("profilePhoto.png")
            
            print("FILENAME: \(filename.path)")
            
            var savedProfilePhoto = UIImage(contentsOfFile: filename.path)
        
            profilePhotoOutlet.setImage(savedProfilePhoto?.circleMasked, for: .normal)
    }
    
    func processSignOut(){
        
        loggedIn = false
        UserDefaults.standard.set(loggedIn, forKey: "loggedIn")
        
        emailID = ""
        UserDefaults.standard.set(emailID, forKey: "emailID")
        
        password = ""
        UserDefaults.standard.set(password, forKey: "password")
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    @IBAction func profilePhotoTapped(_ sender: Any) {

    }
    
}
