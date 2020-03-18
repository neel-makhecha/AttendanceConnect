//
//  WhoRUViewController.swift
//  Attendance Connect
//
//  Created by Neel on 20/07/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit

class WhoRUViewController: UIViewController {
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func studentButton(_ sender: Any) {
        
        
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "studentRegisterVC") as! StudentRegisterationViewController
        self.present(nextVC, animated: true, completion: nil)
        
    }
    
    @IBAction func teacherButton(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "teacherRegisterVC") as! TeacherRegisterationViewController
        self.present(nextVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

}
