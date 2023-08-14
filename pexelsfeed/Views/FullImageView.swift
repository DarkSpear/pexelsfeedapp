//
//  FullImageView.swift
//  pexelsfeed
//
//  Created by Andrey Chipilenko on 14.08.2023.
//

import SwiftUI

struct FullImageView: View {
    
    @State var lastScaleValue: CGFloat = 1.0
    @State var scale: CGFloat = 1.0
    
    let progressViewBackgroundSize: CGFloat = 100
    let progressViewBackgroundOpacity: CGFloat = 0.25
    let progressViewBackgroundCornerRadius: CGFloat = 25
    
    let pexelImage: PexelsImage
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: pexelImage.src.original), content: { image in
                image
                    .resizable()
            }, placeholder: {
                imagePlaceholder()
            })
            .aspectRatio(CGFloat(pexelImage.width) / CGFloat(pexelImage.height), contentMode: .fit)
        }
        .navigationTitle(pexelImage.photographer)
    }
    
    func imagePlaceholder() -> some View {
        ZStack {
            if let color = Color(hex: pexelImage.color) {
                color
            } else {
                Color.gray
            }
            
            Color.black
                .opacity(progressViewBackgroundOpacity)
                .frame(width: progressViewBackgroundSize, height: progressViewBackgroundSize)
                .clipShape(RoundedRectangle(cornerRadius: progressViewBackgroundCornerRadius, style: .continuous))
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
    }
}

