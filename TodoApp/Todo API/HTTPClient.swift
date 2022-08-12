//
//  HTTPClient.swift
//  TodoApp
//
//  Created by Razee Hussein-Jamal on 2022-08-11.
//

import Foundation

public protocol HTTPClient {
    func request(from urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse)
}
