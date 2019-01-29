//
//  SPHTechIOSAppTestUITests.swift
//  SPHTechIOSAppTestUITests
//
//  Created by Mukesh Verma on 29/01/19.
//  Copyright © 2019 Mukesh Verma. All rights reserved.
//

import XCTest

class SPHTechIOSAppTestUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExpandCollapseButtonClickEvent() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        app.launch()
        // Make sure we're displaying onboarding
        XCTAssertTrue(app.isDisplayingOnboarding)
        
        print(app.buttons)
        
        // Tap the first header expand-collapse button
        app.buttons["btnExpandCollapse1"].tap()
    }

}

extension XCUIApplication {
    var isDisplayingOnboarding: Bool {
        return otherElements["onboardingView"].exists
    }
}
