//
//  AnotherViewController.swift
//  Swift-POP
//
//  Created by Chris Hu on 17/1/12.
//  Copyright © 2017年 icetime17. All rights reserved.
//

import UIKit


private struct GithubUserInfo {
    let name: String
    let company: String
    let blog: String
    let email: String
    let url: String
    let followers: Int
    
    init?(data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
        
        guard let name      = json?["name"] as? String else { return nil }
        guard let company   = json?["company"] as? String else { return nil }
        guard let blog      = json?["blog"] as? String else { return nil }
        guard let email     = json?["email"] as? String else { return nil }
        guard let url       = json?["url"] as? String else { return nil }
        guard let followers = json?["followers"] as? Int else { return nil }
        
        self.name       = name
        self.company    = company
        self.blog       = blog
        self.email      = email
        self.url        = url
        self.followers  = followers
    }
    
}
// GithubUserInfo(data: data)


private enum HTTPMethod: String {
    case GET    = "GET"
    case POST   = "POST"
}

private protocol Request {
    var host: String { get }
    var path: String { get }
    
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
    
}

private struct GithubUserInfoRequest: Request {
    let name: String
    
    let host: String = "https://api.github.com"
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    let parameter: [String : Any] = [:]
    
    mutating func rquestInfo() {
        let url = URL(string: "\(host)\(path)")
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let userInfo = GithubUserInfo(data: data)
                print(userInfo)
            }
        }
        task.resume()
    }
}

class AnotherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        let urlString = "https://api.github.com/users/onevcat"
        guard let url = URL(string: urlString) else { return }
        do {
            guard let user = try GithubUserInfo(data: Data(contentsOf: url)) else { return }
            print(user)
        } catch {
            print("error")
        }
         */
        
        
        var userInfoRequest = GithubUserInfoRequest(name: "onevcat")
        userInfoRequest.rquestInfo()
        
        
    }
    
}
