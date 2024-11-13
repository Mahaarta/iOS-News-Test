//
//  NewsService.swift
//  iosTestMinata
//
//  Created by Minata on 13/11/24.
//

import Foundation
import Combine

class NewsService: ObservableObject {
	
	@Published var newsModel: [NewsModel] = []
	private var cancellables = Set<AnyCancellable>()
	
	func fetchNews(completion: @escaping (Error?) -> Void) {
		NetworkManager.shared.request(
			url: "/posts",
			method: .GET,
			parameters: [:],
			responseType: [NewsModel].self
		) { result in
			switch result {
			case .success(let response):
				self.newsModel = response
			case .failure(let error):
				completion(error)
			}
		}
	}
}

