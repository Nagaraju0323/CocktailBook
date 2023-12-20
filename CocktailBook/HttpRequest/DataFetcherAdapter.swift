//
//  DataFetcherAdapter.swift
//  CocktailBook
//
//  Created by Nagaraju on 20/12/23.
//

import Foundation
import Combine


//MARK: - Adapter
///based on the network it will featch from data
///if netwrok fail featch from local DB if not featch from remote

class DataFetcherAdapter {
    
    private let remoteFetcher: APIRequestRemote
    private let localFetcher: featchLocalDB
    let networkManager : NetworkManager
    
    init(remoteFetcher: APIRequestRemote = APIRequest() , localFetcher: featchLocalDB = FetchDB(),networkManager: NetworkManager) {
        self.remoteFetcher = remoteFetcher
        self.localFetcher = localFetcher
        self.networkManager = networkManager
    }
    
    func fetchData() -> AnyPublisher<[CocktailElement], ErrorHandling> {
           return networkManager.isNetworkAvailablePublisher()
               .flatMap { isNetworkAvailable -> AnyPublisher<[CocktailElement], ErrorHandling> in
                   if isNetworkAvailable {
                      // return self.remoteFetcher.fetchData()
                       return self.localFetcher.fetchData()
                   } else {
                       return self.localFetcher.fetchData()
                   }
               }
               .eraseToAnyPublisher()
       }
}
