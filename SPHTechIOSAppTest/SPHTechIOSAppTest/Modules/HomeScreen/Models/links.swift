/*
 Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com
 */

//  links.swift
//  SPHTechIOSAppTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import Foundation
struct links : Codable {
	let start : String?
	let next : String?

	enum CodingKeys: String, CodingKey {

		case start = "start"
		case next = "next"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		start = try values.decodeIfPresent(String.self, forKey: .start)
		next = try values.decodeIfPresent(String.self, forKey: .next)
	}

}
