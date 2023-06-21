//
//  SkapaInputFieldTests.swift
//  SkapaInputFieldTests
//
//  Created by Cem on 2023-06-14.
//

import XCTest
@testable import SkapaInputField

final class SkapaInputFieldTests: XCTestCase {

    var sut: InputFieldViewModel!
    var model: InputFieldModel!
    
    override func setUpWithError() throws {
        model = InputFieldModel(text: "")
        sut = InputFieldViewModel(model: model)
    }

    override func tearDownWithError() throws {
        model = nil
        sut = nil
    }
    
    override func setUp() {
        let model = InputFieldModel(text: "")
        sut = InputFieldViewModel(model: model)
    }

    func test_focus_change() throws {
        sut.adjustStateOnFocusChange(focus: true)
        var actual = sut.model.inputFieldState
        
        XCTAssertEqual(actual, InputFieldStates.selected)
        XCTAssertNotEqual(actual, InputFieldStates.error)
        
        sut.adjustStateOnFocusChange(focus: false)
        actual = sut.model.inputFieldState
        
        XCTAssertEqual(actual, InputFieldStates.unselected)
        XCTAssertNotEqual(actual, InputFieldStates.error)
        
        actual = .error
        sut.adjustStateOnFocusChange(focus: false)
        actual = sut.model.inputFieldState
        
        XCTAssertEqual(actual, InputFieldStates.error)
        XCTAssertNotEqual(actual, InputFieldStates.unselected)
        
        sut.adjustStateOnFocusChange(focus: true)
        XCTAssertEqual(actual, InputFieldStates.error)
        XCTAssertNotEqual(actual, InputFieldStates.unselected)
        
        actual = .selected
        sut.adjustStateOnFocusChange(focus: false)
        XCTAssertEqual(actual, .unselected)
    }
    
    func test_character_count_over_total() {
        var actual = sut.getCharacterCountOverTotal()
        XCTAssertEqual(actual, "")
        XCTAssertNotEqual(actual, "0/10")
        
        sut.model.maxLength = 10
        actual = sut.getCharacterCountOverTotal()
        XCTAssertEqual(actual, "0/10")
        XCTAssertNotEqual(actual, "1/10")
        
        sut.model.text = "1234"
        actual = sut.getCharacterCountOverTotal()
        XCTAssertEqual(actual, "4/10")
        XCTAssertNotEqual(actual, "0/10")
    }
    
    func test_is_character_count_below_limit() {
        var result = sut.isCharacterCountBelowLimit()
    }
    
    func test_prompt_message() {
        sut.model.promptString = "This is a prompt"
        if let input = sut.model.promptString {
            var actual = sut.getPromptMessage(prompt: input)
            XCTAssertEqual(input, actual)
        }
    }
    
    func test_validation() {
        var input = "12345678"
        
        sut.validateString(input)
        var actual = sut.model.inputFieldState
        
        XCTAssertEqual(sut.model.inputFieldState, InputFieldStates.selected)
        XCTAssertNotEqual(actual, InputFieldStates.error)
        XCTAssertNotEqual(actual, InputFieldStates.success)
        
        sut.model.maxLength = 8
        sut.validateString(input)
        actual = sut.model.inputFieldState
        
        XCTAssertNotEqual(actual, InputFieldStates.selected)
        XCTAssertNotEqual(actual, InputFieldStates.error)
        XCTAssertEqual(actual, InputFieldStates.success)

        input = "111A"
        sut.validateString(input)
        actual = sut.model.inputFieldState
        
        XCTAssertNotEqual(actual, InputFieldStates.selected)
        XCTAssertEqual(actual, InputFieldStates.error)
        XCTAssertNotEqual(actual, InputFieldStates.success)
    }
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
