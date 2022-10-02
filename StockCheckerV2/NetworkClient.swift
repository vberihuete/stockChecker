//
//  NetworkClient.swift
//  StockChecker
//
//  Created by Vincent Berihuete Paulino on 23/09/2022.
//

import Foundation

protocol NetworkClientProtocol {
    @discardableResult
    func request<T: Decodable>(
        url: String,
        method: NetworkMethod,
        params: Params,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) -> CancellableDataTaskProtocol?
}
protocol CancellableDataTaskProtocol {
    func cancel()
}

// MARK: Implementation
final class NetworkClient: NetworkClientProtocol {
    private let urlSession: URLSession
    private let decoder = JSONDecoder()

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    convenience init() {
        self.init(urlSession: .init(configuration: .default))
    }

    @discardableResult
    func request<T: Decodable>(
        url: String,
        method: NetworkMethod,
        params: Params,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) -> CancellableDataTaskProtocol? {
        guard var urlComponents = URLComponents(string: url) else {
            completion(.failure(.unexpectedUrl))
            return nil
        }

        switch params {
        case let .query(parameters):
            let queryItems: [URLQueryItem] = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            completion(.failure(.unexpectedUrl))
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let task = urlSession.dataTask(with: request) { [decoder] data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return completion(.failure(.generic(statusCode: -1))) }
            if let error = error {
                completion(.failure(.generic(statusCode: httpResponse.statusCode, description: error.localizedDescription)))
                return
            }
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.corruptData(description: error.localizedDescription)))
                print(httpResponse)
            }
        }
        task.resume()
        return CancellableDataTask(task: task)
    }
}

final class CancellableDataTask: CancellableDataTaskProtocol {
    private let task: URLSessionDataTask

    init(task: URLSessionDataTask) {
        self.task = task
    }

    func cancel() {
        task.cancel()
    }
}


enum NetworkError: Error, Equatable {
    case generic(statusCode: Int, description: String = "")
    case noData
    case corruptData(description: String)
    case unexpectedUrl
}
enum Params: Equatable {
    case query([String: String])
}

enum NetworkMethod: String {
    case get = "GET"
}
