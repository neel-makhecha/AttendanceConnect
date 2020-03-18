//
//  ViewController.swift
//  Attendance Connect
//
//  Created by Neel on 18/07/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBAction func nextTapped(_ sender: Any) {
        
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        self.present(nextVC, animated: true, completion: nil)
        
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }


}

