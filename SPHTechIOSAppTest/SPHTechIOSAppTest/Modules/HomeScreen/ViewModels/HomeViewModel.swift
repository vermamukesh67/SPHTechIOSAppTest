//
//  HomeViewModel.swift
//  SPHTechIOSAppTest
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import Foundation

class HomeViewModel
{
    /// Data source for the home page table view.
    var numberOfRecordsToLoadAtOneTime : Int = 50
    var nextApiUrl : String?
    var strResourceId : String? = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
    var diccMobileDataConsumtion : [String : [Records]] = [String : [Records]]()
    var arrSortedYears : [String] = [String]()

    // MARK: Events
    var updateUI: ()->() = { }
    
    init() {
        if let str = strResourceId
        {
            nextApiUrl = "/api/action/datastore_search?resource_id=\(str)&limit=\(numberOfRecordsToLoadAtOneTime)&offset=14"
        }
    }
    
    /// Method call to inform the view model to refresh the data.
    func deleteAllDataAndRefreshScreen() {
        diccMobileDataConsumtion.removeAll()
        self.getMobileDataConsumptionFromNetwork(completionHandler: { [weak self] in
            self?.sortDataBasedOnYears()
            self?.updateUI()
        })
    }
    
    // Method to load more data from server
    func loadMoreData() {
        
        if self.nextApiUrl != nil
        {
            self.getMobileDataConsumptionFromNetwork(completionHandler: { [weak self] in
                
                self?.sortDataBasedOnYears()
                self?.updateUI()
            })
        }
    }
    
    // Condition to check load more data
    func shouldLoadMoreData() -> Bool {
        return ( nextApiUrl != nil )
    }
    
    // get record based on section and row
    func getRecordBasedOnSection(section : Int, row : Int) -> Records?
    {
        let array : [Records] = diccMobileDataConsumtion[arrSortedYears[section]] ?? [Records]()
        
        return (array.count > row) ? array[row] : nil
    }
    
    // get total consumption for a year
    
    func getTotalConsumtionForSectionForYear(strYear : String) -> String
    {
        let array : [Records] = diccMobileDataConsumtion[strYear] ?? [Records]()
        
        var totalC : Float = 0
        
        for (_, objRecord) in array.enumerated()
        {
            if let volume = objRecord.volume_of_mobile_data
            {
                totalC += Float(volume) ?? 0
            }
        }
        return String(totalC)
    }
    // get section wise rows count
    func getNumberOfRowsForForSection(section : Int) -> Int
        
    {
        if diccMobileDataConsumtion.count > 0, arrSortedYears.count > 0
        {
            let array : [Records] = diccMobileDataConsumtion[arrSortedYears[section]] ?? [Records]()
            return array.count
        }
        
        return 0
    }
    
    // compare the consumtion data , return true if record1 is greater than record2
    
    func isFirstRecordIsGreaterThanSecondRecord(record1 : Records, record2 : Records) -> Bool
    {
        var isTrue = false
        
        if let cons1 = record1.volume_of_mobile_data , let cons2 = record2.volume_of_mobile_data
        {
            let c1 = Float(cons1) ?? 0
            let c2 = Float(cons2) ?? 0
            
            if c1 > c2
            {
                isTrue = true
            }
        }
        return isTrue
    }
    
    /// Prepare the tableDataSource
    func sortDataBasedOnYears()
    {
        let arrYears : [String] = Array(diccMobileDataConsumtion.keys)
        arrSortedYears = arrYears.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
    }
    
    func prepareDicAsPerYearWise(objRecord : Records)
    {
        if let strQuarter = objRecord.quarter
        {
            let year = strQuarter.components(separatedBy: "-")
            if year.count > 0
            {
                let strYear = year[0]
                
                if self.diccMobileDataConsumtion[strYear] != nil
                {
                    var arrayData : [Records] = self.diccMobileDataConsumtion[strYear] ?? [Records]()
                    arrayData.append(objRecord)
                    self.diccMobileDataConsumtion.updateValue(arrayData, forKey: strYear)
                }
                else
                {
                    var arrayData : [Records] = [Records]()
                    arrayData.append(objRecord)
                    self.diccMobileDataConsumtion.updateValue(arrayData, forKey: strYear)
                }
            }
        }
        
    }
    
    // Get Mobile Data usage from api
    func getMobileDataConsumptionFromNetwork(completionHandler: @escaping ()->()) {
        
        if let nexturl = self.nextApiUrl
        {
            MobileDataApiHandler().getMobileDataUsed(url: nexturl) { (objMobileDataUsage, error) in
                
                if let objMobileData = objMobileDataUsage?.result?.records , objMobileData.count > 0
                {
                    
                    for (_ , objRecord) in objMobileData.enumerated()
                    {
                        self.prepareDicAsPerYearWise(objRecord: objRecord)
                    }
                    
                    self.nextApiUrl = objMobileDataUsage?.result?._links?.next
                }
                else
                {
                    self.nextApiUrl = nil
                }
                
                completionHandler()
            }
        }
        else
        {
            completionHandler()
        }
    }
    
}


