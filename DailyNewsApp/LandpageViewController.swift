//
//  LandPage.swift
//  DailyNewsApp
//
//  Created by Chi Zhang on 2020/2/3.
//  Copyright © 2020 Chi Zhang. All rights reserved.
//
import Foundation
import UIKit

class LandpageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    var topstoriesJson: [JSONTopStories] = []
    var beforestoriesJson: [JSONStoriesBefore] = []
    var tracker = 0
    var hints = ["", "", "", "", ""]
    var titles = ["", "", "", "", ""]
    var urlStrings = ["", "", "", "", ""]
    var imageUrls = ["", "", "", "", ""]
    var images = [UIImage(), UIImage(), UIImage(), UIImage(), UIImage()]
    var detailUrl: URL?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedsTableView: FeedsTableView!
    @IBOutlet weak var botButton: UIButton!
    @IBOutlet weak var botLabel: UILabel!
    
    override func viewDidLoad() {
        updateDate()
        updateTitle()
        fetchData()
        updateTableView()
    }
    
    //update
    func updateDate() {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        dateLabel.text = "Date  \(month)/\(day)\nTime  \(hour):\(minute)"
        print("date updated")
    }
    
    func updateTitle() {
        titleLabel.text = "知乎日报"
        print("title updated")
    }
    
    func updateTableView() {
        feedsTableView.delegate = self
        feedsTableView.dataSource = self
        
        feedsTableView.register(FeedsCell.self, forCellReuseIdentifier: "feedsCell")
        feedsTableView.register(TopStoriesCell.self, forCellReuseIdentifier: "topsCell")
        feedsTableView.separatorStyle = .none
    }
    
    // Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return hints.count
        }
        return hints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topsCell", for: indexPath) as! TopStoriesCell
            cell.imageView1.image = images[tracker]
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightHandler))
            swipeRight.direction = .right
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftHandler))
            swipeLeft.direction = .left
            cell.addGestureRecognizer(swipeLeft)
            cell.addGestureRecognizer(swipeRight)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedsCell", for: indexPath) as! FeedsCell
            cell.label1.text = "Title: \(indexPath.row + 1) \(titles[indexPath.row])"
            cell.label2.text = "Hint: \(indexPath.row + 1) \(hints[indexPath.row])"
            cell.imageView1.image = images[indexPath.row]
            
            return cell
        }
    }
    
    @objc func swipeRightHandler() {
        if tracker == 0 {
            tracker = 4
        } else {
            tracker -= 1
        }
        let set: IndexSet = [0]
        feedsTableView.reloadSections(set, with: .automatic)
        print("worked")
    }
    
    @objc func swipeLeftHandler() {
        if tracker == 4 {
            tracker = 0
        } else {
            tracker += 1
        }
        let set: IndexSet = [0]
        feedsTableView.reloadSections(set, with: .automatic)
        print("worked")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath.row is \(indexPath.row)")
        print("indexPath.section is \(indexPath.section)")
        if indexPath.section == 0 {
            detailUrl = URL(string: urlStrings[tracker])
        } else {
            detailUrl = URL(string: urlStrings[indexPath.row])
        }
        print("detailUrl index is now: \(indexPath.row), about to performSegue of it")
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let vc = segue.destination as! DetailWebViewController
            vc.webUrl = detailUrl
        }
    }
    
    //fetch Data from API
    func fetchData() {
        let url = URL(string: "https://news-at.zhihu.com/api/4/stories/latest")!
        let task = URLSession.shared.dataTask(with: url) {[weak self](data, response, error) in
            if error == nil {
                guard let data = data else {return}
                //resultText = String(data: data, encoding: .utf8)
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(JSONStoriesLatest.self, from: data)
                    for each in 0..<model.top_stories.count {
                        self?.topstoriesJson.append(model.top_stories[each])
                        
                        
                        self?.hints[each] = model.top_stories[each].hint
                        self?.titles[each] = model.top_stories[each].title
                        self?.imageUrls[each] = model.top_stories[each].image
                        self?.urlStrings[each] = model.top_stories[each].url
                        let imageData = try! Data(contentsOf: URL(string: (self?.imageUrls[each])!)!)
                        self?.images[each] = UIImage(data: imageData)!
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
                DispatchQueue.main.async {
                    print("Thread: \(Thread.current.isMainThread)")
                    self?.feedsTableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func fetchMore() {
        let url = URL(string: "placeholder")!
        let task = URLSession.shared.dataTask(with: url) {[weak self](data, response, error) in
            if error == nil {
                guard let data = data else {return}
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(JSONStoriesLatest.self, from: data)
                    for each in 0...4 {
                        self?.hints[each] = model.top_stories[each].hint
                        self?.titles[each] = model.top_stories[each].title
                        self?.imageUrls[each] = model.top_stories[each].image
                        self?.urlStrings[each] = model.top_stories[each].url
                        let imageData = try! Data(contentsOf: URL(string: (self?.imageUrls[each])!)!)
                        self?.images[each] = UIImage(data: imageData)!
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
                DispatchQueue.main.async {
                    print("Thread: \(Thread.current.isMainThread)")
                    self?.feedsTableView.reloadData()
                }
            }
        }
        task.resume()
    }
}
