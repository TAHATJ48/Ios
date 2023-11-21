import SwiftUI

struct FavoritesView: View {
    @State private var favorites: [(String, Data?)] = []

    var body: some View {
        VStack {
            List {
                ForEach(favorites.indices, id: \.self) { index in
                    let (recipe, imageData) = favorites[index]
                    let isFavorite = Binding(
                        get: { true },
                        set: { newValue in
                            removeFromFavorites(indexSet: IndexSet([index]))
                        }
                    )
                    RecipeRow(recipe: recipe, imageData: imageData, isFavorite: isFavorite)
                }
                .onDelete { indexSet in
                    removeFromFavorites(indexSet: indexSet)
                }
            }
            .padding()
        }
        .padding()
        .tabItem {
            Label("Favorites", systemImage: "star.fill")
        }
    }

    func removeFromFavorites(indexSet: IndexSet) {
        favorites.remove(atOffsets: indexSet)
    }
}
