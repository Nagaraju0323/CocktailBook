//
//  ContentView.swift
//  CocktailBook
//
//  Created by Nagaraju on 20/12/23.
//

import SwiftUI
import Combine

#Preview {
    HomeView()
}


struct HomeView: View {
    @StateObject private var viewModel = CocktailViewModel()
    @State private var selectedCocktail: CocktailElement?

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 10) {
                    
                    CustomSegmentedPickerView(selectedIndex: $viewModel.selectedSegment)
                 
                    List(filteredCocktails().sorted(by: { $0.name < $1.name }), id: \.id) { cocktail in
                           
                        NavigationLink(
                                    destination: DetailView(cocktail: cocktail),
                                    tag: cocktail,
                                    selection: $selectedCocktail
                                ) {
                                    HStack {
                                        Image(cocktail.name)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(25)
                                        Text(cocktail.name)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                    }
                                    .onTapGesture {
                                        selectedCocktail = cocktail
                                    }
                                }
                                .listRowBackground(Color.clear) // Disable selection effect
                            }
                            .listStyle(.plain)
                    
                    
                }
                .padding()
            }
            .navigationTitle("All Cocktails")
        }
        .onAppear {
            // Fetch data when the view appears
            viewModel.fetchData()
            // this will disable highlighting the cell when is selected
                UITableViewCell.appearance().selectionStyle = .none
                // you can also remove the row separators
                UITableView.appearance().separatorStyle = .none
                
        }
        .onDisappear {
            UITableViewCell.appearance().isSelected = false
        }
    }

    func filteredCocktails() -> [CocktailElement] {
        let selectedType = viewModel.selectedSegment
        if selectedType == 0 {
            // Display all cocktails
            return viewModel.cocktails
        } else {
            // Filter cocktails based on type (Alcoholic or Non-Alcoholic)
            let filteredCocktails = viewModel.cocktails.filter { $0.type.rawValue == (selectedType == 1 ? "alcoholic" : "non-alcoholic") }
            return filteredCocktails
        }
    }
}


//MARK: - CustomSegmentedPickerView
struct CustomSegmentedPickerView: View {

    @Binding var selectedIndex: Int
    private var titles = ["All", "alcoholic", "non-alcoholic"]
    private var colors = [Color.gray, Color.gray, Color.gray]
    init(selectedIndex: Binding<Int>) {
        _selectedIndex = selectedIndex
    }
    @State private var frames = Array<CGRect>(repeating: .zero, count: 3)
    
    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: 10) {
                    ForEach(self.titles.indices, id: \.self) { index in
                        Button(action: { self.selectedIndex = index }) {
                            Text(self.titles[index])
                                .font(.title3)
                                .foregroundColor(self.selectedIndex == index ? .white : .black)
                        }
                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                        .background(
                            GeometryReader { geo in
                                Color.clear.onAppear { self.setFrame(index: index, frame: geo.frame(in: .global))}
                            }
                        )
                    }
                }
                .background(
                    Capsule()
                        .fill(self.colors[self.selectedIndex].opacity(0.4))
                        .frame(width: self.frames[self.selectedIndex].width, height: self.frames[self.selectedIndex].height)
                        .offset(x: self.frames[self.selectedIndex].minX - self.frames[0].minX)
                    , alignment: .leading
                )
            }
            .animation(.default)
            .background(Capsule().stroke(Color.gray, lineWidth: 2))
        }
    }
    
    func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
    }
}
