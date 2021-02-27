import SwiftUI

struct IngredientListView: View {
    @EnvironmentObject var viewModel: IngredientsViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Button(action: fetchIngredientsButtonTapped) {
                    Text("Fetch ingredients")
                        .bold()
                }
                .primaryButton()
                .padding(.bottom, 16)

                Text("Ingredients")
                    .bold()
                    .font(Font.system(size: 24.0))
                    .padding(.bottom, 8)

                Divider()
                ForEach(viewModel.ingredients) { ingredient in
                    Text(ingredient.name)
                    Divider()
                }

                Spacer()

                NavigationLink(destination: CreateIngredientFormView()) {
                    Text("Create new ingredient")
                        .bold()
                }
                .primaryButton()
            }
            .padding(.horizontal, 8)
        }
    }

    private func fetchIngredientsButtonTapped() {
        viewModel.fetchIngredients()
    }
}

struct IngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientListView()
            .environmentObject(IngredientsViewModel())
    }
}
