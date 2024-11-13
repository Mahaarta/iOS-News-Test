//
//  DetailNews.swift
//  iosTestMinata
//
//  Created by Minata on 13/11/24.
//

import SwiftUI

struct DetailNews: View {
	var title: String
	var content: String
	var date: String
	var imageUrl: URL
	
    var body: some View {
		VStack {
			AsyncImage(url: imageUrl) { phase in
				switch phase {
				case .empty:
					ProgressView()
				case .success(let image):
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(maxWidth: .infinity, maxHeight: 300)
						.clipped()
				case .failure:
					Image(.dummy)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 50, height: 50)
						.foregroundColor(.red)
				@unknown default:
					EmptyView()
				}
			}
			
			Text(title)
			
			Text(content)
			
			VStack(spacing: 5) {
				Text("Published Date") 
				Text(date)
			}
		}
		.padding()
    }
}

#Preview {
	DetailNews(title: "Title", content: "Content", date: "04/02/2023 13:25:21", imageUrl: URL(string: "")!)
}
