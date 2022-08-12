//
//  LoadTodoTaskFromRemoteUseCase.swift
//  TodoAppTests
//
//  Created by Razee Hussein-Jamal on 2022-08-11.
//

import XCTest
import TodoApp

class LoadTodoTaskFromRemoteUseCase: XCTestCase {
    
    func test_init_doesNotRequestDataFromURLRequest() {
        // Given
        let client = HTTPClientSpy(response: anyResponse(), error: nil)
        
        // Then
        XCTAssertTrue(client.requests.isEmpty)
    }
    
    func test_load_requestsDataFromURLRequest() async {
        // Given
        let (sut, client) = makeSUT()
        
        // When
        do {
            _ = try await sut.load()
            XCTFail("It should throw error: ")
        } catch {
            // Then
            XCTAssertEqual(client.requests, [anyURLRequest()])
        }
    }
    
    func test_loadTwice_requestsDataFromURLTwice() async {
        // Given
        let (sut, client) = makeSUT()
        
        do {
            // When
            _ = try await sut.load()
            XCTFail("It should throw error due to invalid data: \(RemoteTodoLoader.Error.invalidData)")
        } catch {
            // Then
            XCTAssertEqual(client.requests, [anyURLRequest()])
        }
        
        do {
            // When
            _ = try await sut.load()
            XCTFail("It should throw error due to invalid data: \(RemoteTodoLoader.Error.invalidData)")
        } catch {
            // Then
            XCTAssertEqual(client.requests, [anyURLRequest(), anyURLRequest()])
        }
    }
    
    func test_load_deliversErrorOnClientError() async {
        // Given
        let (sut, _) = makeSUT(response: nil, error: RemoteTodoLoader.Error.connectivity)
        
        // When
        do {
            _ = try await sut.load()
            XCTFail("Expected error: \(RemoteTodoLoader.Error.connectivity)")
        } catch {
            // Then
            XCTAssertEqual(error as? RemoteTodoLoader.Error, .connectivity)
        }
    }
    
    func test_load_deliversErrorInNon200HTTPResponse() async {
        // Given
        let (sut, _) = makeSUT(response: anyResponse(data: makeItemsJSON([]), httpURLResponse: anyHTTURLResponse(statusCode: 400)))
        
        // When
        do {
            _ = try await sut.load()
            XCTFail("Expected error: \(RemoteTodoLoader.Error.invalidData)")
        } catch {
            // Then
            XCTAssertEqual(error as? RemoteTodoLoader.Error, .invalidData)
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() async {
        // Given
        let (sut, _) = makeSUT(response: anyResponse(data: Data("".utf8)))
        
        // When
        do {
            _ = try await sut.load()
            XCTFail("Expected error: \(RemoteTodoLoader.Error.invalidData)")
        } catch {
            // Then
            XCTAssertEqual(error as? RemoteTodoLoader.Error, .invalidData)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() async {
        // Given
        let (sut, _) = makeSUT(response: anyResponse(data: makeItemsJSON([])))
        
        // When
        do {
            let result = try await sut.load()
            XCTAssertTrue(result.isEmpty)
        } catch {
            // Then
            XCTFail("It should not throw any error")
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() async {
        // Given
        let item = makeItem(id: UUID(), title: "Clean House")
        let expectedResult = [item.model]
        let json = makeItemsJSON([item.json])
        
        let (sut, _) = makeSUT(response: anyResponse(data: json))

        // When
        do {
            let result = try await sut.load()
            XCTAssertEqual(result, expectedResult)
        } catch {
            // Then
            XCTFail("It should not throw any error")
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        
    }
    
    // MARK:
    
    private func makeSUT(urlRequest: URLRequest = anyURLRequest(), response: Response? = anyResponse(), error: RemoteTodoLoader.Error? = nil) -> (sut: RemoteTodoLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(response: response, error: error)
        let sut = RemoteTodoLoader(urlRequest: urlRequest, client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private func makeItem(id: UUID, title: String? = nil) -> (model: Todo, json: [String: Any]) {
        let item = Todo(id: id, title: title)
        
        let json = [
            "id": id.uuidString,
            "title": title
        ].reduce(into: [String: Any]()) { (acc, e) in
            if let value = e.value { acc[e.key] = value }
        }
        return (item,json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private(set) var requests = [URLRequest]()
        private var response: Response?
        private var error: Error?
        
        init(response: Response?, error: Error?) {
            self.response = response
            self.error = error
        }
        
        func request(from urlRequest: URLRequest) async throws -> Response {
            self.requests.append(urlRequest)
            
            guard let response = response else {
                throw error!
            }
            return response
        }
    }
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyURLRequest() -> URLRequest {
    URLRequest(url: URL(string: "http://any-url.com")!)
}

func anyResponse(data: Data = Data(), httpURLResponse: HTTPURLResponse = HTTPURLResponse()) -> Response {
    (data, httpURLResponse)
}

func anyHTTURLResponse(url: URL = anyURL(), statusCode: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
