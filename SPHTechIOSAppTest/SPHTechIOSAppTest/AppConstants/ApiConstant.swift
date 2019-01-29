//
//  ApiConstant.swift
//  SPHTechSwiftTest
//
//  Created by Rajesh Maurya on 28/01/19.
//  Copyright © 2019 Rajesh Maurya. All rights reserved.
//

import Foundation

struct MyGlobalStruct {
    public typealias CompletionHandler = (_ result : NSDictionary?, _ error : NSError?) -> Void
    public typealias completion = (_ success : Bool) -> Void
}

let BASEURL = "https://data.gov.sg"
