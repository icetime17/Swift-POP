//
//  MyTableViewController.swift
//  Swift-POP
//
//  Created by Chris Hu on 17/1/13.
//  Copyright © 2017年 icetime17. All rights reserved.
//

import UIKit

extension UITableView {
//    func register(_ cellType: MyTableViewCell.Type) {
//        let nib = UINib(nibName: MyTableViewCell.nibName, bundle: nil)
//        register(nib, forCellReuseIdentifier: MyTableViewCell.reuseIdentifier)
//    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadable {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("CSSwiftExtension: Could not dequeue cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
    
}

class MyTableViewController: UIViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
    }
    
    func initTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
//        String(describing: MyTableViewCell.self)
        
//        tableView.register(UINib(nibName: MyTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: MyTableViewCell.reuseIdentifier)
        
        tableView.register(MyTableViewCell.self)
        
    }
    
}

extension MyTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.reuseIdentifier, for: indexPath) as! MyTableViewCell
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MyTableViewCell
        
        cell.myImageView.image = UIImage(named: "Model.png")
        cell.myLabel.text = "cell - \(indexPath.row)"
        
        return cell
    }
}

extension MyTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

