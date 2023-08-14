//
//  Networking.swift
//  pexelsfeed
//
//  Created by Andrey Chipilenko on 13.08.2023.
//

import Foundation
import Combine

class NetworkingManager {
    
    // MARK: - Endpoints
    enum APIEndpoints {
        case getCuratedImages
        case getImage(id: Int)
        
        var path: String {
            switch self {
            case .getCuratedImages:
                return "/v1/curated"
            case .getImage(let imageId):
                return "/v1/photos/\(imageId)"
            }
        }
        
        var baseURL: String {
            return Bundle.main.object(forInfoDictionaryKey: "API_URL") as! String
        }
        
        var urlComponents: URLComponents {
            return URLComponents(string: "https://\(baseURL)" + path)!
        }
    }
    
    // MARK: - Constants
    static let DefaultPerPage = 80
    
    // MARK: - API calls
    static func getCuratedImages(page: Int, perPage: Int = DefaultPerPage) -> AnyPublisher<PexelsAPIResponse, Error> {
        var components = APIEndpoints.getCuratedImages.urlComponents
        let queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        components.queryItems = queryItems
        let url = components.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let apikey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
        request.addValue(apikey, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let decoder = JSONDecoder()
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PexelsAPIResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
