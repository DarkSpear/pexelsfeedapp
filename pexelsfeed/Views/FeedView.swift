//
//  ContentView.swift
//  pexelsfeed
//
//  Created by Andrey Chipilenko on 13.08.2023.
//

import SwiftUI

struct FeedView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets // Alternativley can use a GeometryReader to get safeAreaInsets
    
    @ObservedObject var viewModel = PexelsFeedViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.images.isEmpty &&
                    viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.images) { image in
                                photoCell(image: image)
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                            }
                            
                            Spacer(minLength: safeAreaInsets.bottom)
                        }
                    }
                    .refreshable {
                        viewModel.refresh() 
                        // It should be async but it doesn't matter because on refresh I remove all images and here will be full screen ProgrssView
                    }
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.alertError != nil },
                set: { _ in viewModel.alertError = nil }
            )) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertError?.error ?? ""),
                      dismissButton: .default(Text("OK")))
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationTitle("Curated")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func photoCell(image: PexelsImage) -> some View {
        NavigationLink {
            FullImageView(pexelImage: image)
        } label: {
            PexelsImageView(pexelImage: image)
        }
        .onAppear {
            viewModel.onImageAppera(image: image)
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView().preferredColorScheme(.dark)
    }
}
