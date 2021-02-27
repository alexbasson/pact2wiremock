import XCTest

class iOSExampleUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_ListingAndCreatingIngredients() throws {
        let app = XCUIApplication()
        app.launch()

        let fetchIngredientsButton = app.buttons["Fetch ingredients"]
        fetchIngredientsButton.tap()

        let butterIngredient = app.staticTexts["Butter"]
        let cheeseIngredient = app.staticTexts["Cheese"]
        XCTAssert(butterIngredient.waitForExistence(timeout: 5))
        XCTAssertFalse(cheeseIngredient.exists)

        let createIngredientButton = app.buttons["Create new ingredient"]
        createIngredientButton.tap()

        let createIngredientFormNameTextField = app.textFields["name"]
        createIngredientFormNameTextField.tap()
        createIngredientFormNameTextField.typeText("Cheese")

        let submitButton = app.buttons["Submit"]
        submitButton.tap()

        let successMessage = app.staticTexts["Successfully created ingredient"]
        XCTAssert(successMessage.waitForExistence(timeout: 5))

        app.navigationBars.buttons["Back"].tap()
        XCTAssertTrue(butterIngredient.exists)
        XCTAssertTrue(cheeseIngredient.exists)
    }
}
