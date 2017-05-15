//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by Peter Vanhoef on 19/03/17.
//  Copyright © 2017 Peter Vanhoef. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        showCalculator()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTask1() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        let buttonDigit1 = app.buttons["1"]
        let buttonDigit2 = app.buttons["2"]
        let buttonDigit3 = app.buttons["3"]
        let buttonDigit4 = app.buttons["4"]
        let buttonDigit5 = app.buttons["5"]
        let buttonDigit6 = app.buttons["6"]
        let buttonDigit7 = app.buttons["7"]
        let buttonDigit8 = app.buttons["8"]
        let buttonDigit9 = app.buttons["9"]
        let buttonDigit0 = app.buttons["0"]
        
        let buttonDecimalPoint = app.buttons["."]

        let buttonPi = app.buttons["π"]
        
        let buttonMultiply = app.buttons["×"]
        let buttonDivide = app.buttons["÷"]
        let buttonAdd = app.buttons["+"]
        let buttonSubtract = app.buttons["−"]
        let buttonCos = app.buttons["cos"]
        let buttonSqrt = app.buttons["√"]

        let buttonEqual = app.buttons["="]
        
        // cos(π) = -1
        buttonPi.tap()
        buttonCos.tap()
        XCTAssert(app.staticTexts["-1"].exists)
        
        // 12 × 4 = 48
        buttonDigit1.tap()
        buttonDigit2.tap()
        buttonMultiply.tap()
        buttonDigit4.tap()
        buttonEqual.tap()
        XCTAssert(app.staticTexts["48"].exists)
        
        // 568 + 78 = 646
        buttonDigit5.tap()
        buttonDigit6.tap()
        buttonDigit8.tap()
        buttonAdd.tap()
        buttonDigit7.tap()
        buttonDigit8.tap()
        buttonEqual.tap()
        XCTAssert(app.staticTexts["646"].exists)

        // 45 ÷ 5 = 9
        buttonDigit4.tap()
        buttonDigit5.tap()
        buttonDivide.tap()
        buttonDigit5.tap()
        buttonEqual.tap()
        XCTAssert(app.staticTexts["9"].exists)
        
        // 23 ± = -23
        buttonDigit2.tap()
        buttonDigit3.tap()
        app.buttons["±"].tap()
        XCTAssert(app.staticTexts["-23"].exists)
        
        // 92736 - 123 = 92613
        buttonDigit9.tap()
        buttonDigit2.tap()
        buttonDigit7.tap()
        buttonDigit3.tap()
        buttonDigit6.tap()
        buttonSubtract.tap()
        buttonDigit1.tap()
        buttonDigit2.tap()
        buttonDigit3.tap()
        buttonEqual.tap()
        XCTAssert(app.staticTexts["92613"].exists)
        
        // 8 × 0.5 = 4
        buttonDigit8.tap()
        buttonMultiply.tap()
        buttonDigit0.tap()
        buttonDecimalPoint.tap()
        buttonDigit5.tap()
        buttonEqual.tap()
        XCTAssert(app.staticTexts["4"].exists)
        
        // √(√(9)) = 3
        buttonDigit8.tap()
        buttonDigit1.tap()
        buttonSqrt.tap()
        XCTAssert(app.staticTexts["9"].exists)
        buttonSqrt.tap()
        XCTAssert(app.staticTexts["3"].exists)
        
    }
    
    func testTask2() {
        let app = XCUIApplication()
        
        let buttonDigit1 = app.buttons["1"]
        let buttonDigit2 = app.buttons["2"]
        let buttonDigit3 = app.buttons["3"]
        let buttonDigit4 = app.buttons["4"]
        let buttonDigit5 = app.buttons["5"]
        let buttonDigit7 = app.buttons["7"]
        let buttonDigit9 = app.buttons["9"]
        
        let buttonDecimalPoint = app.buttons["."]
        
        let buttonAdd = app.buttons["+"]
        let buttonSubtract = app.buttons["−"]
        
        let buttonEqual = app.buttons["="]
        
        // Allow decimal point
        buttonDigit4.tap()
        XCTAssert(app.staticTexts["4"].exists)
        buttonDigit2.tap()
        XCTAssert(app.staticTexts["42"].exists)
        buttonDecimalPoint.tap()
        XCTAssert(app.staticTexts["42."].exists)
        buttonDigit3.tap()
        XCTAssert(app.staticTexts["42.3"].exists)
        buttonDigit9.tap()
        XCTAssert(app.staticTexts["42.39"].exists)
        buttonSubtract.tap()
        XCTAssert(app.staticTexts["42.39"].exists)
        buttonDigit7.tap()
        XCTAssert(app.staticTexts["7"].exists)
        buttonDecimalPoint.tap()
        XCTAssert(app.staticTexts["7."].exists)
        buttonDigit1.tap()
        XCTAssert(app.staticTexts["7.1"].exists)
        buttonDigit5.tap()
        XCTAssert(app.staticTexts["7.15"].exists)
        buttonEqual.tap()
        XCTAssert(app.staticTexts["35.24"].exists)
        
        // And only allow 1 decimal point
        buttonDigit4.tap()
        XCTAssert(app.staticTexts["4"].exists)
        buttonDigit2.tap()
        XCTAssert(app.staticTexts["42"].exists)
        buttonDecimalPoint.tap()
        XCTAssert(app.staticTexts["42."].exists)
        buttonDecimalPoint.tap()
        XCTAssert(app.staticTexts["42."].exists)
        buttonDigit3.tap()
        XCTAssert(app.staticTexts["42.3"].exists)
        buttonDecimalPoint.tap()
        XCTAssert(app.staticTexts["42.3"].exists)
        buttonDigit9.tap()
        XCTAssert(app.staticTexts["42.39"].exists)
        buttonSubtract.tap()
        XCTAssert(app.staticTexts["42.39"].exists)
        buttonDigit7.tap()
        XCTAssert(app.staticTexts["7"].exists)
        buttonDecimalPoint.tap()
        XCTAssert(app.staticTexts["7."].exists)
        buttonDecimalPoint.tap()
        XCTAssert(app.staticTexts["7."].exists)
        buttonDigit1.tap()
        XCTAssert(app.staticTexts["7.1"].exists)
        buttonDecimalPoint.tap()
        XCTAssert(app.staticTexts["7.1"].exists)
        buttonDigit5.tap()
        XCTAssert(app.staticTexts["7.15"].exists)
        buttonEqual.tap()
        XCTAssert(app.staticTexts["35.24"].exists)
        
        // User starts off entering a new number by touching the decimal point
        buttonDecimalPoint.tap()
        XCTAssert(app.staticTexts["0."].exists)
        buttonDigit2.tap()
        XCTAssert(app.staticTexts["0.2"].exists)
        buttonDigit7.tap()
        XCTAssert(app.staticTexts["0.27"].exists)
        buttonAdd.tap()
        buttonDigit3.tap()
        XCTAssert(app.staticTexts["3"].exists)
        buttonEqual.tap()
        XCTAssert(app.staticTexts["3.27"].exists)
    }
    
    func testAdditionalOperationsTask3() {
        let app = XCUIApplication()
        
        app.buttons["0"].tap()
        app.buttons["sin"].tap()
        XCTAssert(app.staticTexts["0"].exists)
        
        app.buttons["0"].tap()
        app.buttons["tan"].tap()
        XCTAssert(app.staticTexts["0"].exists)
        
        app.buttons["1"].tap()
        app.buttons["8"].tap()
        app.buttons["x²"].tap()
        XCTAssert(app.staticTexts["324"].exists)
        
        app.buttons["4"].tap()
        app.buttons["x⁻¹"].tap()
        XCTAssert(app.staticTexts["0.25"].exists)
    }

    func testSequenceTask7() {
        let app = XCUIApplication()

        // a. touching 7 + would show “7 + ...” (with 7 still in the display)
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        XCTAssert(app.staticTexts["7 + …"].exists)
        XCTAssert(app.staticTexts["7"].exists)
        
        // b. 7 + 9 would show “7 + ...” (9 in the display)
        app.buttons["9"].tap()
        XCTAssert(app.staticTexts["7 + …"].exists)
        XCTAssert(app.staticTexts["9"].exists)

        // c. 7 + 9 = would show “7 + 9 =” (16 in the display)
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["7 + 9 ="].exists)
        XCTAssert(app.staticTexts["16"].exists)

        // d. 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
        app.buttons["√"].tap()
        XCTAssert(app.staticTexts["√(7 + 9) ="].exists)
        XCTAssert(app.staticTexts["4"].exists)

        // e. 7 + 9 = √ + 2 = would show “√(7 + 9) + 2 =” (6 in the display)
        app.buttons["+"].tap()
        app.buttons["2"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["√(7 + 9) + 2 ="].exists)
        XCTAssert(app.staticTexts["6"].exists)

        // f. 7 + 9 √ would show “7 + √(9) ...” (3 in the display)
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["√"].tap()
        XCTAssert(app.staticTexts["7 + √(9) …"].exists)
        XCTAssert(app.staticTexts["3"].exists)

        // g. 7 + 9 √ = would show “7 + √(9) =“ (10 in the display)
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["7 + √(9) ="].exists)
        XCTAssert(app.staticTexts["10"].exists)

        // h. 7 + 9 = + 6 = + 3 = would show “7 + 9 + 6 + 3 =” (25 in the display)
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["7 + 9 + 6 + 3 ="].exists)
        XCTAssert(app.staticTexts["25"].exists)

        // i. 7 + 9 = √ 6 + 3 = would show “6 + 3 =” (9 in the display)
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["6 + 3 ="].exists)
        XCTAssert(app.staticTexts["9"].exists)

        // j. 5 + 6 = 7 3 would show “5 + 6 =” (73 in the display)
        app.buttons["5"].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["7"].tap()
        app.buttons["3"].tap()
        XCTAssert(app.staticTexts["5 + 6 ="].exists)
        XCTAssert(app.staticTexts["73"].exists)
        app.buttons["="].tap() // clear display

        // k. 4 × π = would show “4 × π =“ (12.5663706143592 in the display)
        app.buttons["4"].tap()
        app.buttons["×"].tap()
        app.buttons["π"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["4 × π ="].exists)
        XCTAssert(app.staticTexts["12.566371"].exists)
    }
    
    func testClearButtonTask8() {
        let app = XCUIApplication()
        
        // check state
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["0"].exists)
        
        // a. touching 7 + would show “7 + ...” (with 7 still in the display)
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        XCTAssert(app.staticTexts["7 + …"].exists)
        XCTAssert(app.staticTexts["7"].exists)
        
        // b. 7 + 9 would show “7 + ...” (9 in the display)
        app.buttons["9"].tap()
        XCTAssert(app.staticTexts["7 + …"].exists)
        XCTAssert(app.staticTexts["9"].exists)
        
        // c. 7 + 9 = would show “7 + 9 =” (16 in the display)
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["7 + 9 ="].exists)
        XCTAssert(app.staticTexts["16"].exists)
        
        // clear
        app.buttons["C"].tap()
        
        // check state
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["0"].exists)
    }
    
    func testMissingParenthesisBug() {
        let app = XCUIApplication()
        
        app.buttons["4"].tap()
        app.buttons["+"].tap()
        app.buttons["5"].tap()
        app.buttons["="].tap()
        app.buttons["x²"].tap()
        XCTAssert(app.staticTexts["(4 + 5)² ="].exists)
        XCTAssert(app.staticTexts["81"].exists)
    
        app.buttons["1"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        app.buttons["x⁻¹"].tap()
        XCTAssert(app.staticTexts["(1 + 3)⁻¹ ="].exists)
        XCTAssert(app.staticTexts["0.25"].exists)
    }
    
    func testBackSpaceExtraCredit1() {
        let app = XCUIApplication()
        
        XCTAssert(app.staticTexts["0"].exists)
        app.buttons["BS"].tap()
        XCTAssert(app.staticTexts["0"].exists)
        app.buttons["3"].tap()
        XCTAssert(app.staticTexts["3"].exists)
        app.buttons["BS"].tap()
        XCTAssert(app.staticTexts["0"].exists)
        app.buttons["5"].tap()
        app.buttons["3"].tap()
        app.buttons["8"].tap()
        app.buttons["9"].tap()
        XCTAssert(app.staticTexts["5389"].exists)
        app.buttons["BS"].tap()
        XCTAssert(app.staticTexts["538"].exists)
        app.buttons["BS"].tap()
        XCTAssert(app.staticTexts["53"].exists)
        app.buttons["7"].tap()
        app.buttons["6"].tap()
        XCTAssert(app.staticTexts["5376"].exists)
        app.buttons["BS"].tap()
        app.buttons["BS"].tap()
        app.buttons["BS"].tap()
        XCTAssert(app.staticTexts["5"].exists)
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["5 + 3 ="].exists)
        XCTAssert(app.staticTexts["8"].exists)
    }
    
    func testNumberFormatterExtraCredit2() {
        let app = XCUIApplication()

        app.buttons["4"].tap()
        app.buttons["×"].tap()
        app.buttons["π"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["4 × π ="].exists)
        XCTAssert(app.staticTexts["12.566371"].exists)

        app.buttons["4"].tap()
        app.buttons["."].tap()
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["3"].tap()
        app.buttons["4"].tap()
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        app.buttons["7"].tap()
        app.buttons["8"].tap()
        app.buttons["9"].tap()
        app.buttons["+"].tap()
        XCTAssert(app.staticTexts["4.123457 + …"].exists)
        app.buttons["1"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["4.123457 + 1 ="].exists)
        XCTAssert(app.staticTexts["5.123457"].exists)
    }
    
    func testRandExtraCredit3() {
        let app = XCUIApplication()

        app.buttons["Rand"].tap()
        app.buttons["+"].tap()
        app.buttons["4"].tap()
        app.buttons["="].tap()
        XCTAssertFalse(app.staticTexts["4 ="].exists)
        XCTAssertFalse(app.staticTexts["4"].exists)
    }
    
    func testVariableAssignment2Task7() {
        let app = XCUIApplication()

        // 9 + M = √ ⇒ description is √(9+M), display is 3 because M is not set (thus 0.0)
        app.buttons["9"].tap()
        app.buttons["+"].tap()
        app.buttons["M"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
        XCTAssert(app.staticTexts["√(9 + M) ="].exists)
        XCTAssert(app.staticTexts["3"].exists)
        
        // 7 →M ⇒ display now shows 4 (the square root of 16), description is still √(9+M)
        app.buttons["7"].tap()
        app.buttons["→M"].tap()
        XCTAssert(app.staticTexts["√(9 + M) ="].exists)
        XCTAssert(app.staticTexts["4"].exists)
        
        // + 14 = ⇒ display now shows 18, description is now √(9+M)+14
        app.buttons["+"].tap()
        app.buttons["1"].tap()
        app.buttons["4"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["√(9 + M) + 14 ="].exists)
        XCTAssert(app.staticTexts["18"].exists)
    }
    
    func testValueMAssignment2Task8() {
        let app = XCUIApplication()
        
        // 9 + M = √ ⇒ description is √(9+M), display is 3 because M is not set (thus 0.0)
        app.buttons["9"].tap()
        app.buttons["+"].tap()
        app.buttons["M"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
        XCTAssert(app.staticTexts["√(9 + M) ="].exists)
        XCTAssert(app.staticTexts["3"].exists)
        XCTAssert(app.staticTexts[" "].exists)
        
        // 7 →M ⇒ display now shows 4 (the square root of 16), description is still √(9+M)
        app.buttons["7"].tap()
        app.buttons["→M"].tap()
        XCTAssert(app.staticTexts["√(9 + M) ="].exists)
        XCTAssert(app.staticTexts["4"].exists)
        XCTAssert(app.staticTexts["7"].exists)
        
        // + 14 = ⇒ display now shows 18, description is now √(9+M)+14
        app.buttons["+"].tap()
        app.buttons["1"].tap()
        app.buttons["4"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["√(9 + M) + 14 ="].exists)
        XCTAssert(app.staticTexts["18"].exists)
        XCTAssert(app.staticTexts["7"].exists)
        
        // 16 →M ⇒ display now shows 19, description is still √(9+M)+14
        app.buttons["1"].tap()
        app.buttons["6"].tap()
        app.buttons["→M"].tap()
        XCTAssert(app.staticTexts["√(9 + M) + 14 ="].exists)
        XCTAssert(app.staticTexts["19"].exists)
        XCTAssert(app.staticTexts["16"].exists)

        // clear
        app.buttons["C"].tap()
        
        // check state
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["0"].exists)
    }
    
    func testClearButtonAssignment2Task9() {
        let app = XCUIApplication()
        
        // check state
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["0"].exists)
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        XCTAssert(app.staticTexts["7 + …"].exists)
        XCTAssert(app.staticTexts["7"].exists)
        XCTAssert(app.staticTexts[" "].exists)
        
        app.buttons["M"].tap()
        XCTAssert(app.staticTexts["7 + M …"].exists)
        XCTAssert(app.staticTexts["0"].exists)
        XCTAssert(app.staticTexts[" "].exists)
        
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["7 + M ="].exists)
        XCTAssert(app.staticTexts["7"].exists)
        XCTAssert(app.staticTexts[" "].exists)
        
        app.buttons["5"].tap()
        app.buttons["3"].tap()
        app.buttons["→M"].tap()
        XCTAssert(app.staticTexts["7 + M ="].exists)
        XCTAssert(app.staticTexts["60"].exists)
        XCTAssert(app.staticTexts["53"].exists)

        // clear
        app.buttons["C"].tap()
        
        // check state
        XCTAssert(app.staticTexts[" "].exists)
        XCTAssert(app.staticTexts["0"].exists)
        XCTAssertFalse(app.staticTexts["53"].exists)
    }
    
    func testUndoButtonAssignment2Task10() {
        let app = XCUIApplication()
        
        // For example, enter M cos,
        app.buttons["M"].tap()
        app.buttons["cos"].tap()
        XCTAssert(app.staticTexts["cos(M) ="].exists)
        XCTAssert(app.staticTexts["1"].exists)
        XCTAssert(app.staticTexts[" "].exists)
        
        // then π, then →M,
        app.buttons["π"].tap()
        app.buttons["→M"].tap()
        XCTAssert(app.staticTexts["π ="].exists)
        XCTAssert(app.staticTexts["3.141593"].exists)
        
        // then undo (to get rid of the π) ...
        app.buttons["BS"].tap()
        
        // now your calculator will show the value of cos(M) which should be -1
        XCTAssert(app.staticTexts["cos(M) ="].exists)
        XCTAssert(app.staticTexts["-1"].exists)
        XCTAssert(app.staticTexts["3.141593"].exists)
    }
    
    func testErrorReportingAssignment2ExtraCredit1() {
        let app = XCUIApplication()

        // Division by zero
        app.buttons["3"].tap()
        app.buttons["÷"].tap()
        app.buttons["0"].tap()
        app.buttons["="].tap()
        XCTAssert(app.staticTexts["3 ÷ 0 ="].exists)
        XCTAssert(app.staticTexts["Division by zero"].exists)
        XCTAssert(app.staticTexts[" "].exists)
        
        // Sqrt of negative number
        app.buttons["9"].tap()
        app.buttons["±"].tap()
        app.buttons["√"].tap()
        XCTAssert(app.staticTexts["√(-9) ="].exists)
        XCTAssert(app.staticTexts["Sqrt of negative number"].exists)
        XCTAssert(app.staticTexts[" "].exists)
    }
    
    func testLeadingZeroAfterClearBug() {
        let app = XCUIApplication()
        
        app.buttons["7"].tap()
        app.buttons["3"].tap()
        app.buttons["2"].tap()
        app.buttons["1"].tap()
        app.buttons["C"].tap()
        app.buttons["3"].tap()
        app.buttons["9"].tap()
        XCTAssertFalse(app.staticTexts["039"].exists)
        XCTAssertTrue(app.staticTexts["39"].exists)
    }
    
    func showCalculator(navBarTitle: String = "Calculator.GraphingView") {
        // Don't know if this is the best way to make the calculator visible ...
        if XCUIApplication().buttons["Graph"].exists {
            if !XCUIApplication().buttons["Graph"].isHittable {
                XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.swipeRight()
            }
        } else {
            if XCUIApplication().navigationBars[navBarTitle].exists {
                if XCUIApplication().navigationBars[navBarTitle].buttons["Calculator"].exists {
                    XCUIApplication().navigationBars[navBarTitle].buttons["Calculator"].tap()
                }
            } else {
                if !XCUIApplication().navigationBars.element.isHittable {
                    XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.swipeRight()
                }
            }
        }
    }
    
    func testGraphButtonAssignment3Task7() {
        let app = XCUIApplication()

        app.buttons["M"].tap()
        app.buttons["cos"].tap()
        app.buttons["Graph"].tap()
        showCalculator(navBarTitle: "cos(M)")
        XCTAssert(app.staticTexts["cos(M) ="].exists)
        XCTAssert(app.staticTexts["1"].exists)
        XCTAssert(app.staticTexts[" "].exists)
       
        app.buttons["M"].tap()
        app.buttons["√"].tap()
        app.buttons["Graph"].tap()
        showCalculator(navBarTitle: "√(M)")
        XCTAssert(app.staticTexts["√(M) ="].exists)
        XCTAssert(app.staticTexts["0"].exists)
        XCTAssert(app.staticTexts[" "].exists)
        
        // verify stored value is not overwritten by drawing a graph
        app.buttons["9"].tap()
        app.buttons["→M"].tap()
        XCTAssert(app.staticTexts["√(M) ="].exists)
        XCTAssert(app.staticTexts["3"].exists)
        XCTAssert(app.staticTexts["9"].exists)
        app.buttons["Graph"].tap()
        showCalculator(navBarTitle: "√(M)")
        XCTAssert(app.staticTexts["√(M) ="].exists)
        XCTAssert(app.staticTexts["3"].exists)
        XCTAssert(app.staticTexts["9"].exists)

        app.buttons["M"].tap()
        app.buttons["tan"].tap()
        app.buttons["Graph"].tap()
        showCalculator(navBarTitle: "tan(M)")
        XCTAssert(app.staticTexts["tan(M) ="].exists)
        XCTAssert(app.staticTexts["-0.452316"].exists)
        XCTAssert(app.staticTexts["9"].exists)
    }

    func testGraphTitleAssignment3Task8() {
        let app = XCUIApplication()
        
        app.buttons["M"].tap()
        app.buttons["cos"].tap()
        app.buttons["Graph"].tap()
        XCTAssert(app.staticTexts["cos(M)"].exists)
        showCalculator(navBarTitle: "cos(M)")
        XCTAssert(app.staticTexts["cos(M) ="].exists)
        XCTAssert(app.staticTexts["1"].exists)
        XCTAssert(app.staticTexts[" "].exists)
        
        app.buttons["M"].tap()
        app.buttons["√"].tap()
        app.buttons["Graph"].tap()
        XCTAssert(app.staticTexts["√(M)"].exists)
        showCalculator(navBarTitle: "√(M)")
        XCTAssert(app.staticTexts["√(M) ="].exists)
        XCTAssert(app.staticTexts["0"].exists)
        XCTAssert(app.staticTexts[" "].exists)
    }
}
