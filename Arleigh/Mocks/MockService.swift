//
//  MockService.swift
//  Arleigh
//
//  Created by Laurence Wingo on 6/15/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import Foundation

struct MockService : ZCService {
    
    
    func request<T : ZCAPIResource, R : ZCAPIResponse>(resource: T, completion: (_ response: R?, _ error: NSError?)-> Void) {
        
        print("Loading Mock CarePlan Data")
        
        if let path = Bundle.main.path(forResource: resource.path, ofType: "json"),
            let jsonData = NSData(contentsOfFile: path),
            let mockresponse = R(data: jsonData) {
            
        
            completion(mockresponse, nil)
            
        }
        else {
            
            let err = NSError(domain: "MockBackendErrorDomain", code: 0, userInfo: nil)
            completion(nil, err)
        }
        
    }
    
}
