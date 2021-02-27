import Foundation

struct Ingredient: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
}
