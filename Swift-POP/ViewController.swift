//
//  ViewController.swift
//  Swift-POP
//
//  Created by Chris Hu on 16/12/9.
//  Copyright © 2016年 icetime17. All rights reserved.
//

import UIKit

// POP

// https://api.onevcat.com/users/onevcat
struct User {
    let name: String
    let message: String
    
    init?(data: Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        guard let name = obj?["name"] as? String else { return nil }
        guard let message = obj?["message"] as? String else { return nil }
        
        self.name = name
        self.message = message
    }
}
//User(data: data)


// 使用POP的方式从URL请求数据，并生成对应的User。
enum HTTPMethod: String {
    case GET
    case POST
}

// 规定Request所需的参数
protocol Request {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
    
    // 是否实现类似泛型的功能
    // 关联类型，想要send方法对于所有的Request都通用。
    // 所以要针对不同的结构体或类指定不同的Response
    associatedtype Response
    
    // 定义方法如何解析request返回的data
    // 要针对不同的结构体或类指定不同的parse方法，所以不放在extension中。
    func parse(data: Data) -> Response?
}

// 规定Request的方法
extension Request {
    func send(handler: @escaping (Response?) -> Void) {
        // 协议扩展中只能是默认的实现方法
        // 通过默认方法实现通用的send
        let url = URL(string: host.appending(path))!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 在示例中我们不需要 `httpBody`，实践中可能需要将 parameter 转为 data
        // request.httpBody = ...
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let data = data, let res = self.parse(data: data) {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

// 继续Request协议，则Request规定的属性全部都要实现
// 而UserRequest的初始化与Request的属性无关。
struct UserRequest: Request {
    let name: String
    
    let host = "https://api.onevcat.com"
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    let parameter: [String : Any] = [:]
    
    // 针对UserRequest，指定Response为User
    typealias Response = User
    
    // 通过解析Request返回的Data获取User
    func parse(data: Data) -> User? {
        return User(data: data)
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = UserRequest(name: "onevcat")
        request.send { (user) in
            if let user = user {
                print("\(user.message) from \(user.name)")
            }
        }
    }

}

