//
//  ScrollViewController.swift
//  DailyNewsApp
//
//  Created by Chi Zhang on 2020/2/20.
//  Copyright © 2020 Chi Zhang. All rights reserved.
//

import Foundation
import UIKit

class ScrollViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image1 = UIImage(contentsOfFile: "image")
        let image2 = UIImage(contentsOfFile: "image")
        let image3 = UIImage(contentsOfFile: "image")
        let image4 = UIImage(contentsOfFile: "image")
        let image5 = UIImage(contentsOfFile: "image")
        let h1 = Holder()
        let h2 = Holder()
        let h3 = Holder()
        let h4 = Holder()
        let h5 = Holder()
        h1.iv.image = image1
        h2.iv.image = image2
        h3.iv.image = image3
        h4.iv.image = image4
        h5.iv.image = image5
        
        scrollView.addSubview(h1)
        scrollView.addSubview(h2)
        scrollView.addSubview(h3)
        scrollView.addSubview(h4)
        scrollView.addSubview(h5)
        
        let dict: [String: UIView] = ["p1": h1, "p2": h2, "p3": h3, "p4": h4, "p5": h5]
        let vertConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[p2(==p1)]|", options: [], metrics: nil, views: dict)
        let horiConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[p2(==p1)][p3(==p1)][p4(==p1)][p5(==p1)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: dict)
        NSLayoutConstraint.activate(vertConstraints + horiConstraints)
        print("viewDidLoad finished")
        print(scrollView.subviews[0])
        print(scrollView.subviews[1])
        print(scrollView.subviews[2])
        print(scrollView.subviews[3])
        print(scrollView.subviews[4])
    }
}


class Holder: UIView {
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let iv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    
    func setup() {
        addSubview(view)
        view.addSubview(iv)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            iv.topAnchor.constraint(equalTo: view.topAnchor),
            iv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            iv.leftAnchor.constraint(equalTo: view.leftAnchor),
            iv.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
