//
//  FeedsCell.swift
//  DailyNewsApp
//
//  Created by Chi Zhang on 2020/2/5.
//  Copyright © 2020 Chi Zhang. All rights reserved.
//

import UIKit

class FeedsCell: UITableViewCell {

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
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let label1: UILabel = {
        let label = UILabel()
        label.text = "label1textPlaceHolder"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel()
        label.text = "label2textPlaceHolder"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let imageView1: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 200, y: 5, width: 80, height: 80))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    func setupCell() {
        addSubview(cellView)
        cellView.addSubview(label1)
        cellView.addSubview(label2)
        cellView.addSubview(imageView1)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            label1.heightAnchor.constraint(equalToConstant: 80),
            label1.widthAnchor.constraint(equalToConstant: 200),
            label1.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            label1.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
            
            label2.heightAnchor.constraint(equalToConstant: 40),
            label2.widthAnchor.constraint(equalToConstant: 200),
            label2.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 0),
            label2.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
