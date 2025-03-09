////
////  EndPointProtocols.swift
////  RickAndMortyAPP
////
////  Created by Alper Gok on 9.03.2025.
////
//
//import Foundation
//
//protocol EndPointProtocols {
//    var baseURL: String { get }
//    var path: String { get }
//    var parameters: [ String: Any ]?  { get }
//    var headers: [ String: String ]?  { get }
//    var method: HTTPMethod { get  }
//    
//    
//}
//
//
//enum HTTPMethod: String {
//    case get    = "GET"
//    case post   = "POST"
//    case put    = "PUT"
//    case delete = "DELETE"
//}
//
//enum RickAndMortyEndpoints: EndPointProtocols {
//    
//    case RickAndMortyData(id: String)
//    
//    
//    
//    
//    
//    
//    
//    
//    var baseURL: String {
//        "www.rickandmorty.api"
//        
//    }
//    
//    var path: String {
//        switch self {
//        case .RickAndMortyData(let id):
//            "/method=get\(id)"
//        }
//    }
//    
////    var parameters: [String : Any]?
////    
////    var headers: [String : String]?
////    
////    var method: HTTPMethod
//    
//    
//}
//
//import Foundation
//
//public protocol ServiceEndpointsProtocol {
//    var baseURL: String { get }
//    var path: String { get }
//    var parameter: [String: Any]? { get }
//    var headers: [String: String] { get }
//    var method: HTTPMethod { get }
//}
//
//public enum HTTPMethod: String {
//    case get = "GET"
//    case post = "POST"
//    case put = "PUT"
//    case delete = "DELETE"
//}
//
//public enum WeatherEndpoints: ServiceEndpointsProtocol {
//    case getForecast(lat: Double, lon: Double)
//    case getCurrentWeather(lat: Double, lon: Double)
//
//    public var baseURL: String {
//        return NetworkingConstants.baseURL
//    }
//    
//    public var path: String {
//        switch self {
//        case .getForecast:
//            return NetworkingConstants.NetworkingEndpoints.forecastEndpoint
//        case .getCurrentWeather:
//            return NetworkingConstants.NetworkingEndpoints.currentWeatherEndpoint
//        }
//    }
//
//    public var method: HTTPMethod {
//        switch self {
//        case .getForecast, .getCurrentWeather:
//            return .get
//        }
//    }
//    
//    public var parameter: [String: Any]? {
//        switch self {
//        case let .getForecast(latitude, longtitude):
//            return ["lat": latitude.string,
//                    "lon": longtitude.string
//            ]
//        case let .getCurrentWeather(latitude, longtitude):
//            return ["lat": latitude.string,
//                    "lon": longtitude.string
//            ]
//        }
//    }
//    
//    public var headers: [String : String] {
//        return [
//            "X-RapidAPI-Key": NetworkingConstants.apiKey,
//            "X-RapidAPI-Host": NetworkingConstants.apiHost
//        ]
//    }
//}
//
//import Foundation
//import Combine
//
//public protocol HTTPClientProtocol {
//    func request<T: Codable>(endpoint: ServiceEndpointsProtocol) -> AnyPublisher<T, APIError>
//}
//
//public final class URLSessionHTTPClient: HTTPClientProtocol {
//    private let session: URLSession
//    
//    public init(session: URLSession = .shared) {
//        self.session = session
//    }
//    
//    public func request<T: Codable>(endpoint: ServiceEndpointsProtocol) -> AnyPublisher<T, APIError> {
//        
//        guard let url = createRequestUrl(from: endpoint) else {
//            return Fail(error: APIError(with: .badRequest, messageKey: "bad_request_error_message")).eraseToAnyPublisher()
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = endpoint.method.rawValue
//        request.allHTTPHeaderFields = endpoint.headers
//        
//        return session.dataTaskPublisher(for: request)
//            .tryMap { output in
//                if let httpResponse = output.response as? HTTPURLResponse,
//                   (200..<300).contains(httpResponse.statusCode) {
//                    return output.data
//                } else {
//                    let response = (output.response as? HTTPURLResponse)
//                    let statusCode = response?.statusCode ?? -1
//                    let errorType = APIErrorType(rawValue: statusCode) ?? .unknown
//                    let errorData = try JSONDecoder().decode(APIErrorResponse.self, from: output.data)
//                    let apiError = APIError(with: errorType,
//                                            message: errorData.message ?? "")
//                    throw apiError
//                }
//            }
//            .decode(type: T.self, decoder: Decoders.mainDecoder)
//            .mapError { error -> APIError in
//                if error is DecodingError {
//                    return APIError(with: .decodingFailed, message: error.localizedDescription)
//                } else if let apiError = error as? APIError {
//                    return apiError
//                } else {
//                    return APIError(with: .unknown,
//                                    messageKey: "unknown_error_message")
//                }
//            }
//            .eraseToAnyPublisher()
//    }
//    
//    private func createRequestUrl(from endpoint: ServiceEndpointsProtocol) -> URL? {
//        guard !endpoint.baseURL.isEmpty else { return nil }
//        var components = URLComponents(string: endpoint.baseURL)
//        components?.path   = endpoint.path
//        switch endpoint.method {
//        case .get:
//            components?.queryItems = createQueryParamaters(from: endpoint.parameter)
//        case .post, .put, .delete:
//            break
//        }
//        return components?.url
//    }
//    
//    private func createQueryParamaters(from dict: [String: Any]?) -> [URLQueryItem]? {
//        guard let parameters = dict, !parameters.isEmpty else { return nil }
//        var queryItems = [URLQueryItem]()
//        for (key, value) in parameters {
//            let queryItem = URLQueryItem(name: key, value: "\(value)")
//            queryItems.append(queryItem)
//        }
//        let languageParameter = URLQueryItem(name: "lang", value: NetworkingConstants.AppLocale.language.rawValue)
//        queryItems.append(languageParameter)
//        
//        return queryItems
//    }
//}
//
//import Foundation
//import Combine
//
//public protocol WeatherClientProtocol {
//    func getCurrentWeather(lat: Double, lon: Double) -> AnyPublisher<CurrentWeatherListModel, APIError>
//    func getForecast(lat: Double, lon: Double) -> AnyPublisher<WeatherListModel, APIError>
//}
//
//public final class WeatherClient: WeatherClientProtocol {
//    private let client: HTTPClientProtocol
//    
//    public init(client: HTTPClientProtocol) {
//        self.client = client
//    }
//    
//    public func getCurrentWeather(lat: Double, lon: Double) -> AnyPublisher<CurrentWeatherListModel, APIError> {
//        client.request(endpoint: WeatherEndpoints.getCurrentWeather(lat: lat, lon: lon))
//    }
//    
//    public func getForecast(lat: Double, lon: Double) -> AnyPublisher<WeatherListModel, APIError> {
//        client.request(endpoint: WeatherEndpoints.getForecast(lat: lat, lon: lon))
//    }
//}
