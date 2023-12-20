//
//  DetailView.swift
//  CocktailBook
//
//  Created by Nagaraju on 21/12/23.
//

import SwiftUI

struct DetailView: View {
    let cocktail: CocktailElement
    
    var body: some View {
        GeometryReader { georeader in
        ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "timer")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(cocktail.preparationMinutes) \("minutes")").bold()
                        Spacer()
                    }
                    .padding(.leading,10)
                    
                    Image(cocktail.name)
                        .resizable()
                        .frame(width: georeader.size.width - 20, height: georeader.size.width)
                        .cornerRadius(10)
                        .onTapGesture {
                            print(cocktail.name)
                        }
                    
                    Text(cocktail.shortDescription)
                        .font(.title3)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 10)
                    
                    Text("Ingredients")
                        .font(.headline)
                        .bold()
                        .padding(.leading,10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(cocktail.ingredients, id: \.self) { ingredient in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(ingredient)
                            }
                        }
                    }
                    .padding(.leading)
                }
                .padding(.leading, 10)
                Spacer()
            }
        }
        .navigationTitle(cocktail.name)
    }
}



struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of CocktailElement for the preview
        let previewCocktail = CocktailElement(id: "1", name: "Preview Cocktail", type: .alcoholic, shortDescription: "Preview DescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescription", longDescription: "previewImage",preparationMinutes:5,imageName:"5",ingredients:[])
        // Use the instance in the DetailView preview
        DetailView(cocktail: previewCocktail)
    }
}
