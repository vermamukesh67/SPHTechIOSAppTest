/*
 Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com
 */

//  Result.swift
//  SPHTechIOSAppTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//


import Foundation
struct Result : Codable {
	let resource_id : String?
	let fields : [Fields]?
	let records : [Records]?
	let _links : links?
	let limit : Int?
	let total : Int?

	enum CodingKeys: String, CodingKey {

		case resource_id = "resource_id"
		case fields = "fields"
		case records = "records"
		case _links = "_links"
		case limit = "limit"
		case total = "total"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		resource_id = try values.decodeIfPresent(String.self, forKey: .resource_id)
		fields = try values.decodeIfPresent([Fields].self, forKey: .fields)
		records = try values.decodeIfPresent([Records].self, forKey: .records)
		_links = try values.decodeIfPresent(links.self, forKey: ._links)
		limit = try values.decodeIfPresent(Int.self, forKey: .limit)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
	}

}
