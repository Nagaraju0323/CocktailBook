//
//  APIRequest.swift
//  CocktailBook
//
//  Created by Nagaraju on 20/12/23.
//

import Foundation
import Combine

//MARK : Remote NetworkAPI

protocol APIRequestRemote {
    func fetchData() -> AnyPublisher<[CocktailElement], ErrorHandling>
    
}

class APIRequest:APIRequestRemote {
    
    func fetchData() -> AnyPublisher<[CocktailElement], ErrorHandling> {
            guard let url = URL(string: "your_api_endpoint_here") else {
                return Fail(error: .invalidURL).eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, response in
                    data
                }
                .mapError { error in
                    if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                        return ErrorHandling.networkError("Not connected to the internet")
                    } else {
                        return ErrorHandling.unexpectedResponseCode((error as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                }
                .decode(type: [CocktailElement].self, decoder: JSONDecoder())
                .mapError { _ in ErrorHandling.jsonDataFailure }
                .eraseToAnyPublisher()
        }
}



//MARK : Featch From LocalDB 
protocol featchLocalDB {
 func fetchData() -> AnyPublisher<[CocktailElement], ErrorHandling>
    
}

class FetchDB: featchLocalDB {
    func fetchData() -> AnyPublisher<[CocktailElement], ErrorHandling> {
        return Future { promise in
            guard let file = Bundle.main.url(forResource: "Sample", withExtension: "json") else {
                promise(.failure(ErrorHandling.noDataFound))
                return
            }
            do {
                let data = try Data(contentsOf: file)
                let decodedData = try JSONDecoder().decode([CocktailElement].self, from: data)
                promise(.success(decodedData))
            } catch {
                promise(.failure(ErrorHandling.noDataFound))
            }
        }
        .eraseToAnyPublisher()
    }
}
