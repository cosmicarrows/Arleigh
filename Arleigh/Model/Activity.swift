//
//  Activity.swift
//  Arleigh
//
//  Created by Laurence Wingo on 6/15/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import CareKit
import SwiftyJSON



enum ActivityType: String {
    case Intervention
    case Assessment
}

enum ScheduleType: String {
    case Weekly
    case Daily
}

protocol Activity {
    
    var activityType: ActivityType { get set}
    
}

/**
 Struct that conforms to the Activity protocol to define either an intervention or assessment activity.
 */
struct ZCActivity : Activity {
    
    let identifier : String
    let title : String
    let text : String
    let startDate : NSDate
    let schedule : [NSNumber]
    let scheduleType : ScheduleType
    let instructions : String
    let imageURL : NSURL?
    var activityType: ActivityType
    
    init(fromJSON json: JSON, activityType: ActivityType) {
        self.identifier = json["identifier"].string!
        self.title = json["title"].string!
        self.instructions = json["instructions"].string!
        self.text = json["text"].string!
        if let imageString = json["imageURL"].string {
            self.imageURL = NSURL(string: imageString)
        }
        else {
            self.imageURL = nil
        }
        
        self.startDate = dateFromString(string: json["startdate"].string!)!
        self.scheduleType = ScheduleType(rawValue: json["scheduletype"].string!)!
        
       
        
        self.schedule = json["schedule"].string!.components(separatedBy: ",").map ( {
            NSNumber(value: Int32($0)!)
        })
        
        self.activityType = activityType
    }
    
    
    
    
}


