//
//  dateFormatter.swift
//  todo_kirandeep_777255
//
//  Created by user176491 on 6/24/20.
//  Copyright © 2020 user176491. All rights reserved.
//

import Foundation
class dateFormatter {
    
    static func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
     
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
     
        formatter.dateFormat = "EEEE, MMM d, yyyy, hh:mm:ss"
       
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
}

extension Date {
    func toSeconds() -> Int64! {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(seconds:Int64!) {
        self = Date(timeIntervalSince1970: TimeInterval(Double.init(seconds)))
    }
}

