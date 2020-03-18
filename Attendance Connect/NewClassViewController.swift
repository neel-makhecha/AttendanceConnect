//
//  NewClassViewController.swift
//  Attendance Connect
//
//  Created by Neel on 12/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

var currentClassCode:String?
var currentClassName:String?

class NewClassViewController: UIViewController {
    
    var ref:DatabaseReference?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    
    
    @IBOutlet weak var classNameTextField: UITextField!
    
    @IBOutlet weak var announcementTitleTextField: UITextField!
    
    @IBOutlet weak var postTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }

    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        currentClassName = classNameTextField.text!
        
      //  currentClassCode = generateClassCode()()
        
        var code:String?
        
        generateClassCode { (sucess, classCode) in
            code = classCode
            self.makeAnnouncement(classCode: code!, title: self.announcementTitleTextField.text!, content: self.postTextView.text!)
            
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "codeDisplaycVC") as! CodeDisplayViewController
            
            self.present(nextVC, animated: true, completion: nil)
            
            
        }
        
    
        /*{
            let alert = UIAlertController(title: "Error", message: "Cannot perform", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }*/
        
        

        
        
        
        
    }
    
    func makeAnnouncement(classCode:String,title:String,content:String){
        
        print("Posting Announcement")
        
        let date = Calendar.current.component(.day, from: Date())
        let monthValue = Calendar.current.component(.month, from: Date())
        var month:String = String()
        
        switch monthValue{
            
        case 1: month = "January"
        case 2: month = "February"
        case 3: month = "March"
        case 4: month = "April"
        case 5: month = "May"
        case 6: month = "June"
        case 7: month = "July"
        case 8: month = "August"
        case 9: month = "September"
        case 10: month = "October"
        case 11: month = "November"
        case 12: month = "December"
        default: month = "Unknown Month"
            
        }
        
        let year = Calendar.current.component(.year, from: Date())
        
        let dateString = "\(month) \(date), \(year)"
        print("Today's Date: \(dateString)")

       
        let key = ref?.child("Classes").child(classCode).child("Announcements").childByAutoId().key
        
        let post = [
            
            "Title":title,
            "Post":content,
            "Date":dateString,
            "Teacher":currentUser.username
            
        ]
        
        let childUpdates = [
            "/Classes/\(currentClassCode!)/Announcements/\(key!)":post
        ]
        
        ref?.updateChildValues(childUpdates)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    

}
