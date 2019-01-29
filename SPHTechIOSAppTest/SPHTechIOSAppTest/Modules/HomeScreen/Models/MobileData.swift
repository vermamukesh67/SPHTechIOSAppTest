/*
 Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com
 */

//  MobileData.swift
//  SPHTechIOSAppTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import Foundation
struct MobileData : Codable {
	let help : String?
	let success : Bool?
	let result : Result?

	enum CodingKeys: String, CodingKey {

		case help = "help"
		case success = "success"
		case result = "result"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		help = try values.decodeIfPresent(String.self, forKey: .help)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
		result = try values.decodeIfPresent(Result.self, forKey: .result)
	}

}
