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
    var topstoriesJSON: [JSONTopStories] = []
    var storiesDict: [String: [JSONStories]] = [:]
    var imagesCache: [String: [UIImage]] = [:]
    var gap = 0 // Dates gap
    var tracker = 0 // Top stories images index
    var requestRemaining = 0
    var topstoriesImages = [UIImage(), UIImage(), UIImage(), UIImage(), UIImage()]
    var detailUrl: URL?
    var isLoading: Bool = false
    var timeStamp: String = {
        let date = Date().description
        let endIndex = date.firstIndex(of: " ") ?? date.endIndex
        var string = date[..<endIndex]
        string.removeAll(where: {$0 == "-"})
        return String(string)
    }()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedsTableView: FeedsTableView!
    
    override func viewDidLoad() {
        updateDate()
        updateTitle()
        fetchLatestData()
        fetchMoreStories()
    }
    
    func updateDate() {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        dateLabel.text = "\(month)月 \(day)日"
        print("date updated")
    }
    
    func updateTitle() {
        titleLabel.text = "知乎日报"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
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
        return storiesDict.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let dateIndex = datesToString(days: section - 1)
            return storiesDict[dateIndex]!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topsCell", for: indexPath) as! TopStoriesCell
            cell.imageView1.image = topstoriesImages[tracker]
            
            let targetColor = UIColor(hex: topstoriesJSON[tracker].image_hue) ?? UIColor.red
            let gradColors = [UIColor(red: 0x00, green: 0x00, blue: 0x00, alpha: 0.0).cgColor, targetColor.cgColor]
            cell.imageHue.image = UIImage.gradientImageWithBounds(bounds: cell.bounds, colors: gradColors)
            
            let titleString = topstoriesJSON[tracker].title
            if titleString.count <= 14 {
                cell.titleLabel.text = topstoriesJSON[tracker].title
            } else {
                let midIndex = titleString.index(titleString.startIndex, offsetBy: 14)
                let s1 = titleString[titleString.startIndex..<midIndex]
                let s2 = titleString[midIndex..<titleString.endIndex]
                cell.titleLabel.numberOfLines = 2
                cell.titleLabel.text = "\(s1)\n\(s2)"
            }
            cell.hintLabel.text = topstoriesJSON[tracker].hint
            cell.pageControl.numberOfPages = topstoriesJSON.count
            cell.pageControl.currentPage = tracker
            
            // Add gestures
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightHandler))
            swipeRight.direction = .right
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftHandler))
            swipeLeft.direction = .left
            cell.addGestureRecognizer(swipeLeft)
            cell.addGestureRecognizer(swipeRight)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedsCell", for: indexPath) as! FeedsCell
            let section = indexPath.section
            let row = indexPath.row
            let dateIndex = datesToString(days: section - 1)
            let titleString = storiesDict[dateIndex]![row].title
            if titleString.count <= 12 {
                cell.titleLabel.text = titleString
            } else {
                let midIndex = titleString.index(titleString.startIndex, offsetBy: 12)
                let s1 = titleString[titleString.startIndex..<midIndex]
                let s2 = titleString[midIndex..<titleString.endIndex]
                cell.titleLabel.numberOfLines = 2
                cell.titleLabel.text = "\(s1)\n\(s2)"
            }
            //cell.titleLabel.text = "\(storiesDict[dateIndex]![row].title)"
            cell.hintLabel.text = "\(storiesDict[dateIndex]![row].hint)"
            cell.imageView1.image = imagesCache[dateIndex]![row]
            // 成功的：cell.imageView1.image = uiimage
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
    }
    
    @objc func swipeLeftHandler() {
        if tracker == 4 {
            tracker = 0
        } else {
            tracker += 1
        }
        let set: IndexSet = [0]
        feedsTableView.reloadSections(set, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        } else {
            return 100
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height - 150 {
            if !isLoading {
                fetchMoreStories()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section <= 1 {
            return 0
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let label: UILabel = {
            let label = UILabel()
            let sectionDate = Date() - TimeInterval((section - 1) * 86400)
            let calendar = Calendar.current
            let month = calendar.component(.month, from: sectionDate)
            let day = calendar.component(.day, from: sectionDate)
            label.text = "\(month)月\(day)日"
            label.font = UIFont.systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            detailUrl = URL(string: topstoriesJSON[tracker].url)
        } else {
            let section = indexPath.section
            let row = indexPath.row
            let dateIndex = datesToString(days: section - 1)
            detailUrl = URL(string: storiesDict[dateIndex]![row].url)
        }
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let vc = segue.destination as! DetailWebViewController
            vc.webUrl = detailUrl
        }
    }
    
    func fetchLatestData() {
        requestRemaining += 1
        let url = URL(string: "https://news-at.zhihu.com/api/4/stories/latest")!
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            if error == nil {
                guard let data = data else { return }
                //resultText = String(data: data, encoding: .utf8)
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(JSONStoriesLatest.self, from: data)
                    
                    for each in 0..<model.top_stories.count {
                        self?.topstoriesJSON.append(model.top_stories[each])
                        let imageData = try! Data(contentsOf: URL(string: (self?.topstoriesJSON[each].image)!)!)
                        self?.topstoriesImages[each] = UIImage(data: imageData)!
                    }
                    let dateString = model.date
                    self?.storiesDict[dateString] = model.stories
                    // capacity
                    self?.imagesCache[dateString] = []
                    for each in 0..<model.stories.count {
                        let imageData = try! Data(contentsOf: URL(string: (model.stories[each].images[0]))!)
                        self?.imagesCache[dateString]?.append(UIImage(data: imageData)!)
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
                DispatchQueue.main.async {
                    self?.updateTableView()
                    self?.requestRemaining -= 1
                    if self?.requestRemaining == 0 {
                        self?.isLoading = false
                        self?.feedsTableView.reloadData()
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchMoreStories() {
        print("fetching more stories")
        isLoading = true
        requestRemaining += 1
        let dates = datesToString(days: gap)
        gap += 1
        let url = URL(string: "https://news-at.zhihu.com/api/4/stories/before/\(dates)")!
        let task = URLSession.shared.dataTask(with: url) {[weak self](data, response, error) in
            if error == nil {
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(JSONDailyStories.self, from: data)
                    let dateString = model.date
                    self?.storiesDict[dateString] = model.stories
                    self?.imagesCache[dateString] = []
                    for each in 0..<model.stories.count {
                        let imageData = try! Data(contentsOf: URL(string: (model.stories[each].images[0]))!)
                        self?.imagesCache[dateString]?.append(UIImage(data: imageData)!)
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
                DispatchQueue.main.async {
                    print("fetched a more, UI updating incoming")
                    self?.requestRemaining -= 1
                    if self?.requestRemaining == 0 {
                        self?.isLoading = false
                        self?.feedsTableView.reloadData()
                    }
                }
            }
        }
        task.resume()
    }
    
    func datesToString(days: Int) -> String {
        let date = Date()
        let interv = TimeInterval(days * 86400)
        let newDateString = (date - interv).description
        let endIndex = newDateString.firstIndex(of: " ") ?? newDateString.endIndex
        var string = newDateString[..<endIndex]
        string.removeAll(where: {$0 == "-"})
        return String(string)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        let start = hex.index(hex.startIndex, offsetBy: 2)
        let hexColor = String(hex[start...])
        
        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff)) / 255
                a = 0.6
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        return nil
    }
}
