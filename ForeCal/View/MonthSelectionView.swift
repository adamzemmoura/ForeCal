//
//  MonthSelectionView.swift
//  ForeCal
//
//  Created by Adam Zemmoura on 21/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import UIKit

protocol MonthSelectionViewDelegate {
    func monthSelectionViewDidChange(month: Month, year: Int)
}

class MonthSelectionView: UIView {

    private var currentMonth : Month = .jan
    private var currentYear : Int = 0
    var delegate : MonthSelectionViewDelegate?
    
    
    // MARK:- IBOutlets
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // MARK:- IBActions
    @IBAction func rightButtonDidPress() {
        incrementMonth()
        updateUI()
        delegate?.monthSelectionViewDidChange(month: currentMonth, year: currentYear)
    }
    
    @IBAction func leftButtonDidPress() {
        decrementMonth()
        updateUI()
        delegate?.monthSelectionViewDidChange(month: currentMonth, year: currentYear)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let monthIndex = Calendar.current.component(.month, from: Date())
        currentMonth = Month(rawValue: monthIndex)!
        currentYear = Calendar.current.component(.year, from: Date())
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func decrementMonth() {
        if currentMonth == .jan {
            currentYear -= 1
        }
        let currentMonthIndex = currentMonth.rawValue
        let nextMonthIndex: Int
        if currentMonthIndex == 1 {
            nextMonthIndex = 12
        } else {
            nextMonthIndex = currentMonthIndex - 1
        }
        currentMonth = Month(rawValue: nextMonthIndex)!
    }
    
    private func incrementMonth() {
        if currentMonth == .dec {
            currentYear += 1
        }
        let currentMonthIndex = currentMonth.rawValue
        let nextMonthIndex: Int
        if currentMonthIndex == 12 {
            nextMonthIndex = 1
        } else {
            nextMonthIndex = currentMonthIndex + 1
        }
        currentMonth = Month(rawValue: nextMonthIndex)!
    }
    
    private func updateUI() {
        monthYearLabel.text = "\(currentMonth.toString()) \(currentYear)"
    }
    
}
