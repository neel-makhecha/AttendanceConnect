//
//  AttendanceRecordsViewController.swift
//  Attendance Connect
//
//  Created by Neel on 28/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

class AttendanceRecordsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var ref:DatabaseReference?
    
    var sessionsAttended:String = String()
    var sessionsAbsents:String = String()
    var sessionsConducted:String = String()
    
    var percentAttendance:CGFloat = CGFloat()
    
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        ref?.child("Classes").child(selectedClassID).child("Students").child(reformateEmail(email: currentUser.emailID)).observe(.childAdded, with: { (snapshot) in
            
            print("Key: \(snapshot.key)")
            if snapshot.key == "Presents"{
                self.sessionsAttended = snapshot.value as! String
            }
            
            if snapshot.key == "Absents"{
                self.sessionsAbsents = snapshot.value as! String

            }
            
            print("Sessions Attended: \(self.sessionsAttended)")
            print("Sessions Absents: \(self.sessionsAbsents)")
            
            
            
            
            
            
        })
        
        
        
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if animated{
            
            
            let presents = Int(self.sessionsAttended)
            let absents = Int(self.sessionsAbsents)
            
            
            let total = presents! + absents!
            
            self.sessionsConducted = "\(total)"
            
            if total == 0{
                self.percentAttendance = 0
            }
            else{
                
                let percent = (Float(presents!)/Float(total))*100
                print("Percentage of attendance: \(percent)")
                self.percentAttendance = CGFloat(percent)
            }
            
            let cell:RecordsCell2 = self.TableView.cellForRow(at: IndexPath(item: 2, section: 0)) as! RecordsCell2
            
            cell.attendedSessionsLabel.text = "Number of Attended Sessions: \(self.sessionsAttended)"
            cell.conductedSessionsLabel.text = "Number of sessions conducted: \(self.sessionsConducted)"
            cell.attendanceLimitLabel.text = "The attendance limit is not specified"
            
            
            
            let firstCell:RecordsCell1 = self.TableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! RecordsCell1
            
            UIView.animate(withDuration: 1) {
                firstCell.percentIndicator.value = self.percentAttendance
            }
            
            ////////////////////////////////////////////////
            
            
            //let indexPath = IndexPath(row: 1, section: 0)
            
           // let firstCell:RecordsCell1 = TableView.cellForRow(at: indexPath) as! RecordsCell1
            
            /*UIView.animate(withDuration: 1) {
                firstCell.percentIndicator.value = self.percentAttendance
            }*/
            
        }
       
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "enterRegisterationCodeVC") as! RegisterAttendanceViewController
            self.present(nextVC, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            
            let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            
            cell.textLabel?.text = String("Register Your Attendance")
            cell.textLabel?.textAlignment = NSTextAlignment.center
            
            TableView.rowHeight = 55

            return cell
            
        }
        
        if indexPath.row == 1{
            
            let cell:RecordsCell1 = TableView.dequeueReusableCell(withIdentifier: "RecordsCell1") as! RecordsCell1
            
          //  cell.percentIndicator.value = 80
           // cell.percentIndicator.progressColor = UIColor.colorFromHex(hex: "0B7FFF")
            TableView.rowHeight = 280
            
            return cell
            
        }
        
        else if indexPath.row == 2{
            
            let cell:RecordsCell2 = TableView.dequeueReusableCell(withIdentifier: "RecordsCell2") as! RecordsCell2
            
            cell.attendedSessionsLabel.text = "Number of Attended Sessions: 8"
            cell.conductedSessionsLabel.text = "Number of sessions conducted: \(sessionsConducted)"
            cell.attendanceLimitLabel.text = "The attendance limit is not specified"
            
            TableView.rowHeight = 100

            
            return cell
            
        }
        else if indexPath.row == 3{
            
            let cell:RecordsCell3 = TableView.dequeueReusableCell(withIdentifier: "RecordsCell3") as! RecordsCell3
            
            TableView.rowHeight = 55

            return cell
            
        }
        
        else if indexPath.row == 4{
            
            let cell:RecordsCell4 = TableView.dequeueReusableCell(withIdentifier: "RecordsCell4") as! RecordsCell4
            
            TableView.rowHeight = 55

            
            return cell
        }
        
        else{
            
            let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            
            cell.textLabel?.text = String("Extraneous Cell Generated")
            
            return cell
        }
    }

}

class RecordsCell1:UITableViewCell{
    
    @IBOutlet weak var percentIndicator: MBCircularProgressBarView!
    
    
    
}

class RecordsCell2:UITableViewCell{
    
    @IBOutlet weak var attendedSessionsLabel: UILabel!
    
    @IBOutlet weak var conductedSessionsLabel: UILabel!
    
    @IBOutlet weak var attendanceLimitLabel: UILabel!
    
    
}

class RecordsCell3:UITableViewCell{
    
    
}

class RecordsCell4:UITableViewCell{
    
    
}

class RegisterAttendanceCell:UITableViewCell{
    
}
