//
//  CarePlan.swift
//  Arleigh
//
//  Created by Laurence Wingo on 6/15/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import Foundation
import CareKit
import SwiftyJSON

/**
 Struct which encapsulates the CarePlan
 */
public struct CarePlan {
    
    let planID: Int
    let title : String
    var activities : [Activity] = []
    
    init (planID:Int, title:String) {
        
        self.planID = planID
        self.title = title
    }
    
}

extension CarePlan : Equatable {}

public func ==(lhs: CarePlan, rhs: CarePlan) -> Bool {
    return lhs.planID == rhs.planID &&
        lhs.title == rhs.title
}


/**
 CarePlan conforms to the ZCAPIResponse protocol.  tthis implementation parses the json  careplan  and maps activities to local immutable Activity Struct
 
 */
extension CarePlan : ZCAPIResponse {
    
    init?(data:NSData?) {
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! NSDictionary
            
            guard
                let planID = json["planID"] as? Int,
                let title = json["title"] as? String,
                let intervention_activities = json["intervention_activities"] as? Array<NSDictionary>,
                let assessment_activities = json["assessment_activities"] as? Array<NSDictionary>
                
                else { return nil }
            
            self.planID = planID
            self.title = title
            
            for intervention in intervention_activities {
                let activity = ZCActivity(fromJSON: JSON(intervention), activityType: .Intervention)
                activities.append(activity)
            }
            
            for assessment in assessment_activities {
                let activity = ZCActivity(fromJSON: JSON(assessment), activityType: .Assessment)
                activities.append(activity)
            }
            
        }
        catch {
            print("Failed to initialise CarePlan")
            return nil
        }
        
    }
    
}
