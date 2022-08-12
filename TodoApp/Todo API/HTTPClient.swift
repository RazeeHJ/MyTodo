//
//  HTTPClient.swift
//  TodoApp
//
//  Created by Razee Hussein-Jamal on 2022-08-11.
//

import Foundation

public typealias Response = (Data, HTTPURLResponse)

public protocol HTTPClient {
    func request(from urlRequest: URLRequest) async throws -> Response
}
