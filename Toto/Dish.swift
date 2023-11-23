import SwiftUI

struct RandomDish: View {
    @State private var meal: Meal?

    var body: some View {
        VStack {
            if let meal = meal {
                Text("Meal: \(meal.strMeal)")
                Text("Category: \(meal.strCategory)")
                Text("Area: \(meal.strArea)")
                Text("Instructions: \(meal.strInstructions)")
                // Add more Text views for other details you want to display

                if let imageURL = URL(string: meal.strMealThumb) {
                    // Fetch and display the image
                    AsyncImage(url: imageURL)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
            } else {
                Text("Loading...")
            }

            Button("Fetch Random Meal") {
                fetchRandomMeal()
            }
            .padding()
        }
        .onAppear {
            fetchRandomMeal()
        }
    }

    func fetchRandomMeal() {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MealsResponse.self, from: data)
                    if let firstMeal = result.meals.first {
                        DispatchQueue.main.async {
                            self.meal = firstMeal
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

struct RandomDish_Previews: PreviewProvider {
    static var previews: some View {
        RandomDish()
    }
}

struct MealsResponse: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    // Add more properties for other details you want to display
}
