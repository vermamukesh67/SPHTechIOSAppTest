/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com
*/

//  Fields.swift
//  SPHTechIOSAppTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import Foundation
struct Fields : Codable {
	let type : String?
	let id : String?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case id = "id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}

}
