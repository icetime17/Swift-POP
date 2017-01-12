//
//  AnotherViewController.swift
//  Swift-POP
//
//  Created by Chris Hu on 17/1/12.
//  Copyright © 2017年 icetime17. All rights reserved.
//

import UIKit


// https://api.github.com/users/onevcat
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



// http://httpbin.org/get
private struct HttpBinInfo {
    let origin: String
    let url: String
    
    init?(data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
        
        guard let origin    = json?["origin"] as? String else { return nil }
        guard let url       = json?["url"] as? String else { return nil }
        
        self.origin = origin
        self.url    = url
    }
}
// HttpBinInfoRequest()



// MARK: - request

private enum HTTPMethod: String {
    case GET    = "GET"
    case POST   = "POST"
}

private protocol Request {
    var host: String { get }
    var path: String { get }
    
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
    
    // 要针对不同的结构体或类指定不同的Response，类似泛型功能
    associatedtype Response: Decodable
    
    func rquestInfo()
    
    func parseResponse(data: Data)
}

private struct GithubUserInfoRequest: Request {
    // 指定在该struct中，Response即为GithubUserInfo
    typealias Response = GithubUserInfo

    let name: String
    
    let host: String = "https://api.github.com"
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    let parameter: [String : Any] = [:]
    
    func rquestInfo() {
        let url = URL(string: "\(host)\(path)")
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                self.parseResponse(data: data)
            }
        }
        task.resume()
    }
    
    func parseResponse(data: Data) {
//        let userInfo = GithubUserInfo(data: data)
//        print(userInfo)
        
        if let userInfo = Response.parse(data: data) {
            print(">>>>>>")
            print(userInfo)
            print(">>>>>>\n")
        }
    }
}


private struct HttpBinInfoRequest: Request {
    // 指定在该struct中，Response即为HttpBinInfoRequest
    typealias Response = HttpBinInfo
    
    let host: String = "http://httpbin.org"
    var path: String {
        return "/get"
    }
    let method: HTTPMethod = .GET
    let parameter: [String : Any] = [:]
    
    func rquestInfo() {
        let url = URL(string: "\(host)\(path)")
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                self.parseResponse(data: data)
            }
        }
        task.resume()
    }
    
    func parseResponse(data: Data) {
        //        let httpBinInfo = HttpBinInfo(data: data)
        //        print(httpBinInfo)
        
        if let httpBinInfo = Response.parse(data: data) {
            print(">>>>>>")
            print(httpBinInfo)
            print(">>>>>>\n")
        }
    }
}


// MARK: - parse

// 如何将parse分离
private protocol Decodable {
    static func parse(data: Data) -> Self?
}

// 使得GithubUserInfo有了parse的能力
extension GithubUserInfo: Decodable {
    static func parse(data: Data) -> GithubUserInfo? {
        return GithubUserInfo(data: data)
    }
}

// 使得HttpBinInfo有了parse的能力
extension HttpBinInfo: Decodable {
    static func parse(data: Data) -> HttpBinInfo? {
        return HttpBinInfo(data: data)
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
        
        
        
        /*
        let urlString = "http://httpbin.org/get"
        guard let url = URL(string: urlString) else { return }
        do {
            guard let httpBinInfo = try HttpBinInfo(data: Data(contentsOf: url)) else { return }
            print(httpBinInfo)
        } catch {
            print("error")
        }
        */
        
        var httpBinRequest = HttpBinInfoRequest()
        httpBinRequest.rquestInfo()
        
    }
    
}
