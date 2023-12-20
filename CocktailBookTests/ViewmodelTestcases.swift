//
//  ViewmodelTestcases.swift
//  CocktailBookTests
//
//  Created by Nagaraju on 21/12/23.
//

import XCTest
import Combine
@testable import CocktailBook

final class MockDataFetcherAdapter: DataFetcherAdapter {
    
    var result: Result<[CocktailElement], Error> = .success([])

    // Custom initializer for the mock adapter
    init(result: Result<[CocktailElement], Error>) {
        self.result = result
        super.init(networkManager: NetworkManager.shared)
    }

     func fetchData() -> AnyPublisher<[CocktailElement], Error> {
        return Result.Publisher(result)
            .eraseToAnyPublisher()
    }
}

class CocktailViewModelTests: XCTestCase {
    
    var viewModel: CocktailViewModel!
    var dataFetcher: MockDataFetcherAdapter!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        // Provide a default result or customize it in each test case
        dataFetcher = MockDataFetcherAdapter(result: .success([]))
        viewModel = CocktailViewModel(dataFetcher: dataFetcher)
    }

    override func tearDown() {
        viewModel = nil
        dataFetcher = nil
        super.tearDown()
    }

    func testFetchDataSuccess() {
        // Given
        let jsonData = """
        [
          {
            "id": "0",
            "name": "Piña colada",
            "type": "alcoholic",
            "shortDescription": "Velvety-smooth texture and a taste of the tropics are what this tropical drink delivers.",
            "longDescription": "The Piña Colada is a Puerto Rican rum drink made with pineapple juice (the name means “strained pineapple” in Spanish) and cream of coconut...",
            "preparationMinutes": 7,
            "imageName": "pinacolada",
            "ingredients": [
              "4 oz rum",
              "3 oz fresh pineapple juice, chilled...",
              "Fresh pineapple, for garnish"
            ]
          }
        ]
        """.data(using: .utf8)!

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase // Adjust if needed

            let expectedData = try decoder.decode([CocktailElement].self, from: jsonData)

            // Now, `expectedData` is an array of CocktailElement
            print(expectedData)

            // Given
            dataFetcher.result = .success(expectedData)

            let expectation = XCTestExpectation(description: "Fetch Data Expectation")

            // When
            viewModel.fetchData()

            // Then
            viewModel.$cocktails
                .dropFirst() // Ignore the initial value
                .sink { cocktails in
                    XCTAssertEqual(cocktails, expectedData)
                    expectation.fulfill()
                }
                .store(in: &cancellables)

            let result = XCTWaiter.wait(for: [expectation], timeout: 5)
               if result != .completed {
                   XCTFail("Test timed out.")
               }
        } catch {
            XCTFail("Error decoding JSON: \(error)")
        }
    }


}

