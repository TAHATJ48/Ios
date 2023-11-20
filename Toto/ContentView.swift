//
//  ContentView.swift
//  Toto
//
//  Created by TAHIRI JOTEY Taha on 20/11/2023.
//

import SwiftUI
import PhotosUI


struct ContentView: View {
    @State private var recipes: [String] = []
    @State private var name: String = ""
    @State private var difficulty: Int = 3
    @State private var date = Date()
    @State var selectedItem: PhotosPickerItem? = nil

    @State private var url = URL(string: "https://avatars.githubusercontent.com/u/53621588?s=400&u=1144aec8339d83995c3ae593119287106e029fe9&v=4")

    var body: some View {
        VStack {
            Form {
                Section {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                    
                    TextField(
                        "Dish Name",
                        text: $name
                    )
                    .onSubmit {
                        addRecipe()
                    }
                    .disableAutocorrection(true)

                    Text(name)
                        .foregroundColor(.blue)
                    Stepper("Difficulty \(difficulty)", value: $difficulty, in: 1...5)
                    DatePicker(
                        "Start Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                }

                Section {
                    Button("Add Recipe") {
                        addRecipe()
                    }
                    .padding()
                }
            }
            List(recipes, id: \.self) { recipe in
                           Text(recipe)
                       }
                       .padding()
                   }
                   .padding()
               }

    func addRecipe() {
        let newRecipe = "\(name), Difficulty: \(difficulty), Date: \(date)"
        recipes.append(newRecipe)

        // Optionally, you can clear the form fields after adding a recipe
        name = ""
        difficulty = 3
        // You can choose whether to reset the date to the current date or keep the selected date
        // date = Date()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
