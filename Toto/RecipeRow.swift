import SwiftUI

struct RecipeRodw: View {
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
