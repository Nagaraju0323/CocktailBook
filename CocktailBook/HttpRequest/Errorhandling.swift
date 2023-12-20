//
//  ApiRequest.swift
//  CocktailBook
//
//  Created by Nagaraju on 20/12/23.
//

import Foundation

enum ErrorHandling: Error, LocalizedError {
    case noDataFound
    case jsonDataFailure
    case invalidURL
    case networkError(String)
    case unexpectedResponseCode(Int)
    
    var errorDescription: String? {
        switch self {
        case .noDataFound:
            return "No data found"
        case .jsonDataFailure:
            return "Failed to parse JSON data"
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let message):
            return "Network error: \(message)"
        case .unexpectedResponseCode(let code):
            return "Unexpected response code: \(code)"
        }
    }

    var failureReason: String? {
        switch self {
        case .noDataFound:
            return "The server returned no data"
        case .jsonDataFailure:
            return "There was an issue parsing the JSON data"
        case .invalidURL:
            return "The provided URL is invalid"
        case .networkError(let message):
            return "Network error: \(message)"
        case .unexpectedResponseCode(let code):
            return "The server returned an unexpected response code: \(code)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .noDataFound:
            return "Please check your internet connection and try again"
        case .jsonDataFailure:
            return "Contact support for assistance with parsing JSON data"
        case .invalidURL:
            return "Ensure that the URL is correct and try again"
        case .networkError:
            return "Check your network connection and try again"
        case .unexpectedResponseCode:
            return "Contact support for assistance with unexpected response codes"
        }
    }
}
