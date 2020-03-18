//
//  HelloUserViewController.swift
//  Attendance Connect
//
//  Created by Neel on 25/07/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class HelloUserViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var ref:DatabaseReference?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var helloUserLabel: UILabel!
    
    @IBOutlet weak var detailsView: UIVisualEffectView!
    
    
    @IBOutlet weak var instituteNameTextView: UITextField!
    
    
    @IBOutlet weak var classTextField: UITextField!
    
    @IBOutlet weak var ageTextView: UITextField!
    
    
    @IBOutlet weak var detailsViewHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButtonProperty: UIButton!
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if instituteNameTextView.text == "" || classTextField.text == ""{
            
            let alert = UIAlertController(title: "Incomplete Academic Details", message: "Some academic details are necessary to proceed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            
            currentUser.instituteName = instituteNameTextView.text!
            currentUser.classGrade = classTextField.text!
            
            if ageTextView.text == ""{
                currentUser.age = ""
            }else{
                currentUser.age = ageTextView.text!
            }
            
            createNewUserDB()
            
            loggedIn = true
            
            UserDefaults.standard.set(loggedIn, forKey: "loggedIn")
            saveCurrentUserData()
            
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarVC") as! TabBarViewController
            self.present(nextVC, animated: true, completion: nil)

        }
        
        
        
    }
    
    
    @IBAction func nameEnteringStarted(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.detailsView.frame.origin.y = super.view.frame.origin.y
            
        }, completion: nil)
        
        
    }
 
    @IBAction func classEnteringStarted(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.detailsView.frame.origin.y = super.view.frame.origin.y
            
        }, completion: nil)
    }
    
    
    
    @IBAction func ageEnteringStarted(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.detailsView.frame.origin.y = super.view.frame.origin.y
            
        }, completion: nil)
    }
    
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
    
    
    @IBAction func addAcademicDetails(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.detailsView.center.y = super.view.center.y
            self.nextButtonProperty.alpha = CGFloat(0)
        }, completion: nil)
        
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.detailsView.center.y = 1000 + super.view.frame.origin.y
            self.nextButtonProperty.alpha = CGFloat(1)
        }, completion: nil)
        
        view.endEditing(true)
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.detailsView.center.y += 1000
            self.nextButtonProperty.alpha = CGFloat(1)
        }, completion: nil)
        
        view.endEditing(true)
        
      //  currentUser.instituteName = instituteNameTextView.text!
      //  currentUser.age = Int(ageTextView.text!)!
      //  currentUser.classGrade = classTextField.text!
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        helloUserLabel.text = "Hello \(currentUser.username)"
        
        let user = Auth.auth().currentUser
        
        if user != nil{
            
            print("User Display Name: \(user?.displayName)")
        }
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
    
    func createNewUserDB(){
        
        print("Inside the function createNewUserDB")
        
        let newUserID = reformateEmail(email: currentUser.emailID)
        
        let currentReference = ref?.child("Users").child(newUserID)
        
        currentReference?.child("Name").setValue(currentUser.username)
        currentReference?.child("Roll").setValue(currentUser.ID)
        currentReference?.child("Email").setValue(currentUser.emailID)
        currentReference?.child("Institute").setValue(currentUser.instituteName)
        currentReference?.child("Class").setValue(currentUser.classGrade)
        currentReference?.child("Age").setValue(currentUser.age)
        currentReference?.child("AccountType").setValue("Student")
        
        emailID = currentUser.emailID
        
        
        UserDefaults.standard.set(emailID, forKey: "emailID")
        UserDefaults.standard.set(password, forKey: "password")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }



}
