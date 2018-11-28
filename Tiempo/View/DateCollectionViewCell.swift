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
    
    func configureForDate(date: Date?, weatherData: WeatherDataForDay? = nil) {
        
        dateLabel.text = ""
        weatherIconLabel.text = ""
        
        if let date = date {
            dateLabel.text = String(Calendar.current.component(.day, from: date))
            let dayIsToday = Calendar.current.isDateInToday(date)
            shouldHighlightCell(bool: dayIsToday)
        }
        
        let weatherIcon = weatherData?.icon != nil ? WeatherIcon(rawValue: weatherData!.icon!)!.image : ""
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
