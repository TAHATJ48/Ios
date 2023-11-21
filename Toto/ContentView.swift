import SwiftUI
import PhotosUI

struct RecipeRow: View {
    let recipe: String
    let imageData: Data?
    let isFavorite: Binding<Bool>
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recipe)
                if let imageData = imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
            Spacer()
            Button(action: {
                isFavorite.wrappedValue.toggle()
            }) {
                Image(systemName: isFavorite.wrappedValue ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite.wrappedValue ? .red : .gray)
            }
        }
    }
}

struct ContentView: View {
    @State private var recipes: [(String, Data?)] = [] // Change the type to hold both recipe details and image data
    @State private var favorites: [(String, Data?)] = [] // Favorite list
    @State private var name: String = ""
    @State private var difficulty: Int = 3
    @State private var date = Date()
    @State var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    @State private var url = URL(string: "https://avatars.githubusercontent.com/u/53621588?s=400&u=1144aec8339d83995c3ae593119287106e029fe9&v=4")

    // Add a state variable to control the sheet presentation
    @State private var isSheetPresented: Bool = false

    var body: some View {
        NavigationView {
            TabView {
                // Home Tab
                VStack {
                    // Button to show the sheet
                    Button("Let's Cook") {
                        isSheetPresented.toggle()
                    }
                    .padding()
                    .sheet(isPresented: $isSheetPresented) {
                        // Content of the sheet
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
                
                // Favorites Tab
                VStack {
                    List {
                        ForEach(favorites.indices, id: \.self) { index in
                            let (recipe, imageData) = favorites[index]
                            let isFavorite = Binding(
                                get: { true },
                                set: { newValue in
                                    removeFromFavorites(index: index)
                                }
                            )
                            RecipeRow(recipe: recipe, imageData: imageData, isFavorite: isFavorite)
                        }
                        .onDelete { indexSet in
                            favorites.remove(atOffsets: indexSet)
                        }
                    }
                    .padding()
                }
                .padding()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            }
        }
    }

    func addRecipe() {
        let newRecipe = "\(name), Difficulty: \(difficulty), Date: \(date)"
        recipes.append((newRecipe, selectedImageData))

        // Optionally, you can clear the form fields after adding a recipe
        name = ""
        difficulty = 3
        selectedImageData = nil
        // You can choose whether to reset the date to the current date or keep the selected date
        // date = Date()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
