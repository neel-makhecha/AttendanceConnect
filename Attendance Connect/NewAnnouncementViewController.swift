//
//  NewAnnouncementViewController.swift
//  Attendance Connect
//
//  Created by Neel on 31/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

class NewAnnouncementViewController: UIViewController {
    
    @IBOutlet weak var announcementTitleTextView: UITextField!
    
    @IBOutlet weak var anncouncementContentTextView:UITextView!
    
    var ref:DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
    }

    @IBAction func cancelTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        if announcementTitleTextView.text == ""{
            
            let alert:UIAlertController = UIAlertController(title: "Missing Title", message: "The title is empty. Please enter a title for this new announcement", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else if anncouncementContentTextView.text == ""{
            
            let alert:UIAlertController = UIAlertController(title: "No Content", message: "This announcement have no content. Please mention the content of announcement. The title can be small statement and the content can be a detailed elaboration of that statement.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else{
            
            print("Announcement Details")
            print("Title: \(announcementTitleTextView.text!)")
            print("Content: \(anncouncementContentTextView.text!)")
            print("Announcement Class Code: \(selectedClassID)")
            
            makeAnnouncement(classCode: selectedClassID, title: announcementTitleTextView.text!, content: anncouncementContentTextView.text!)
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
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
            "/Classes/\(classCode)/Announcements/\(key!)":post
        ]
        
        ref?.updateChildValues(childUpdates)
    }
    
}
