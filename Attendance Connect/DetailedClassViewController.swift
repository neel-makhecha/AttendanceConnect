//
//  DetailedClassViewController.swift
//  Attendance Connect
//
//  Created by Neel on 19/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

var selectedStudentName:String = String()

class DetailedClassViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    var ref:DatabaseReference?
    var ref2:DatabaseReference?
    var ref3:DatabaseReference?
    
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var segmentSelector: UISegmentedControl!
    
    var announcements:[Announcement]?
    
    var studentNameList:[String]?
    var rollNo:[String]?
    
    var scheduleTimingds:[String] = ["","","","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        ref2 = Database.database().reference()
        ref3 = Database.database().reference()
        
        let cellNib1 = UINib(nibName: "AnnouncementCell", bundle: Bundle.main)
        self.TableView.register(cellNib1, forCellReuseIdentifier: "AnnouncementCell")
            
        let cellNib2 = UINib(nibName: "ScheduleSettingsCell", bundle: Bundle.main)
        self.TableView.register(cellNib2, forCellReuseIdentifier: "ScheduleSettingsCell")
        
       
        ref?.child("Classes").child(selectedClassID).child("Announcements").observe(.childAdded, with: { (snapshot) in
            
            
            
            
            var newAnnouncement = Announcement()
            
            
            newAnnouncement.classID = selectedClassID
            newAnnouncement.title = snapshot.childSnapshot(forPath: "Title").value as! String
            
            newAnnouncement.date = snapshot.childSnapshot(forPath: "Date").value as! String
            newAnnouncement.content = snapshot.childSnapshot(forPath: "Post").value as! String
            newAnnouncement.teacher = snapshot.childSnapshot(forPath: "Teacher").value as! String
            
            announcementList.append(newAnnouncement)
            
            print("Title: \(newAnnouncement.title)")
            print("Date: \(newAnnouncement.date)")
            print("Post: \(newAnnouncement.content)")
            
            print("The counter of announcements: \(announcementList.count)")
            
            self.TableView.reloadData()
        })
        
       
        //Retriving the schedule of this class
        
        var array1 = [String]()
        var array2 = [String]()
        
        ref?.child("Classes").child(selectedClassID).child("Students").observe(.childAdded, with: { (snapshot) in
            
            var studentName:String = snapshot.childSnapshot(forPath: "Name").value as! String
            let roll:String = snapshot.childSnapshot(forPath: "Roll").value as! String
            
            print("Student: \(studentName)")
            print("Roll: \(roll)")
        
            array1.append(studentName)
            array2.append(roll)
            
            self.studentNameList = array1
            self.rollNo = array2
            
            print("Counter: \(self.studentNameList?.count)")

        })
        
        ref?.child("Classes").child(selectedClassID).child("Schedule").observe(.childAdded, with: { (snapshot) in
            
            let key = snapshot.key
            let val = snapshot.value as! String
            
            switch key{
                
            case "Monday": self.scheduleTimingds[0] = "\(val)"
            case "Tuesday": self.scheduleTimingds[1] = "\(val)"
            case "Wednesday": self.scheduleTimingds[2] = "\(val)"
            case "Thursday": self.scheduleTimingds[3] = "\(val)"
            case "Friday": self.scheduleTimingds[4] = "\(val)"
            case "Saturday": self.scheduleTimingds[5] = "\(val)"
            default: print("Key cannot be used!")
                
            }
            
        })
        
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        if animated{
            TableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        announcementList.removeAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if segmentSelector.selectedSegmentIndex == 0{
                    return announcementList.count
                
            }
            else if segmentSelector.selectedSegmentIndex == 1{
                    return 6
            }
            
            else if segmentSelector.selectedSegmentIndex == 2{
                
                if studentNameList?.count == nil{
                    return 0
                }
                else{
                    return (studentNameList?.count)!

                }
            }
        
            
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segmentSelector.selectedSegmentIndex == 2{
            
            let cell = tableView.cellForRow(at: indexPath)
            let studentName = cell?.textLabel?.text
            selectedStudentName = studentName!
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "cameraEnrolVC") as! CameraEnrolViewController
            
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if segmentSelector.selectedSegmentIndex == 0{
            
            tableView.allowsSelection = true

            let cell:AnnouncementCell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell") as! AnnouncementCell
            
            cell.titleLabel.text = announcementList[indexPath.row].title
            cell.contentLabel.text = announcementList[indexPath.row].content
            cell.dateLabel.text = announcementList[indexPath.row].date
            
            tableView.rowHeight = 200
            return cell
        }
            
        else if segmentSelector.selectedSegmentIndex == 1{
            
            tableView.allowsSelection = false

            
            let cell:ScheduleSettingsCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSettingsCell") as! ScheduleSettingsCell
            
            
            
            switch indexPath.row{
                
            case 0: cell.dayLabel.text = "Monday"
            case 1: cell.dayLabel.text = "Tuesday"
            case 2: cell.dayLabel.text = "Wednesday"
            case 3: cell.dayLabel.text = "Thursday"
            case 4: cell.dayLabel.text = "Friday"
            case 5: cell.dayLabel.text = "Saturday"
            case 6: cell.dayLabel.text = "Sunday"
            default: cell.dayLabel.text = "Overload"
                
            }
            print("IndexPath: \(indexPath.row)")
            if scheduleTimingds[indexPath.row] != ""{
                
                let time = scheduleTimingds[indexPath.row].split(separator: ":", maxSplits: 2, omittingEmptySubsequences: true)
                print("Hours: \(time[0])")
                print("Minutes: \(time[1])")
                cell.hoursButton.titleLabel?.text = "\(time[0])"

                cell.minutesLabel.titleLabel?.text = "\(time[1])"
                
                cell.scheuledCheckButton.setImage(UIImage(named: "done"), for: .normal)
                

            }
            else{
                
                cell.scheuledCheckButton.setImage(UIImage(named: "close"), for: .normal)
                
                cell.minutesLabel.titleLabel?.text = "00"
                cell.hoursButton.titleLabel?.text = "00"
            }
            
            cell.hoursButton.tag = indexPath.row
            cell.hoursButton.addTarget(self, action: #selector(hoursTapped), for: .touchUpInside)
            
            cell.minutesLabel.tag = indexPath.row
            cell.minutesLabel.addTarget(self, action: #selector(minutesTapped), for: .touchUpInside)
            
            
            
            cell.scheuledCheckButton.tag = indexPath.row
            cell.scheuledCheckButton.addTarget(self, action: #selector(scheduleCheckTapped), for: .touchUpInside)
            
            tableView.rowHeight = 100
            
            return cell
        }
        else if segmentSelector.selectedSegmentIndex == 2{
            
            let cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell1")
            
            cell.textLabel?.text = studentNameList?[indexPath.row]
            
            tableView.rowHeight = 50

            return cell
            
            
        }
        else{
            
            let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell1")
            
            
            return cell
        }
        
    }
    
    
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        
        TableView.reloadData()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "newAnnouncementVC")
        self.present(nextVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func editTapped(_ sender: Any) {
        
        let editMenu = UIAlertController(title: "Edit Details", message: "", preferredStyle: .alert)
        
        let option1 = UIAlertAction(title: "Edit Class Name", style: .default, handler: nil)
        
        let option2 = UIAlertAction(title: "De-schedule this Class", style: .default, handler: nil)
        
        let option3 = UIAlertAction(title: "Delete Class", style: .default, handler: nil)
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        editMenu.addAction(option1)
        editMenu.addAction(option2)
        editMenu.addAction(option3)
        editMenu.addAction(closeAction)
        
        self.present(editMenu, animated: true, completion: nil)
        
    }
    
    
    @IBAction func segmentFlipped(_sender: Any){
        
        switch segmentSelector.selectedSegmentIndex{
            
        case 0: print("Segement 0 Selected")
            
        case 1: print("Segement 1 Selected")
            
        case 2: print("Segement 2 Selected")
            
        case 3: let nextVC = storyboard?.instantiateViewController(withIdentifier: "attendanceMethodVC") as! AttendanceMethodViewController
        self.present(nextVC, animated: true, completion: nil)
            
        default: print("The default method which will never be executed")
            
        }
        
        TableView.reloadData()
        
        
    }
    
    @objc func hoursTapped(button:UIButton){
        
        let dialogue = UIAlertController(title: "Set Hours", message: "At what hour the session needs to be scheduled?", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            
            let field = dialogue.textFields![0] as UITextField
            
            let number = Int(field.text!)
            
            if number != nil{
                
                if (number! > 24) || (number! <= 0){
                    
                    let alert = UIAlertController(title: "Invalid Input", message: "The max value ccan be 12 and min value can be 1 as 12 hours time format is supported. You have to mention AM/PM explicitly.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else{
                    
                    var day = String()
                    let index = button.tag
                    print("IndexValue: \(index)")
                    switch index{
                        
                    case 0: day = "Monday"
                    case 1 : day = "Tuesday"
                    case 2: day = "Wednesday"
                    case 3: day = "Thursday"
                    case 4: day = "Friday"
                    case 5: day = "Saturday"
                    default: day = "Unknown Day"
                    }
                    
                    
                    var hourString = String()
                    
                    if number! < 10{
                        hourString = "0" + "\(number!)"
                    }else{
                        hourString = "\(number!)"
                    }
                    
                    let valueString = "\(hourString):00"
                    self.ref?.child("Classes").child(selectedClassID).child("Schedule").child(day).setValue(valueString)
                }
                
            }
         
            
        }
        
        dialogue.addTextField { (textField) in
            textField.placeholder = "Eg.: 12"
            textField.keyboardType = .numberPad
        }
        
        dialogue.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        dialogue.addAction(cancelAction)
        
        self.present(dialogue, animated: true, completion: nil)
        
    }
    
    @objc func minutesTapped(index:Int){
        
        
        let dialogue = UIAlertController(title: "Set Minutes", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            
            let field = dialogue.textFields![0] as UITextField
            
            let number = Int(field.text!)
            
            if number != nil{
                
                if (number! > 60) || (number! < 0){
                    
                    let alert = UIAlertController(title: "Invalid Input", message: "The max value can be 60 and min value can be 0. You have to mention AM/PM explicitly.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
            
        }
        
        dialogue.addTextField { (textField) in
            textField.placeholder = "Eg.: 45"
            textField.keyboardType = .numberPad
        }
        
        dialogue.addAction(action)
        
        self.present(dialogue, animated: true, completion: nil)
        
        
    }
    
    @objc func scheduleCheckTapped(){
        
        
    }
    
    @objc func switchAMPM(){
        
      
    }
    
    
}
