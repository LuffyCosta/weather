//
//  AppConfig.swift
//  weatherApp
//
//  Created by Danilo Costa on 17/09/2021.
//

import Foundation

struct Config: Decodable {
    private enum CodingKeys: String, CodingKey {
        case savedCity
    }

    let savedCity: [String: AnyObject]
}
