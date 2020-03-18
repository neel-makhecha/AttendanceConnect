//
//  HelloTeacherViewController.swift
//  Attendance Connect
//
//  Created by Neel on 06/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HelloTeacherViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var nextButtonProperty: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var helloUserLabel: UILabel!
    
    
    @IBAction func SelectProfilePhoto(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let sourceAction = UIAlertController(title: "Select an image source", message: nil, preferredStyle: .actionSheet)
        
        let fromCamera = UIAlertAction(title: "Camera", style: .default) { (action) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let fromLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sourceAction.addAction(fromCamera)
        sourceAction.addAction(fromLibrary)
        sourceAction.addAction(cancelAction)
        
        self.present(sourceAction, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if image != nil{
            
            print("Preparing to upload the profile photo")
            self.profilePhotoImageView.image = #imageLiteral(resourceName: "whiteSquare").circleMasked
            self.activityIndicator.alpha = 1
            self.nextButtonProperty.alpha = 0
            let storageRef = Storage.storage().reference().child(reformateEmail(email: currentUser.emailID)+".png")
            
            if let uploadData = UIImagePNGRepresentation(image){
                
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    
                    if error != nil{
                        
                        let alert = UIAlertController(title: "Cannot Set A Profile Photo", message: "There was an issue setting your profile photo for Attendance CONNECT. You can do it later from the profile tab also.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        print("EROR:")
                        print(error)
                    }
                    else{
                        
                        //Maintaining persistance of profile photo locally
                        let filename = getDocumentsDirectory().appendingPathComponent("profilePhoto.png")
                        try? uploadData.write(to: filename)
                        
                        
                        storageRef.downloadURL(completion: { (URL, error) in
                            if error != nil{
                                
                                print("ERROR ON URL DOWNLOAD")
                                print("An unknown error occured while downloading the URL:")
                                print(error)
                                
                            }
                            else{
                                
                                
                                self.profilePhotoImageView.image = image.circleMasked
                                self.nextButtonProperty.alpha = 1
                                self.activityIndicator.alpha = 0
                                profilePhotoURL = URL
                                UserDefaults.standard.set(profilePhotoURL, forKey: "profilePhotoURL")
                                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                                request?.photoURL = profilePhotoURL
                                request?.commitChanges(completion: { (error) in
                                    print("Error occured while commiting changes into currentUser profile")
                                })
                                
                                
                            }
                        })
                    }
                    print(metadata)
                    
                }
            }
            
        }
        
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarVC") as! TabBarViewController
        self.present(nextVC, animated: true, completion: nil)
        loggedIn = true
        UserDefaults.standard.set(loggedIn, forKey: "loggedIn")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
}
