//
//  ModelsAndData.swift
//  Attendance Connect
//
//  Created by Neel on 24/07/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import Foundation
import Firebase

var loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")

class User:NSObject,NSCoding{
    
    var type:userType = .Unknown
    var username:String = String()
    var emailID:String = String()
    var ID:String = String() //This would be roll no. in case of student and teacher ID in case of teacher
    var instituteName:String = String()
    var classGrade:String = String() //Not applicable for teachers
    var age:String = String() //Not applicable for teachers
    
    override init() {
        //Do nothing for now
    }
    
    func encode(with aCoder: NSCoder) {
        
       // aCoder.encode(type, forKey: "currentUserType")
        aCoder.encode(username, forKey: "currentUserName")
        aCoder.encode(emailID, forKey: "currentUserEmail")
        aCoder.encode(ID, forKey: "currentUserID")
        aCoder.encode(instituteName, forKey: "currentUserInstitute")
        aCoder.encode(classGrade, forKey: "currentUserClass")
        aCoder.encode(age, forKey: "currentUserAge")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.username = (aDecoder.decodeObject(forKey: "currentUserName") as? String)!
        self.type = (aDecoder.decodeObject(forKey: "currentUserType") as? userType)!
        self.emailID = (aDecoder.decodeObject(forKey: "currentUserEmail") as? String)!
        self.ID = (aDecoder.decodeObject(forKey: "currentUserID") as? String)!
        self.instituteName = (aDecoder.decodeObject(forKey: "currentUserInstitute") as? String)!
        self.classGrade = (aDecoder.decodeObject(forKey: "currentUserClass") as? String)!
        self.age = (aDecoder.decodeObject(forKey: "currentUserAge") as? String)!
    }
    
    
}

class Announcement{
    
    var classID:String = String()
    var teacher:String = String()
    
    var title:String = String()
    var content:String = String()
    var date:String = String()
    
    
}

//For currently logged in user
//Archiving and Dearchiving key for currentUser NSData is "currentUserData"
var currentUser = User()

enum userType {
    case Student
    case Teacher
    case Unknown
}

var emailID = UserDefaults.standard.string(forKey: "emailID")
var password = UserDefaults.standard.string(forKey: "password")
//var uniqueID = UserDefaults.standard.string(forKey: "uniqueID")
var databaseType = UserDefaults.standard.string(forKey: "databaseType")
var confirmPassword = String()
var name = String()
var rollNo = String()
var profilePhotoURL = UserDefaults.standard.url(forKey: "profilePhotoURL")

var classIDList = [String]()
var classnameList = [String]()
var announcementList = [Announcement]()

var selectedClassID = String()

///////////////   Custom Defined Methods  /////////////////

func reformateEmail(email:String) -> String{
    
    let newString = email.replacingOccurrences(of: ".", with: "_")
    print("Re-formated String:")
    print(newString)
    return newString
    
}

func printRetrivedInfo(){
    
    print("PRINTING RETRIVED INFORMATION")
    print("Roll no.\(currentUser.ID)")
    print("Institute name: \(currentUser.instituteName)")
    
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func saveCurrentUserData(){
    
    print("Inside the method saveCurrentUserData")
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: currentUser)
    UserDefaults.standard.set(encodedData, forKey: "currentUserData")
    
}

func retriveCurrentUserDataLocally(){
    
    if let data = UserDefaults.standard.data(forKey: "currentUserData"){
        
        currentUser = (NSKeyedUnarchiver.unarchiveObject(with: data) as? User)!
       
        
    }else{
        print("Unable to load the data from the specified key")
    }
    
}
