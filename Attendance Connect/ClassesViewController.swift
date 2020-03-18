//
//  ClassesViewController.swift
//  
//
//  Created by Neel on 30/07/18.
//

import UIKit
import Firebase

class ClassesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var classesTableView: UITableView!
    
    var ref:DatabaseReference?
    
    
    @IBAction func joinClassTapped(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "joinClassViewController") as! JoinClassViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        classesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classIDList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:teacherClassCell = tableView.cellForRow(at: indexPath) as! teacherClassCell
        
        selectedClassID = cell.classCodeLabel.text!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:teacherClassCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! teacherClassCell
        cell.classCodeLabel.text = classIDList[indexPath.row]
        cell.classNameLabel.text = classnameList[indexPath.row]
        
        //let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //cell.textLabel?.text = classIDList[indexPath.row]
        
        return cell
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

}
