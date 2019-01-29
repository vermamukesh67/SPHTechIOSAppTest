//
//  MobileDataWebService.swift
//  SPHTechSwiftTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import Foundation

let BASEURL = "https://data.gov.sg"

struct MobileDataApiHandler {
    
    func getMobileDataUsed( url : String  ,completion: @escaping (MobileData?, _ error: Error?)->()) {
        
        let finalUrl = BASEURL + url
        
        WebApiManager.sharedService.requestAPI(url: finalUrl, parameter: nil, httpMethodType: .GET) { (response, urlResponse, error) in
            
            guard let data = response else {
                completion(nil, error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(MobileData.self, from: data)
                completion(responseModel,nil)
                
            } catch  let error {
                print(error.localizedDescription)
                completion(nil,error)
                return
            }
            
        }
    }
}
