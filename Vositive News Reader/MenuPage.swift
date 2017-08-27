//
//  MenuPage.swift
//  Vositive News Reader
//
//  Created by Daniel Chong on 17/7/17.
//  Copyright © 2017 Vositive Solutions. All rights reserved.
//

import UIKit

class MenuPage: NSObject {
    
    let backView = UIView()
    let menuTableView = UITableView()
    let articleSources = ["TechCrunch","TechRadar"]
    var mainVC: HomeViewController?

    
    public func loadMenuPage() {
        if let window = UIApplication.shared.keyWindow {
            backView.frame = window.frame
            backView.backgroundColor = UIColor(white: 0, alpha: 0.8)
            backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissMenuPage)))
            
            let height: CGFloat = 100.0
            let y = window.frame.height - height
            menuTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            menuTableView.backgroundColor = UIColor.black
            
            window.addSubview(backView)
            window.addSubview(menuTableView)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.backView.alpha = 0.8
                self.menuTableView.frame.origin.y = y
            })
        }
    }
    
    public func dismissMenuPage () {
        UIView.animate(withDuration: 0.5) { 
            self.backView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.menuTableView.frame.origin.y = window.frame.height
            }
        }
    }
    
    override init() {
        super .init()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isScrollEnabled = false
        menuTableView.bounces = false
        menuTableView.register(menuTableViewCell.self, forCellReuseIdentifier: "articleSources")
    }
    
} // final closing bracket

extension MenuPage: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleSources", for: indexPath) as UITableViewCell
        cell.textLabel?.text = articleSources[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC {
            vc.source = articleSources[indexPath.item].lowercased()
            vc.fetchArticle(fromSource: articleSources[indexPath.item].lowercased())
        } else {
            print ("error")
        }
    }
}
