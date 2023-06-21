//
//  SkapaInputFieldUITests.swift
//  SkapaInputFieldUITests
//
//  Created by Cem on 2023-06-14.
//

import XCTest

final class SkapaInputFieldUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
    }
    
    /// Test if the visibility is toggled correctly for the secure entry version of the InputField.
    func testInputFieldVisibilityButton() {
        let visibilityButton = app.buttons["visibilityButton"]
        let usernameTextfield = app.textFields["username"]
        let passwordSecureTextfield = app.secureTextFields["password"]
        let passwordTextfield = app.textFields["visiblePassword"]
        
        XCTAssertTrue(visibilityButton.exists)
        XCTAssertTrue(usernameTextfield.exists)
        XCTAssertTrue(passwordSecureTextfield.exists)
        XCTAssertFalse(passwordTextfield.exists)
        
        
        visibilityButton.tap()
        
        XCTAssertTrue(passwordTextfield.exists)
        XCTAssertFalse(passwordSecureTextfield.exists)
        
        XCTAssertFalse(app.secureTextFields.count == 1)
        XCTAssertFalse(app.textFields.count == 1)
        
        XCTAssertTrue(app.secureTextFields.count == 0)
        XCTAssertTrue(app.textFields.count == 2)
        
        
    }
    
    /// Test if the character counter shows the correct information and disappears if the limit is equal to or greater than the requirement.
    func testInputFieldCharacterCount() {
        let passwordSecureField = app.secureTextFields["password"]
        let counter = app.staticTexts["counter"]
        
        passwordSecureField.tap()
        passwordSecureField.typeText("1234567")
        XCTAssertTrue(counter.exists)
        XCTAssertEqual("7/8", counter.label)
        
        passwordSecureField.typeText("89")
        
        XCTAssertFalse(counter.exists)
    }
    
    /// Test if the prompt is successfully set depending on the scenario. The test goes through all of the states.
    func testPromptMessageStates() {
        let passwordSecureTextField = app.secureTextFields["password"]
        let hintStaticText = app.staticTexts["Only numeric input allowed"]
        let successStaticText = app.staticTexts["Success"]
        let errorStaticText = app.staticTexts["Please only enter up to 8 characters"]
        
        XCTAssertTrue(hintStaticText.exists)
        XCTAssertEqual(hintStaticText.label, "Only numeric input allowed")
        XCTAssertFalse(successStaticText.exists)
        XCTAssertFalse(errorStaticText.exists)
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("12345678")
        
        XCTAssertFalse(hintStaticText.exists)
        XCTAssertTrue(successStaticText.exists)
        XCTAssertEqual(successStaticText.label, "Success")
        XCTAssertFalse(errorStaticText.exists)
        
        passwordSecureTextField.typeText("123456789")
        
        XCTAssertFalse(hintStaticText.exists)
        XCTAssertFalse(successStaticText.exists)
        XCTAssertTrue(errorStaticText.exists)
        XCTAssertEqual(errorStaticText.label, "Please only enter up to 8 characters")
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
