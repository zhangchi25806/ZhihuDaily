//
//  TopStoriesCell.swift
//  DailyNewsApp
//
//  Created by Chi Zhang on 2020/2/13.
//  Copyright © 2020 Chi Zhang. All rights reserved.
//

import UIKit

class TopStoriesCell: UITableViewCell {
    static var staticTracker = 0
    var tracker = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let imageView1: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    func setupCell() {
        addSubview(cellView)
        cellView.addSubview(imageView1)
        
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            imageView1.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 0),
            imageView1.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 0),
            imageView1.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 0),
            imageView1.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 0)
        ])
    }
    
    @objc func handlerTap() {
        print("handlerTap worked!")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("error type: \(coder)")
    }
}

