//
//  RemoteTodo.swift
//  TodoApp
//
//  Created by Razee Hussein-Jamal on 2022-08-11.
//

import Foundation

internal struct RemoteTodoItem: Decodable {
    let id: UUID
    let title: String?
}
