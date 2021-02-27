import XCTest
@testable import iOSExample
import PactConsumerSwift

class HttpIngredientServiceClientTest: XCTestCase {
    var mockIngredientService: MockService!
    var ingredientServiceClient: HttpIngredientServiceClient!

    override func setUp() {
        super.setUp()

        self.mockIngredientService = MockService(provider: "ingredient-service", consumer: "ingredient-ios")
        self.ingredientServiceClient = HttpIngredientServiceClient(baseUrl: mockIngredientService.baseUrl)
    }

    func test_ItFetchesIngredients() {
        self.mockIngredientService
            .given("a list of ingredients exists")
            .uponReceiving("a request for the list of ingredients")
            .withRequest(
                method: .GET,
                path: "/ingredients",
                headers: [
                    "Accept": "application/json"
                ]
            )
            .willRespondWith(
                status: 200,
                headers: [
                    "Content-Type": "application/json"
                ],
                body: Matcher.eachLike([
                    "id": UUID().uuidString,
                    "name": "Butter"
                ])
            )

        self.mockIngredientService.run { (testComplete) -> Void in
            self.ingredientServiceClient.fetchIngredients { (result) in
                switch result {
                case .success(let ingredients): do {
                    XCTAssertTrue(ingredients.count > 0)
                    XCTAssertEqual(ingredients[0].name, "Butter")
                }
                default: XCTFail("expected call to fetch ingredients to succeed")
                }
                testComplete()
            }
        }
    }

    func test_ItCreatesANewIngredient() {
        self.mockIngredientService
            .uponReceiving("a request to create a new ingredient")
            .withRequest(
                method: .POST,
                path: "/ingredients",
                headers: [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ],
                body: Matcher.somethingLike([
                    "name": "Cheese"
                ])
            )
            .willRespondWith(
                status: 200,
                headers: [
                    "Content-Type": "application/json"
                ],
                body: Matcher.somethingLike([
                    "id": UUID().uuidString,
                    "name": "Cheese"
                ])
            )

        self.mockIngredientService.run { (testComplete) -> Void in
            self.ingredientServiceClient.createIngredient(withName: "Cheese") { (result) in
                switch result {
                case .success(let ingredient): do {
                    XCTAssertEqual(ingredient.name, "Cheese")
                }
                default: XCTFail("expected call to create ingredient to succeed")
                }
                testComplete()
            }
        }
    }
}
