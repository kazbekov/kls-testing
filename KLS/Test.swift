//
//  Test.swift
//  KLS
//
//  Created by Damir Kazbekov on 6/7/17.
//  Copyright © 2017 Dias Dosymbaev. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Test {
    var name: String = ""
    var score: String = ""
    var subject: String = ""
    var trueAnswers: String = ""
    var falseAnswers: String = ""
    
    init(name: String, score: String, subject:String, trueAnswers: String, falseAnswers: String) {
        self.name = name
        self.score = score
        self.subject = subject
        self.trueAnswers = trueAnswers
        self.falseAnswers = falseAnswers
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! NSDictionary
        name = value["name"] as! String
        score = value["score"] as! String
        subject = value["subject"] as! String
        trueAnswers = value["trueAnswers"] as! String
        falseAnswers = value["falseAnswers"] as! String
    }
    
    func toAnyObject() -> Any{
        return ["name":name,"score":score,"subject":subject,"trueAnswers":trueAnswers,"falseAnswers":falseAnswers]
    }
    
}
