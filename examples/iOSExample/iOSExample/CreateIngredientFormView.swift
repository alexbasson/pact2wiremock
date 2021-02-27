import SwiftUI

struct CreateIngredientFormView: View {
    @EnvironmentObject var viewModel: IngredientsViewModel
    @State private var name: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Create new ingredient")
                .bold()
                .font(Font.system(size: 24))
                .padding(.bottom, 8)
            TextField(
                "name",
                text: $name
            )
            .font(Font.system(size: 18.0))
            .padding(.bottom, 8)

            HStack {
                Button(action: handleSubmit) {
                    Text("Submit").bold()
                }
                .primaryButton()
            }

            if viewModel.successfullyCreatedIngredient {
                Text("Successfully created ingredient")
                    .foregroundColor(.green)
            }

            Spacer()
        }
        .padding(.horizontal, 8)

    }

    private func handleSubmit() {
        viewModel.createIngredient(withName: name)
    }
}

struct CreateIngredientFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreateIngredientFormView()
            .environmentObject(IngredientsViewModel())
    }
}
