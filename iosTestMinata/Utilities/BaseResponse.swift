//
//  BaseResponse.swift
//  iosTestMinata
//
//  Created by Minata on 13/11/24.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
	let data: T?
}
