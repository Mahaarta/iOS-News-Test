//
//  ContentView.swift
//  iosTestMinata
//
//  Created by Minata on 13/11/24.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject var newsService = NewsService()
	
    var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				Text("News")
					.font(.system(size: 30))
					.foregroundStyle(Color(UIColor.label))
				
				ScrollView {
					let newsData = newsService.newsModel
					ForEach(newsData, id: \.id) { news in
						NavigationLink(destination: DetailNews(title: news.title, content: news.content, date: news.publishedAt)) {
							NewsCell(
								title: news.title,
								description: news.content,
								date: news.publishedAt,
								imageUrl: URL(string: news.image) ?? URL(string: "")!
							)
						}
					}
				}
			}
		}
		.padding()
		.onAppear {
			newsService.fetchNews(completion: { error in
				if let _ = error {
					print("error appear here")
				} else {
					
				}
			})
		}
    }
}

struct NewsCell: View {
	var title: String
	var description: String
	var date: String
	var imageUrl: URL
	
	var body: some View {
		HStack(spacing: 16) {
			AsyncImage(url: imageUrl) { phase in
				switch phase {
				case .empty:
					ProgressView()
				case .success(let image):
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 100, height: 100)
						.clipped()
				case .failure:
					Image(systemName: "xmark.circle")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50, height: 50)
						.foregroundColor(.red)
				@unknown default:
					EmptyView()
				}
			}
			
			VStack(alignment: .leading) {
				Text(title)
					.font(.system(size: 20))
					.font(.title)
					.bold()
					.foregroundStyle(Color(UIColor.label))
					.lineLimit(1)
				
				Text(description)
					.font(.subheadline)
					.font(.system(size: 12))
					.foregroundStyle(Color(UIColor.label))
					.lineLimit(2)
				
				Spacer()
				
				Text(date)
					.font(.system(size: 14))
					.foregroundStyle(Color(UIColor.label))
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

#Preview {
    ContentView()
}
