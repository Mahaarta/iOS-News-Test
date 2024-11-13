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
	
    var body: some View {
		VStack {
			Image(.dummy)
				.resizable()
				.frame(maxWidth: .infinity, maxHeight: 300)
			
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
    DetailNews(title: "Title", content: "Content", date: "04/02/2023 13:25:21")
}
