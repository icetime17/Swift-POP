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
private struct User {
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


// MARK: -
// 使用POP的方式从URL请求数据，并生成对应的User。
private enum HTTPMethod: String {
    case GET
    case POST
}

// 规定Request所需的参数
private protocol Request {
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
    
    // 是否实现类似泛型的功能
    // 关联类型，想要send方法对于所有的Request都通用。
    // 所以要针对不同的结构体或类指定不同的Response
    associatedtype Response: Decodable
    // 将parse放到Decodable中，做到Request与Parse分离
    
    // 定义方法如何解析request返回的data
    // 要针对不同的结构体或类指定不同的parse方法，所以不放在extension中。
//    func parse(data: Data) -> Response?
}

//// 规定Request的方法
//extension Request {
//    func send(handler: @escaping (Response?) -> Void) {
//        // 协议扩展中只能是默认的实现方法
//        // 通过默认方法实现通用的send
//        let url = URL(string: host.appending(path))!
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        
//        // 在示例中我们不需要 `httpBody`，实践中可能需要将 parameter 转为 data
//        // request.httpBody = ...
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
//            if let data = data, let res = self.parse(data: data) {
//                DispatchQueue.main.async { handler(res) }
//            } else {
//                DispatchQueue.main.async { handler(nil) }
//            }
//        }
//        task.resume()
//    }
//}


// MARK: -
// 继续Request协议，则Request规定的属性全部都要实现
// 而UserRequest的初始化与Request的属性无关。
private struct UserRequest: Request {
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
//    func parse(data: Data) -> User? {
//        return User(data: data)
//    }
}


// MARK: - 重构
// MARK: -
// 通过Client协议，将send与Request分离，而sender需要的参数r为遵循Request协议的对象
// 闭包接收的参数为Response，该Response继承了Decodable协议（包含parse方法）
private protocol Client {
    var host: String { get }
    
    // 因Request含有关联类型（associatedtype Response）,所以不能作为独立类型使用。
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void)
}

// 将send，parse，请求本身分离
private struct URLSessionClient: Client {
    let host = "https://api.onevcat.com"
    
    // send方法接收参数r为继承了T的对象，即继承Request的对象，必须使用T: Request这种方式
    // 传入的闭包接收参数为T.Response，Response为关联类型，继承自Decodable协议，所以具有parse方法（该方法返回对象本身）
    // UserRequest继承Request协议，且通过typealias指定了Reponse的类似为User。
    // 所以此处的T.Response即为一个User对象。所以能够得到name和message。
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            //            if let data = data, let res = self.parse(data: data) {
            if let data = data, let res = T.Response.parse(data: data) {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

// 在Request的Response关联类型中加上Decodable协议，则所有的Response都可对数据进行解析。
private protocol Decodable {
    static func parse(data: Data) -> Self?
}

// User继承Decodable才有parse方法
extension User: Decodable {
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}


// MARK: -
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let request = UserRequest(name: "onevcat")
//        request.send { (user) in
//            if let user = user {
//                print("\(user.message) from \(user.name)")
//            }
//        }
        
        // 重构，将关注点分离。
        // 即：Request，send，parse分离
        URLSessionClient().send(UserRequest(name: "onevcat")) { (user) in
            if let user = user {
                print(">>>>>> \(user.message) from \(user.name)")
            }
        }
    }

}

