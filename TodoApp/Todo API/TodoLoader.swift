//
//  TodoLoader.swift
//  TodoApp
//
//  Created by Razee Hussein-Jamal on 2022-08-11.
//

import Foundation

protocol TodoLoader {
    func load() async throws -> [Todo]
}
