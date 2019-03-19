//
//  Tweet.swift
//  d04
//
//  Created by Anna BIBYK on 1/19/19.
//  Copyright © 2019 Anna BIBYK. All rights reserved.
//

import Foundation

struct Tweet : CustomStringConvertible {
    let name : String
    let text : String
    let date : String
    public var description: String {
        return "\(name)\n\(date)\n\(text)"
    }
}
