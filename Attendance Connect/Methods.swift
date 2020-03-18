//
//  Methods.swift
//  Attendance Connect
//
//  Created by Neel on 12/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import Foundation
import Firebase

func generateClassCode(completion:@escaping (Bool,String)->()){
    
    
    
    var classCode:String?

    scanPreviousCodes { (success,code) in
     
        classCode = code
        completion(success,classCode!)
    
    }
    
}

func scanPreviousCodes(completionHandler:@escaping (Bool,String?)->()){
    
    var ref:DatabaseReference?
    ref = Database.database().reference()
    
    var databaseHandle:DatabaseHandle?
    
    var codeDataInt = [Int]()
    var code:String = String()
    
    ref?.child("Classes").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.exists() == true{
            
            for child in snapshot.children{
                
                
                code = String((child as AnyObject).key)
                
                code.removeFirst(4)
                
                print("Code: \(code)")
                
                codeDataInt.append(Int(code)!)
            }
            
            var classCode:String?
            var maxValue:Int?
            maxValue = codeDataInt.max()
            
            
            if maxValue == nil{
                maxValue = 999
            }
            
            let codeValue = maxValue! + 1
            
            classCode = "CNCT" + "\(codeValue)"
            
            print("Class Code Decided is: \(classCode!)")
            currentClassCode = classCode
            
            completionHandler(true,classCode)
            
            
        }
        
        
    })
    
    
    
}


