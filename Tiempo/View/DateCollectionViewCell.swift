//
//  DateCollectionViewCell.swift
//  Tiempo
//
//  Created by Adam Zemmoura on 21/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var weatherIconLabel: UILabel!
    
    @IBOutlet weak var currentDayHighlightView: UIView! {
        didSet {
            currentDayHighlightView.layer.borderWidth = 2
            currentDayHighlightView.layer.borderColor = UIColor.red.cgColor
            currentDayHighlightView.layer.cornerRadius = currentDayHighlightView.frame.width / 2
            currentDayHighlightView.clipsToBounds = true
            currentDayHighlightView.isHidden = true
        }
    }
    
    
    func configureForDay(day: Int, month: Month, weatherIcon: String? = nil) {
        
        dateLabel.text = "\(day)"
        let dayIsToday = day == Calendar.current.component(.day, from: Date())
        let currentMonth = month.rawValue == Calendar.current.component(.month, from: Date())
        shouldHighlightCell(bool: dayIsToday && currentMonth)
        
        weatherIconLabel.text = ""
        weatherIconLabel.text = weatherIcon
        
    }
    
    private func shouldHighlightCell(bool: Bool) {
        if bool { dateLabel.textColor = .red }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
    }
    
    override var isSelected: Bool {
        didSet {
            
            self.backgroundColor = isSelected == true ? .blue : .clear
            self.dateLabel.textColor = isSelected ? .white : .black
        }
    }
    
}
