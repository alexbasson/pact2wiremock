import Foundation

final class IngredientsViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var successfullyCreatedIngredient = false

    let ingredientServiceClient: IngredientServiceClient

    init(ingredientServiceClient: IngredientServiceClient) {
        self.ingredientServiceClient = ingredientServiceClient
    }

    convenience init() {
        self.init(ingredientServiceClient: HttpIngredientServiceClient())
    }

    func fetchIngredients() {
        ingredientServiceClient.fetchIngredients { result in
            switch result {
            case .success(let ingredients):
                self.ingredients = ingredients
            case .failure(let error):
                print(error)
            }
        }
    }

    func createIngredient(withName name: String) {
        self.successfullyCreatedIngredient = false
        ingredientServiceClient.createIngredient(withName: name) { result in
            switch result {
            case .success(let ingredient):
                self.successfullyCreatedIngredient = true
                self.ingredients.append(ingredient)
            case .failure(let error):
                print(error)
            }
        }
    }
}
