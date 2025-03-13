import XCTest

class HomeUITests: XCTestCase {

    func testHomeScreenElements() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Welcome"].exists)
        XCTAssertTrue(app.buttons["Start"].exists)
        XCTAssertTrue(app.images["HomeImage"].exists)
    }

    func testStartButtonAction() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Start"].tap()
        XCTAssertTrue(app.staticTexts["NextScreen"].exists)
    }
}