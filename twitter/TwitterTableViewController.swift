//
//  TwitterTableViewController.swift
//  d04
//
//  Created by Anna BIBYK on 1/19/19.
//  Copyright © 2019 Anna BIBYK. All rights reserved.
//

import UIKit

class TwitterTableViewController: UITableViewController, APITwitterDelegate, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet var twitterTable: UITableView!
    
    var tweetArr : [Tweet] = []
    var tableSearchBar: UISearchBar!
    var token : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createConnection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArr.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! TweetsTableViewCell
            self.tableSearchBar = cell.searchBar
            self.tableSearchBar.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell") as! TweetsTableViewCell
            cell.loginLabel.text = tweetArr[indexPath.row].name
            
            let date = tweetArr[indexPath.row].date
            print(date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
            let date2 = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            cell.dateLabel.text = dateFormatter.string(from: date2!)
            
            cell.tweetLabel.text = tweetArr[indexPath.row].text
            cell.loginLabel?.numberOfLines = 0
            cell.dateLabel?.numberOfLines = 0
            cell.tweetLabel?.numberOfLines = 0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 44
            return cell
        }
    }
    
    func getTweets(tweet: [Tweet]) {
        DispatchQueue.main.async {
            self.tweetArr = tweet
            self.twitterTable.reloadData()
        }
    }
    
    func tweetError(errmsg: NSError) {
        print(errmsg)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let controller = APIController(delegate: self as APITwitterDelegate, token: token)
        if (searchBar.text?.count)! > 0 {
            controller.tweetRequest(keyString: searchBar.text!)
        }
        else {
            controller.tweetRequest(keyString: "school 42")
        }
    }
    
    func twitterAuth() -> String {
        let CUSTUMER_KEY = "nK3fBkrnQ6QrdemMaOAsKAule"
        let CUSTUMER_SECRET = "avGYcuJgEOcRlCRc8Rfn9uOHAfp7oWEDfwyIYD1jdGfeZpePuc"
        let BEARER = ((CUSTUMER_KEY + ":" + CUSTUMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return BEARER
    }
    
    func createConnection() {
        let BEARER = twitterAuth()
        
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    let dic: Dictionary = try JSONSerialization.jsonObject(with: d, options: []) as! [String:Any]
                    
                    let controller = APIController(delegate: self as APITwitterDelegate, token: (dic["access_token"] as? String)!)
                    self.token = controller.token
                    controller.tweetRequest(keyString: "school 42")
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }
}

