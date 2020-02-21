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
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView1: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    let imageHue: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        
        return pc
    }()
    
    func setupCell() {
        addSubview(cellView)
        cellView.addSubview(imageView1)
        cellView.addSubview(imageHue)
        cellView.addSubview(titleLabel)
        cellView.addSubview(hintLabel)
        cellView.addSubview(pageControl)

        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            titleLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -50),
            
            hintLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
            hintLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -20),
            
            pageControl.topAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -40),
            pageControl.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 0),
            pageControl.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 80),
            pageControl.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -80),
            
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

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
