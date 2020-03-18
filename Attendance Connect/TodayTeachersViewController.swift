//
//  TodayTeachersViewController.swift
//  Attendance Connect
//
//  Created by Neel on 12/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

class TodayTeachersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var TableView: UITableView!
    
    var ref:DatabaseReference?
    var ref2:DatabaseReference?
    
    var classCodeList = [String]()
    var classNameList = [String]()
    var todaySessionTimes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "TodayScheduleTableCell", bundle: Bundle.main)
        
        TableView.register(cellNib, forCellReuseIdentifier: "TodayScheduleCell")
        
        ref = Database.database().reference()
        ref2 = Database.database().reference()
        let user = reformateEmail(email: emailID!)
        print("Class List")
        ref?.child("Users").child(user).child("Classes").observe(.childAdded, with: { (snapshot) in
            
            let classCode = snapshot.key as! String
            classList.append(classCode)
            let classname = snapshot.value as! String
            classnameList.append(classname)
            
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
            
            self.ref2?.child("Classes").child(classCode).child("Schedule").observe(.childAdded, with: { (snapshot) in
                
                if snapshot.key == today{
                    print("Appending Class: \(classname)")
                    let snapshotValue = snapshot.value as! String
                    self.todaySessionTimes.append(snapshotValue)
                    print("Class Time: \(snapshotValue)")
                }
            })
        })
     
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if animated{
            print("Schedule:")
            print("Classname Count: \(classNameList.count)")
                        
            TableView.reloadData()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return classnameList.count
        }
        else{
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TodayScheduleTableCell = tableView.dequeueReusableCell(withIdentifier: "TodayScheduleCell") as! TodayScheduleTableCell
        
        TableView.rowHeight = 70
        cell.subjectNameLabel.text = "\(classnameList[indexPath.row])"
       // cell.facultyOrClassName.text = "\(classCodeList[indexPath.row])"
//        cell.timeLabel.text = "At \(todaySessionTimes[indexPath.row])"
        
        return cell
        
    }
    
   
    

}
