//
//  TabBarViewController.swift
//  Attendance Connect
//
//  Created by Neel on 26/07/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase
var todayScheduleTimings = [String]()

class TabBarViewController: UITabBarController {
    
    var ref:DatabaseReference?
    var ref2:DatabaseReference?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("INSIDE VIEWDIDLOAD TABBAR")
        ref = Database.database().reference()
        ref2 = Database.database().reference()
        let user = reformateEmail(email: emailID!)
        
        ref?.child("Users").child(user).child("Classes").observe(.childAdded, with: { (snapshot) in
            
            print("ClassIDList Element: \(snapshot.key)")
            classIDList.append(snapshot.key)
            
        })
        
        ref?.child("Classes").observe(.childAdded, with: { (snapshot) in
            
            for ID in classIDList{
                
                //  print(ID)
                if ID == snapshot.key{
                    
                    let classname:String = snapshot.childSnapshot(forPath: "Details").childSnapshot(forPath: "Classname").value as! String
                    
                    classnameList.append(classname)
                    
                    
                }
            }
            
        })
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("INSIDE VIEWDIDAPPEAR TABBAR")

        if self.isBeingPresented || self.isMovingToParentViewController{
            
            for ID in classIDList{
                
                print("Looping through ID: \(ID)")
                ref?.child("Classes").child(ID).child("Announcements").observe(.childAdded, with: { (snapshot) in
                    
                    var newAnnouncement = Announcement()
                    
                    newAnnouncement.title = snapshot.childSnapshot(forPath: "Title").value as! String
                    newAnnouncement.date = snapshot.childSnapshot(forPath: "Date").value as! String
                    newAnnouncement.content = snapshot.childSnapshot(forPath: "Post").value as! String
                    newAnnouncement.teacher = snapshot.childSnapshot(forPath: "Teacher").value as! String
                    
                    print("New announcement created with contents:")
                   // print("Title: \(newAnnouncement.title)")
                   // print("Date: \(newAnnouncement.date)")
                   // print("Content: \(newAnnouncement.content)")
                    
                    announcementList.insert(newAnnouncement, at: 0)
                    //announcementList.append(newAnnouncement)
                })
                
                ref2?.child("Classes").child(ID).child("Schedule").observe(.childAdded, with: { (snapshot) in
                    
                    let todayValue = Calendar.current.component(.weekday, from: Date())
                    var today = String()
                    
                    switch todayValue{
                        
                    case 1: today = "Sunday"
                    case 2: today = "Monday"
                    case 3: today = "Tuesday"
                    case 4: today = "Wednesday"
                    case 5: today = "Thursday"
                    case 6: today = "Friday"
                    case 7: today = "Saturday"
                    default: today = "Unknown Day"
                        
                    }
                    
                    if today == snapshot.key{
                        todayScheduleTimings.append((snapshot.value as! String))
                        print("Appending \(snapshot.key) schedule with time \((snapshot.value as! String))")
                    }
                    
                })
            }
        }
        
        
        
        
        
        
        /*ref?.child("Classes").observe(.childAdded, with: { (snapshot) in
            
            /*for ID in classIDList{
                
                print("ID: \(ID)")
                print("Comparing with snapshot key: \(snapshot.key)")
                
                if ID == snapshot.key{
                    var newAnnouncement:Announcement = Announcement()
                    self.ref2?.child("Classes").child(ID).child("Announcements").observe(.childAdded, with: { (snapshot) in
                        print("New announcement created:")

                        newAnnouncement.classID = ID
                        
                        newAnnouncement.teacher = snapshot.childSnapshot(forPath: "Teacher Name").value as! String
                        
                        newAnnouncement.title = snapshot.childSnapshot(forPath: "Title").value as! String
                        newAnnouncement.date = snapshot.childSnapshot(forPath: "Date").value as! String
                        newAnnouncement.content = snapshot.childSnapshot(forPath: "Post").value as! String
         
                        print("TITLE: \(newAnnouncement.title)")
                        print("Content: \(newAnnouncement.content)")
                        print("Date: \(newAnnouncement.date)")
                        print("Teacher: \(newAnnouncement.date)")
                        
                        announcementList.append(newAnnouncement)
                        
                    })
        
                }
            }*/
         
         
            
        })*/
        
        
    }

  

}
