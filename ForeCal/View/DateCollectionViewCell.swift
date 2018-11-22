//
//  DateCollectionViewCell.swift
//  ForeCal
//
//  Created by Adam Zemmoura on 21/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.topAnchor.constraint(equalTo: topAnchor).isActive=true
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
            dateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        }
    }
    
    func configureForDay(day: Int) {
        dateLabel.text = "\(day)"
    }
    
}
