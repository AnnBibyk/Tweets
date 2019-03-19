//
//  APITwitterDelegate.swift
//  d04
//
//  Created by Anna BIBYK on 1/19/19.
//  Copyright © 2019 Anna BIBYK. All rights reserved.
//

import Foundation

protocol APITwitterDelegate {
    func getTweets(tweet: [Tweet])
    func tweetError(errmsg: NSError)
}
