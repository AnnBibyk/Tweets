//
//  APIController.swift
//  d04
//
//  Created by Anna BIBYK on 1/19/19.
//  Copyright © 2019 Anna BIBYK. All rights reserved.
//

import Foundation

var tokenGlobal: String = ""

class APIController {
    var delegate : APITwitterDelegate?
    var token : String
    
    init(delegate: APITwitterDelegate, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
    func tweetRequest(keyString: String){
        let info = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\"\(keyString)\"&count=100&lang=en&result_type=recent".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        var url = URLRequest(url: info!)
        url.httpMethod = "GET"
        url.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                self.delegate?.tweetError(errmsg: error! as Error as NSError)
            }
            else
            {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    print(dic)
                    var tweet : [Tweet] = []
                    let statuses: [NSDictionary] = (dic["statuses"] as? [NSDictionary])!
                    for d in statuses {
                        let name = d["user"] as! NSDictionary
                        let date = d["created_at"]
                        let text = d["text"]
                        tweet.append(Tweet(name: name.value(forKey: "name")! as! String, text: text! as! String, date: date! as! String))
                    }
                    self.delegate?.getTweets(tweet: tweet)
                }
                catch let err
                {
                    print(err)
                }
            }
        }
        task.resume()
    }
}

