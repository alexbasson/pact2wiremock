import SwiftUI

struct ContentView: View {
    var body: some View {
        IngredientListView()
            .environmentObject(IngredientsViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
