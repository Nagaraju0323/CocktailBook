//
//  CocktailViewModel.swift
//  CocktailBook
//
//  Created by Nagaraju on 20/12/23.
//

import Foundation
import Combine

class CocktailViewModel: ObservableObject {
    private let dataFetcher: DataFetcherAdapter
    
    @Published var cocktails: [CocktailElement] = []
    @Published var selectedSegment: Int = 0

    private var cancellables: Set<AnyCancellable> = []

    init(dataFetcher: DataFetcherAdapter = DataFetcherAdapter(networkManager: NetworkManager.shared)) {
        self.dataFetcher = dataFetcher
    }
    
    func fetchData() {
        dataFetcher.fetchData()
            .sink(receiveCompletion: { completion in
                // Handle completion (success or failure) if needed
            }, receiveValue: { [weak self] data in
                // Handle received data
                print(data)
                // Assuming data is an array of Cocktail objects
                self?.cocktails = data
            })
            .store(in: &cancellables)
    }
}
