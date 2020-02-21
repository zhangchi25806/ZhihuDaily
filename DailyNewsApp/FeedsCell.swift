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
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "label1textPlaceHolder"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "label2textPlaceHolder"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let imageView1: UIImageView = {
        //let imageView = UIImageView(frame: CGRect(x: 200, y: 5, width: 75, height: 75))
        let imageView = UIImageView()
        //let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    func setupCell() {
        addSubview(cellView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(hintLabel)
        cellView.addSubview(imageView1)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 80),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
            
            hintLabel.heightAnchor.constraint(equalToConstant: 40),
            hintLabel.widthAnchor.constraint(equalToConstant: 200),
            hintLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 0),
            hintLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
            
            imageView1.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10),
            imageView1.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            imageView1.widthAnchor.constraint(equalToConstant: 75),
            imageView1.heightAnchor.constraint(equalToConstant: 75)
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
