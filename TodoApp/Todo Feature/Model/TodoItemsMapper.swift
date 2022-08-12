//
//  TodoItemsMapper.swift
//  TodoApp
//
//  Created by Razee Hussein-Jamal on 2022-08-12.
//

import Foundation

internal final class TodoItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteTodoItem]
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteTodoItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteTodoLoader.Error.invalidData
        }
        
        return root.items
    }
}
