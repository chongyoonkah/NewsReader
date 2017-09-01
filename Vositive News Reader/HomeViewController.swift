//
//  HomeViewController.swift
//  Vositive News Reader
//
//  Created by Daniel Chong on 27/6/17.
//  Copyright © 2017 Vositive Solutions. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var articles:[Article]? = []
    var chosenArticleUrl = ""
    var source = "TechCrunch"
    let menuPage = MenuPage()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News"
        setupTableView()
        fetchArticle(fromSource: source)

    }
    
    func setupTableView(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor.red
        refreshControl.attributedTitle = NSAttributedString(string: "Loading latest news")
        refreshControl.addTarget(self, action: #selector(updateNewsData(_:)), for: .valueChanged)
    }
    
    func updateNewsData(_ sender: Any){
        fetchArticle(fromSource: source)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenArticleUrl = (self.articles?[indexPath.item].url)!
        performSegue(withIdentifier: "FullArticleVC", sender: nil)
    }
    
    func fetchArticle (fromSource provider: String){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=\(provider)&sortBy=latest&apiKey=39441aafe5ff40fba6171b443817bc8d")!)

        let task = URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            if error != nil {
                print("error in fetching data")
                return
            }
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                // taking data from database and cast it as a dictionary
                if let articlesFromWeb = json["articles"] as? [[String:AnyObject]] {
                    for articleFromJson in articlesFromWeb {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String, let imageUrl = articleFromJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.desc = desc
                            article.headline = title
                            article.url = url
                            article.urlImage = imageUrl
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    let alertController = UIAlertController(title: "Vositive News Reader", message: "Latest news updated", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }

    @IBAction func menuButtonPressed(_ sender: Any) {
        menuPage.loadMenuPage()
        menuPage.mainVC = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let destination = segue.destination as? FullArticleViewController {
            if chosenArticleUrl.isEmpty {
                print("failed to pass data")
            } else {
                destination.url = chosenArticleUrl
            }
        }
    }
    
} //final closing bracket

extension UIImageView{
    
    func downloadImage(from url:String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            if error != nil {
                print("error in downloading image")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data:data!)
            }
        }
        task.resume()
    } // separate urlsession as image will take a longer time to load
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        cell.titleLabel.text = self.articles?[indexPath.item].headline
        cell.descLabel.text = self.articles?[indexPath.item].desc
        cell.authorLabel.text = self.articles?[indexPath.item].author
        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].urlImage)!)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
        // if article is nil, will return as 0 instead of crashing
    }
    
}

