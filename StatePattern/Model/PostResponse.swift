//
//  PostResponse.swift
//  StatePattern
//
//  Created by Pooyan J on 3/17/1404 AP.
//

import Foundation

struct PostResponse: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
