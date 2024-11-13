//
//  NetworkManager.swift
//  iosTestMinata
//
//  Created by Minata on 13/11/24.
//


import Foundation
import Combine

enum HTTPMethod: String {
	case GET, POST, PATCH, PUT, DELETE
}

enum NetworkError: Error {
	case invalidURL
	case requestFailed(message: String? = nil)
	case invalidResponse
	case decodingError
	case apiError(message: String)
	
	var localizedDescription: String {
		switch self {
		case .invalidURL:
			return "The URL is invalid."
		case .requestFailed(let message):
			return message ?? "The request failed due to an unknown error."
		case .invalidResponse:
			return "The server responded with an invalid response."
		case .decodingError:
			return "Failed to decode the response."
		case .apiError(let message):
			return message
		}
	}

}

class NetworkManager {
	static let shared = NetworkManager()
	private let jsonDecoder = JSONDecoder()
	private let baseUrl = "https://jsonplaceholder.org"
	
	private init() {}
	
	func request<T: Decodable>(
		url: String,
		method: HTTPMethod,
		parameters: [String: Any]? = nil,
		headers: [String: String]? = nil,
		responseType: T.Type,
		completion: @escaping (Result<T, NetworkError>) -> Void
	) {
		// Validate and prepare the URL
		guard let requestURL = URL(string: baseUrl + url) else {
			completion(.failure(.invalidURL))
			return
		}
		
		// Set up the request with method, headers, and parameters
		var request = URLRequest(url: requestURL)
		request.httpMethod = method.rawValue
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		// Add custom headers
		headers?.forEach { key, value in
			request.setValue(value, forHTTPHeaderField: key)
		}
		
		// Encode parameters for non-GET requests
		if let parameters = parameters, method != .GET {
			do {
				request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
			} catch {
				completion(.failure(.decodingError))
				return
			}
		}
		
		// Start the data task
		URLSession.shared.dataTask(with: request) { data, response, error in
			// Handle request error
			if let error = error {
				completion(.failure(.requestFailed(message: error.localizedDescription)))
				return
			}
			
			// Validate response status code
			if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
				completion(.failure(.invalidResponse))
				return
			}
			
			// Decode the data directly to the expected type T
			guard let data = data else {
				completion(.failure(.invalidResponse))
				return
			}
			
			do {
				let decodedResponse = try self.jsonDecoder.decode(T.self, from: data)
				completion(.success(decodedResponse))
			} catch {
				completion(.failure(.decodingError))
			}
		}.resume()
	}

}
