//
//  MockService.swift
//  Arleigh
//
//  Created by Laurence Wingo on 6/15/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import Foundation

struct MockService : ZCService {
    
    
    func request<T : ZCAPIResource, R : ZCAPIResponse>(resource: T, completion: (response: R?, error: NSError?)-> Void) {
        
        print("Loading Mock CarePlan Data")
        
        if let path = NSBundle.mainBundle().pathForResource(resource.path, ofType: "json"),
            jsonData = NSData(contentsOfFile: path),
            mockresponse = R(data: jsonData) {
            
            
            completion(response: mockresponse, error:nil)
            
        }
        else {
            
            let err = NSError(domain: "MockBackendErrorDomain", code: 0, userInfo: nil)
            completion(response: nil, error:err)
        }
        
    }
    
}
