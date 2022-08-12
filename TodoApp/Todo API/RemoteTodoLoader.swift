//
//  RemoteTodoLoader.swift
//  TodoApp
//
//  Created by Razee Hussein-Jamal on 2022-08-11.
//

import Foundation

public class RemoteTodoLoader: TodoLoader {
    private let urlRequest: URLRequest
    private let client: HTTPClient
    
    public init(urlRequest: URLRequest, client: HTTPClient) {
        self.urlRequest = urlRequest
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func load() async throws -> [Todo] {
        let result = try await self.client.request(from: urlRequest)
        let mapper = try TodoItemsMapper.map(result.0, from: result.1)
        return RemoteTodoLoader.map(mapper)
    }
    
    internal static func map(_ data: [RemoteTodoItem]) -> [Todo] {
        return data.map { item in
            return Todo(id: item.id, title: item.title)
        }
    }
}

private extension Array where Element == RemoteTodoItem {
    func toModels() -> [Todo] {
        return map { Todo(id: $0.id, title: $0.title) }
    }
}
