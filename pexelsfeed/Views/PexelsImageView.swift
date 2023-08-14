//
//  PexelsImageView.swift
//  pexelsfeed
//
//  Created by Andrey Chipilenko on 14.08.2023.
//

import SwiftUI

struct PexelsImageView: View {
    
    let pexelImage: PexelsImage
    
    let cornerRadius: CGFloat = 25
    let shadow: CGFloat = 5
    let offset: CGFloat = 5
    
    var body: some View {
        VStack {
            ZStack {
                AsyncImage(url: URL(string: pexelImage.src.medium), content: { image in
                    image
                        .resizable()
                }, placeholder: {
                    imagePlaceholder()
                })
                
                PhotographerView(photographer: pexelImage.photographer)
            }
            .aspectRatio(CGFloat(pexelImage.width) / CGFloat(pexelImage.height), contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(radius: shadow, y: shadow)
        }
        .padding(.horizontal)
        .padding(.vertical, offset)
    }
    
    func imagePlaceholder() -> some View {
        if let color = Color(hex: pexelImage.color) {
            return color
        } else {
            return Color.gray
        }
    }
}

struct PhotographerView: View {
    
    let photographer: String
    
    let bottomViewHeight: CGFloat = 60
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                LinearGradient(colors: [.black, .black.opacity(0)], startPoint: .bottom, endPoint: .top)
                    .frame(height: bottomViewHeight)
                VStack(alignment: .leading) {
                    HStack {
                        Text(photographer)
                            .foregroundStyle(.white)
                            .padding()
                        
                        Spacer()
                    }
                }
            }
        }
    }
}
