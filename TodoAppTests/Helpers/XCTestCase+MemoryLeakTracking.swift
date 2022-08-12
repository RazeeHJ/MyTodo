//
//  XCTestCase+MemoryLeakTracking.swift
//  TodoAppTests
//
//  Created by Razee Hussein-Jamal on 2022-08-12.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
