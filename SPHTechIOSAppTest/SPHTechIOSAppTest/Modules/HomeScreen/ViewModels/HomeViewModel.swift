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
    var numberOfRecordsToLoadAtOneTime : Int = 10
    var nextPageUrl : String?
    var strResourceId : String? = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
    var diccMobileDataConsumtion : [String : [Records]] = [String : [Records]]()
    var arrSortedYears : [String] = [String]()
    
    // MARK: Input
    var viewDidLoad: ()->() = {}
    
    // MARK: Events
    var reloadTable: ()->() = { }
    
    init() {
        if let str = strResourceId
        {
            nextPageUrl = "/api/action/datastore_search?resource_id=\(str)&limit=\(numberOfRecordsToLoadAtOneTime)&offset=14"
        }
        
        viewDidLoad = { [weak self] in
            self?.getMobileDataConsumptionFromNetwork(completion: {
                
                self?.sortDataBasedOnYears()
                self?.reloadTable()
            })
        }
    }
    
    /// Method call to inform the view model to refresh the data.
    func deleteAllDataAndRefreshScreen() {
        diccMobileDataConsumtion.removeAll()
        self.getMobileDataConsumptionFromNetwork(completion: { [weak self] in
            self?.sortDataBasedOnYears()
            self?.reloadTable()
        })
    }
    
    /// Method call to inform the view model to refresh the data.
    func loadMoreData() {
        
        if self.nextPageUrl != nil
        {
            self.getMobileDataConsumptionFromNetwork(completion: { [weak self] in
                
                self?.sortDataBasedOnYears()
                self?.reloadTable()
            })
        }
    }
    
    // Condition to check load more data
    func shouldLoadMoreData() -> Bool {
        return ( nextPageUrl != nil )
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
        let array : [Records] = diccMobileDataConsumtion[arrSortedYears[section]] ?? [Records]()
        return array.count
    }
    
    // compare the consumtion data , return true if record1 is greater than record2
    
    func iSFirstRecordISGreaterThan(record1 : Records, record2 : Records) -> Bool
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
    
    // Get Mobile Data usage from api
    func getMobileDataConsumptionFromNetwork(completion: @escaping ()->()) {
        
        if let nexturl = self.nextPageUrl
        {
            MobileDataApiHandler().getMobileDataUsed(url: nexturl) { (objMobileDataUsage, error) in
                
                if let objMobileData = objMobileDataUsage?.result?.records , objMobileData.count > 0
                {
                    
                    for (_ , objRecord) in objMobileData.enumerated()
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
                    
                    self.nextPageUrl = objMobileDataUsage?.result?._links?.next
                    
                }
                else
                {
                    self.nextPageUrl = nil
                }
                
                completion()
            }
        }
        else
        {
            completion()
        }
    }
    
}

