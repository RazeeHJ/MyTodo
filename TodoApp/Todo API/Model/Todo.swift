//
//  Todo.swift
//  TodoApp
//
//  Created by Razee Hussein-Jamal on 2022-08-11.
//

import Foundation

public struct Todo: Equatable {
    let id: UUID
    let title: String?
    
    public init(id: UUID, title: String?) {
        self.id = id
        self.title = title
    }
}
