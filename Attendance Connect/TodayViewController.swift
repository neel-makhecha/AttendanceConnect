//
//  TodayViewController.swift
//  Attendance Connect
//
//  Created by Neel on 30/07/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

var catchPhotoURL:URL?



class TodayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
    
    
   
    var ref:DatabaseReference?
    
    var classnameList = [String]()
    var todaySchedule = [String]()
    
    lazy var refresher:UIRefreshControl = {
       
        let refreshControl:UIRefreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
        
    }()
    
    @objc func refreshData(){
    self.TodayTableView.reloadData()
        
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    
    @IBOutlet weak var TodayTableView: UITableView!
    
    
    @IBOutlet weak var refreshButtonOutlet: UIButton!
    
    
    func updateSearchResults(for searchController: UISearchController) {
        //Something
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
       // TodayTableView.refreshControl = refresher

        TodayTableView.addSubview(refresher)
        
        catchPhotoURL = Auth.auth().currentUser?.photoURL
        TodayTableView.dataSource = self
        TodayTableView.delegate = self
        
        let cellNib = UINib(nibName: "AnnouncementCell", bundle: Bundle.main)
        let cellNib2 = UINib(nibName: "TodayScheduleTableCell", bundle: Bundle.main)
        
        TodayTableView.register(cellNib, forCellReuseIdentifier: "AnnouncementCell")
        TodayTableView.register(cellNib2, forCellReuseIdentifier: "TodayScheduleCell")

        
       
        
       
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /*for classCode in classIDList{
            ref?.child("Classes").child(classCode).child("Schedule").observe(.childAdded, with: { (snapshot) in
                
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
                    self.todayScheduleTimings.append((snapshot.value as! String))
                    print("Appending \(snapshot.key) schedule with time \((snapshot.value as! String))")
                }
                
            })
        }*/
        
        print("TODAY VIEW DID APPEAR")
        TodayTableView.reloadData()

        if animated{
        }
       
        
        
        print("Total announcements: \(announcementList.count)")
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return classIDList.count
        }else{
            return announcementList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "Schedule"
        }else{
            return "Announcements"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AnnouncementDetailedVC")
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0{
            
            let cell:TodayScheduleTableCell = TodayTableView.dequeueReusableCell(withIdentifier: "TodayScheduleCell") as! TodayScheduleTableCell
            
            cell.subjectNameLabel.text = "\(classIDList[indexPath.row])"
            cell.facultyOrClassName.text = "By, Prof. Albert Mathew"
            print("Trying timings for index: \(indexPath.row)")
            cell.timeLabel.text = "At \(todayScheduleTimings[indexPath.row])"
            tableView.rowHeight = 80
            
            return cell
        }
        else{
            
            
            let cell:AnnouncementCell = TodayTableView.dequeueReusableCell(withIdentifier: "AnnouncementCell") as! AnnouncementCell
            
            cell.titleLabel.text = announcementList[indexPath.row].title
            cell.contentLabel.text = announcementList[indexPath.row].content
            cell.dateLabel.text = announcementList[indexPath.row].date
            cell.teacherLabel.text = announcementList[indexPath.row].teacher
            tableView.rowHeight = 200

            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    


}
