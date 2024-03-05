//
//  grocery_delivery_app_final_year_project_UITestsLaunchTests.swift
//  grocery delivery app(final year project)UITests
//
//  Created by Ope Omiwade on 15/11/2022.
//

import XCTest

final class grocery_delivery_app_final_year_project_UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
