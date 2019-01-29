//
//  WebApiManager.swift
//  SPHTechSwiftTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import Foundation

class WebApiManager: NSObject {
    
    static let sharedService = WebApiManager()
    
    typealias WebServiceCompletionBlock = (_ data: Data?, _ response: URLResponse?,_ error: Error?)->Void
    
    enum HTTPMethodType: Int {
        case POST = 0
        case GET
    }
    
    func requestAPI(url: String,parameter: [String: AnyObject]?, httpMethodType: HTTPMethodType, completion: @escaping WebServiceCompletionBlock) {
        
        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: escapedAddress!)!)
        
        switch httpMethodType {
        case .POST:
            request.httpMethod = "POST"
        case .GET:
            request.httpMethod = "GET"
            
            if parameter != nil {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameter as Any, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                    return
                }
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let data = data, error == nil else {
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("Error in fetching response")
                }
                
                completion(data,response,nil)
            }
            task.resume()
        }
        
    }
    
}
