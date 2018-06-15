//
//  ZCServiceProvider.swift
//  Arleigh
//
//  Created by Laurence Wingo on 6/15/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import Foundation

// Helper method to create a particular service.

func newZCService(type: ZCServiceType) -> ZCService {
    
    switch type {
        
    //TODO: Addother type . i.e test, real back end etc
    case .Mock:
        return MockService()
    }
}

func dateFromString(string: String) -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZ"
    if let date = dateFormatter.dateFromString(string) {
        return date
    }
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
    if let date = dateFormatter.dateFromString(string) {
        return date
    }
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    if let date = dateFormatter.dateFromString(string) {
        return date
    }
    return nil
}
