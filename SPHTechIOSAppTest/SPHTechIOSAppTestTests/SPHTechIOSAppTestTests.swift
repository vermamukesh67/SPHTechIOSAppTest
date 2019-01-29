//
//  SPHTechIOSAppTestTests.swift
//  SPHTechIOSAppTestTests
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import XCTest
@testable import SPHTechIOSAppTest

class SPHTechIOSAppTestTests: XCTestCase {
    
    var objViewModel : HomeViewModel! = HomeViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        objViewModel.loadMoreData()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        objViewModel = nil
    }
    
    // Test View model functions + attribute values
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let objExpectation : XCTestExpectation = expectation(description: "view model business logic test")
        
        self.objViewModel.updateUI =
            { [weak self] in
            XCTAssertGreaterThan(self?.objViewModel.diccMobileDataConsumtion.count ?? 0, 0)
                XCTAssertEqual(4, self?.objViewModel.getNumberOfRowsForForSection(section: 0))
                XCTAssertTrue(self?.objViewModel.shouldLoadMoreData() ?? true)
               
                let obj1 : Records!  = self?.objViewModel.getRecordBasedOnSection(section: 0, row: 1)!
                let obj2 : Records! = self?.objViewModel.getRecordBasedOnSection(section: 0, row: 0)!
                XCTAssertTrue(self?.objViewModel.isFirstRecordIsGreaterThanSecondRecord(record1: obj1, record2: obj2) ?? true)
                objExpectation.fulfill()
        }
    
        // put timeout as per your expectation
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("error occured : \(error.localizedDescription)")
            }
        }
    }
    
    func testApiResponse() {
        
        let URL = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=14&offset=14"
        
        let objExpectation : XCTestExpectation = expectation(description: "GET \(URL)")
        
        WebApiManager.sharedService.requestAPI(url: URL, parameter: nil, httpMethodType: .GET) { (data, response, error) in
            
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let HTTPResponse = response as? HTTPURLResponse,
                let responseURL = HTTPResponse.url,
                let MIMEType = HTTPResponse.mimeType
            {
                XCTAssertEqual(responseURL.absoluteString, URL, "HTTP response URL should be equal to original URL")
                XCTAssertEqual(HTTPResponse.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(MIMEType, "application/json", "HTTP response content type should be application/json")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            
            objExpectation.fulfill()
            
        }
        // put timeout as per your expectation
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

