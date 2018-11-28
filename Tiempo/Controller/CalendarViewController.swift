//
//  ViewController.swift
//  Tiempo
//
//  Created by Adam Zemmoura on 21/11/2018.
//  Copyright © 2018 Adam Zemmoura. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    private var startOfCurrentMonth : Date = {
        return Date().firstOfMonth()
    }()
    
    private var numberOfDaysInMonth : Int {
        get {
            let dayRangeForMonth = Calendar.current.range(of: .day, in: .month, for: startOfCurrentMonth)!
            return dayRangeForMonth.upperBound - 1
        }
    }
    
    private var firstWeekdayInMonth : Int {
        get {
            return startOfCurrentMonth.weekday
        }
    }
    
    private var today : Date {
        get {
            return Date()
        }
    }
    
    private var daysInMonthCollectionViewData : [Date?] {
        get {
            var data : [Date?] = []
            for _ in 1..<firstWeekdayInMonth {
                data.append(nil)
            }
            for dayIncrement in 0..<numberOfDaysInMonth {
                let date : Date = dayIncrement == 0 ? startOfCurrentMonth : Calendar.current.date(byAdding: .day, value: dayIncrement, to: startOfCurrentMonth)!
                data.append(date)
            }
            return data
        }
    }
    
    private var weatherDataForNextSevenDays : [Date : WeatherDataForDay] = [:] {
        didSet {
            updateUI()
        }
    }

    private let weatherData : WeatherDataServiceProtocol = DarkSkyWeatherAPIClient.shared
    
    private var calendarOrWeatherDetailView: CalendarOrWeatherDetailView = {
        return UINib(nibName: "CalendarOrWeatherDetailView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first! as! CalendarOrWeatherDetailView
    }()
    
    
    // MARK:- IBOutlets
    
    // Month Selection View
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self 
            collectionView.allowsMultipleSelection = false
            collectionView.register(UINib(nibName: "DateCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "dateCell")
        }
    }
    
    
    @IBOutlet weak var weatherOrCalendarScrollview: UIScrollView! {
        didSet {
            weatherOrCalendarScrollview.showsHorizontalScrollIndicator = false
            weatherOrCalendarScrollview.isScrollEnabled = true
            weatherOrCalendarScrollview.isPagingEnabled = true
            weatherOrCalendarScrollview.delegate = self
        }
    }
    
    @IBOutlet weak var weatherOrCalendarPageControlView: UIPageControl!
    

    // MARK:- IBActions
    @IBAction func rightButtonDidPress() {
        adjustMonthBy(value: 1)
    }
    
    @IBAction func leftButtonDidPress() {
        adjustMonthBy(value: -1)
    }
    
    private func adjustMonthBy(value: Int) {
        
        let newMonth = Calendar.current.date(byAdding: .month, value: value, to: startOfCurrentMonth)!
        startOfCurrentMonth = newMonth
        
        monthYearLabel.text = startOfCurrentMonth.stringWith(format: "MMMM yyyy")
        
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Day from current month : ", Calendar.current.component(.day, from: startOfCurrentMonth))
        print("Month from current month : ", Calendar.current.component(.month, from: startOfCurrentMonth))
        print("Year from current month : ", Calendar.current.component(.year, from: startOfCurrentMonth))
        print("Weekday from current month : ", Calendar.current.component(.weekday, from: startOfCurrentMonth))
        
        print("Current month : ", startOfCurrentMonth)
        print("Number of days in month : ", numberOfDaysInMonth)
        print("First weekday of month : ", firstWeekdayInMonth)
        
        getWeatherDataForNextWeek()
        updateUI()
    }
    
    private func updateUI() {
        monthYearLabel.text = startOfCurrentMonth.stringWith(format: "MMMM yyyy")
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupScrollView()
    }
    
    private func setupScrollView() {
        
        let contentSize = CGSize(width: weatherOrCalendarScrollview.frame.width * 2.0,
                                 height: weatherOrCalendarScrollview.frame.height)
        weatherOrCalendarScrollview.contentSize = contentSize
        weatherOrCalendarScrollview.addSubview(self.calendarOrWeatherDetailView)
        calendarOrWeatherDetailView.frame = CGRect(origin: .zero, size: contentSize)
        
        // set up correct number of segements on pageControlView
        weatherOrCalendarPageControlView.numberOfPages = 2
        
    }
    
    
    private func getWeatherDataForNextWeek() {
        // code to test the DarkSkyWeatherAPI module -- set to Barcelona 
        DarkSkyWeatherAPIClient.shared.getWeeklyForecastForLocation(lat: 41.3851, long: 2.1734) { (weatherDataForWeek) in
            
            // make sure we're on the main thread for UI updates
            DispatchQueue.main.async {
                let week = weatherDataForWeek.data
                
                for day in week {
                    let timeIntervalSince1970 = day.time
                    let key = Date(timeIntervalSince1970: timeIntervalSince1970).startOfDay()
                    
                    print("key in dict : ", key)
                    
                    self.weatherDataForNextSevenDays[key] = day
                    
                    if let iconDesc = day.icon {
                        if let icon = WeatherIcon(rawValue: iconDesc)?.image {
                            print(icon)
                        }
                    }
                }
                
                // get the weekly weather summary text if there is any
//                if let weeklyWeatherSummary = weatherDataForWeek.summary {
//                    self.weatherForecastInfoLabel.text = weeklyWeatherSummary
//                }
            }
            
        }
    }

    
}

