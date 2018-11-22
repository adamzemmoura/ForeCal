//
//  ViewController.swift
//  ForeCal
//
//  Created by Adam Zemmoura on 21/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    private var numberOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    private var currentMonth : Month = .jan
    private var currentYear = 0
    private var day = 0
    private var firstWeekdayOfMonth = 0
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.allowsMultipleSelection = false
        }
    }
    
    @IBOutlet weak var monthSelectionView: MonthSelectionView! {
        didSet {
            monthSelectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let now = Date()
        let calendar = Calendar.current
        currentMonth = Month(rawValue: calendar.component(.month, from: now))!
        currentYear = calendar.component(.year, from: now)
        day = calendar.component(.day, from: now)
        firstWeekdayOfMonth = getFirstWeekdayOfMonth()
    
    }
    
    private func getFirstWeekdayOfMonth() -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let firstDayOfMonth = Calendar.current.firstWeekday
        //let firstDayOfMonth = formatter.date(from: "\(currentYear)-\(currentMonth.rawValue)-01")!
        print("first day of the month : \(firstDayOfMonth)")
        
        print("current month : \(currentMonth.rawValue)")
        let firstWeekdayOfMonth = ("\(currentYear)-\(currentMonth.rawValue)-01".date?.firstDayOfTheMonth.weekday)!
        print("First weekday of the month : \(firstWeekdayOfMonth)")
        return firstWeekdayOfMonth
    }

}

extension CalendarViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth[currentMonth.rawValue - 1] + (firstWeekdayOfMonth - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell
        
        if indexPath.item <= firstWeekdayOfMonth - 2 {
            cell.isHidden = true
        } else {
            let calculatedDate = indexPath.row - (firstWeekdayOfMonth - 2)
            cell.isHidden = false
            cell.configureForDay(day: calculatedDate)
            
        }
        
        return cell
    }
    
    
    
    
}

extension CalendarViewController : UICollectionViewDelegate {
    
    
}

extension CalendarViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
}

extension CalendarViewController : MonthSelectionViewDelegate {
    func monthSelectionViewDidChange(month: Month, year: Int) {
        currentMonth = month
        currentYear = year
        
        firstWeekdayOfMonth = getFirstWeekdayOfMonth()
        collectionView.reloadData()
    }
}
