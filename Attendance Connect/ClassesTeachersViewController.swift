//
//  ClassesTeachersViewController.swift
//  Attendance Connect
//
//  Created by Neel on 12/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import Firebase

var classList = [String]()
//var classnameList = [String]()
class ClassesTeachersViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    
    
    @IBOutlet weak var classesTableView: UITableView!
    
    var ref:DatabaseReference?
    var databaseHandler:DatabaseHandle = 0
    
   // var classList = [String]()
  //  var classnameList = [String]()
    
    @IBAction func newClassTapped(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "newClassViewController") as! NewClassViewController

        self.present(nextVC, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        ref = Database.database().reference()
        
        /*let user = reformateEmail(email: emailID!)
        print("Class List")
        ref?.child("Users").child(user).child("Classes").observe(.childAdded, with: { (snapshot) in
            
            let classCode = snapshot.key as! String
            classList.append(classCode)
            let classname = snapshot.value as! String
            classnameList.append(classname)
            self.classesTableView.reloadData()
        })*/
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        classesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:teacherClassCell = tableView.cellForRow(at: indexPath) as! teacherClassCell
        
        selectedClassID = cell.classCodeLabel.text!
        
        //let nextVC = storyboard?.instantiateViewController(withIdentifier: "Teachers_detailedClassVC") as! DetailedClassViewController
        
        //self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:teacherClassCell = self.classesTableView.dequeueReusableCell(withIdentifier: "teachersClassCell") as! teacherClassCell
        cell.classNameLabel.text = "\(classnameList[indexPath.row])"
        cell.classCodeLabel.text = "\(classList[indexPath.row])"
        cell.rowIndexLabel.text = "\(indexPath.row+1)"

        return cell
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    

}

class teacherClassCell:UITableViewCell{
    
    @IBOutlet weak var classNameLabel: UILabel!
    
    
    @IBOutlet weak var classCodeLabel: UILabel!
    
    
    @IBOutlet weak var rowIndexLabel: UILabel!
    
}