extension CalendarViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // the number of days in the month + the number of weekdays to the first day in the month
        let numberOfWeekDaysBeforeFirstDayOfMonth = firstWeekdayInMonth - 1
        
        //return numberOfDaysInMonth[startOfCurrentMonth.rawValue - 1] + (firstWeekdayOfMonth - 1)
        return numberOfDaysInMonth + numberOfWeekDaysBeforeFirstDayOfMonth
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell

        if indexPath.item <= firstWeekdayInMonth - 2 {
            cell.isHidden = true
        }
        else {
            
            // check whether there is a date in the collection view data (there always should be)
            let date = daysInMonthCollectionViewData[indexPath.row]!
            cell.isHidden = false
            
            // check whether there is an entry in the weatherDataForNextSevenDays ie. there is some weather forecast data and if so pass it to the cell
            if let weatherForecastData = weatherDataForNextSevenDays[date] {
                cell.configureForDate(date: date, weatherData: weatherForecastData)
            }
            else {
                cell.configureForDate(date: date)
            }
            
        }

        return cell
    }
}

extension CalendarViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // use the indexPath.row to look up the CollectionViewCellData array for the corresponding date
        guard let selectedDate = daysInMonthCollectionViewData[indexPath.row] else { return }
        
        // check for weather data associated with the date
        if let weatherData = weatherDataForNextSevenDays[selectedDate] {
            calendarOrWeatherDetailView.configureWithWeatherData(weatherData: weatherData)
        }
        else {
            calendarOrWeatherDetailView.configureWithoutWeatherData()
        }
    }
    
}

extension CalendarViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = collectionView.bounds.height / 5
        let width = height
        
        return CGSize(width: width, height: height)
    }
    
}

extension CalendarViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / scrollView.contentSize.width)
        weatherOrCalendarPageControlView.currentPage = Int(currentPage)
    }
    
}

//extension CalendarViewController : MonthSelectionViewDelegate {
    
//    func monthSelectionViewDidChange(month: Month, year: Int) {
//        startOfCurrentMonth = month
//        currentYear = year
//
//        // allow for leap years
//        if month == .feb {
//            if currentYear % 4 == 0 {
//                numberOfDaysInMonth[month.rawValue - 1] = 29
//            } else {
//                numberOfDaysInMonth[month.rawValue - 1] = 28
//            }
//        }
//
//        firstWeekdayOfMonth = getFirstWeekdayOfMonth()
//        collectionView.reloadData()
//    }
//}
