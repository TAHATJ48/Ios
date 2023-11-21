import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var recipes: [(String, Data?)] = []
    @State private var name: String = ""
    @State private var difficulty: Int = 3
    @State private var date = Date()
    @State var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isSheetPresented: Bool = false
    
    // Add the favorites array
    @State private var favorites: [(String, Data?)] = []

    var body: some View {
        VStack {
            Button("Let's Cook") {
                isSheetPresented.toggle()
            }
            .padding()
            .sheet(isPresented: $isSheetPresented) {
                Form {
                                            Section {
                                                PhotosPicker(
                                                    selection: $selectedItem,
                                                    matching: .images,
                                                    photoLibrary: .shared()) {
                                                        Text("Select a photo")
                                                    }
                                                    .onChange(of: selectedItem) { newItem in
                                                        Task {
                                                            // Retrieve selected asset in the form of Data
                                                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                                selectedImageData = data
                                                            }
                                                        }
                                                    }
                                                if let selectedImageData = selectedImageData,
                                                   let uiImage = UIImage(data: selectedImageData) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 250, height: 250)
                                                }
                                                TextField(
                                                    "Dish Name",
                                                    text: $name
                                                )
                                                .onSubmit {
                                                    addRecipe()
                                                }
                                                .disableAutocorrection(true)
                                                Stepper("Difficulty \(difficulty)", value: $difficulty, in: 1...5)
                                                DatePicker(
                                                    "Start Date",
                                                    selection: $date,
                                                    displayedComponents: [.date]
                                                )
                                                Button("Add Recipe") {
                                                    addRecipe()
                                                    isSheetPresented = false
                                                }
                                                .padding()

                                            }
                                        }
                                    }

            List {
                ForEach(recipes.indices, id: \.self) { index in
                    let (recipe, imageData) = recipes[index]
                    let isFavorite = Binding(
                        get: { favorites.contains(where: { $0.0 == recipe }) },
                        set: { newValue in
                            if newValue {
                                addToFavorites(index: index)
                            } else {
                                removeFromFavorites(index: index)
                            }
                        }
                    )
                    RecipeRow(recipe: recipe, imageData: imageData, isFavorite: isFavorite)
                }
                .onDelete { indexSet in
                    recipes.remove(atOffsets: indexSet)
                }
            }
            .padding()
        }
        .padding()
        .tabItem {
            Label("Home", systemImage: "house.fill")
        }
    }

    func addRecipe() {
        let newRecipe = "\(name), Difficulty: \(difficulty), Date: \(date)"
        recipes.append((newRecipe, selectedImageData))

        // Optionally, you can clear the form fields after adding a recipe
        name = ""
        difficulty = 3
        selectedImageData = nil
    }

    func addToFavorites(index: Int) {
        let (recipe, imageData) = recipes[index]
        favorites.append((recipe, imageData))
    }

    func removeFromFavorites(index: Int) {
        let (recipe, _) = favorites[index]
        if let recipeIndex = recipes.firstIndex(where: { $0.0 == recipe }) {
            recipes[recipeIndex].1 = nil
        }
        favorites.remove(at: index)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
