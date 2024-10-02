//
//  ComponentGenView.swift
//  SportScore
//
//  Created by Macbook on 2/10/24.
//

import SwiftUI


struct ComponentGenView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.callout.bold())
                Spacer()
            }
            content
        }
    }
}
