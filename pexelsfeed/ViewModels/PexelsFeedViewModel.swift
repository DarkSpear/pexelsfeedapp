//
//  PexelsFeedViewModel.swift
//  pexelsfeed
//
//  Created by Andrey Chipilenko on 13.08.2023.
//

import Foundation
import Combine

struct AlertError: Identifiable {
    let id: String
    let error: String
}

class PexelsFeedViewModel: ObservableObject {
    @Published var images: [PexelsImage] = []
    @Published var isLoading: Bool = true
    @Published var alertError: AlertError?
    
    private var subsriptions = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var total = 0
    private var perPage = 80
    
    private let threshold = 20
    private var isNextPage: Bool {
        total - (currentPage * perPage) > 0
    }
    
    init() {
        refresh()
    }

    func fetchImages(page: Int) {
        isLoading = true
        NetworkingManager.getCuratedImages(page: page, perPage: perPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                switch response {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    print("Error \(error)")
                    self?.isLoading = false
                    self?.alertError = AlertError(id: UUID().uuidString, error: error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.images.append(contentsOf: response.photos)
                self?.currentPage = response.page
                self?.total = response.totalResults
            }
            .store(in: &subsriptions)
    }
    
    func fetchNextPage() {
        fetchImages(page: currentPage + 1)
    }
    
    func refresh() {
        currentPage = 1
        total = 0
        images = []
        fetchImages(page: currentPage)
    }
    
    func onImageAppera(image: PexelsImage) {
        if isLoading || !isNextPage {
            return
        }
        
        guard let index = images.firstIndex(where: { $0.id == image.id }) else {
            return
        }
        
        let currentThresholdIndex = images.index(images.endIndex, offsetBy: -threshold)
        
        if index != currentThresholdIndex {
            return
        }
        
        fetchNextPage()
    }
}
