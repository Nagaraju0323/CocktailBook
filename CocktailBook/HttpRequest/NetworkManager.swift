//
//  NetworkManager.swift
//  CocktailBook
//
//  Created by Nagaraju on 20/12/23.
//

import Foundation
import Network
import Combine


public class NetworkManager {
    
    static let shared = NetworkManager()

    private let pathMonitor = NWPathMonitor()
    private var isNetworkAvailableSubject = CurrentValueSubject<Bool, Never>(false)

    private init() {
        setupNetworkMonitoring()
    }

    public func isNetworkAvailablePublisher() -> AnyPublisher<Bool, Never> {
        return isNetworkAvailableSubject.eraseToAnyPublisher()
    }

    private func setupNetworkMonitoring() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            self?.handleNetworkUpdate(path: path)
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        pathMonitor.start(queue: queue)
    }

    private func handleNetworkUpdate(path: NWPath) {
        let isNetworkAvailable = path.status == .satisfied
        isNetworkAvailableSubject.send(isNetworkAvailable)
    }
}
