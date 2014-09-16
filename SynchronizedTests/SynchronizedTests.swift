// The MIT License (MIT)
//
// Copyright (c) 2014-present James Ide
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Synchronized
import XCTest

class SynchronizedTests: XCTestCase {

    // MARK: - Return values

    func testVoidReturnValue() {
        // Ensure that passing in a closure without a return value compiles
        let mutex = NSObject()
        synchronized(mutex) {}
    }

    func testNSObjectReturnValue() {
        let mutex = NSObject()
        let value = NSObject()
        let returnedValue = synchronized(mutex) { value }
        XCTAssertEqual(value, returnedValue, "Returned value should be the expected NSObject")
    }

    func testSwiftObjectReturnValue() {
        let mutex = NSObject()
        class SwiftObject {}
        let value = SwiftObject()
        let returnedValue = synchronized(mutex) { value }
        XCTAssertEqual(ObjectIdentifier(value), ObjectIdentifier(returnedValue),
            "Returned value should be the expected Swift object")
    }

    func testNilReturnValue() {
        let mutex = NSObject()
        let returnedValue: AnyObject? = synchronized(mutex) { nil }
        XCTAssertNil(returnedValue, "Returned value should be nil")
    }

    // MARK: - Mutex types

    func testSwiftObjectMutex() {
        class SwiftObject {}
        let mutex = SwiftObject()
        synchronized(mutex) {}
    }

    // MARK: - Concurrency

    func testMutualExclusion() {
        let mutexA = NSObject()
        let mutexB = NSObject()

        let expectationA1 = expectationWithDescription("Finished operation 1 with mutex A")
        let expectationA2 = expectationWithDescription("Finished operation 2 with mutex A")
        let expectationB1 = expectationWithDescription("Finished operation 1 with mutex B")

        let concurrentQueue = dispatch_queue_create("SynchronizedTests.testMutualExclusion", DISPATCH_QUEUE_CONCURRENT)

        dispatch_async(concurrentQueue) {
            synchronized(mutexA) {
                var operationA1DidFinish = false
                var operationA2DidFinish = false
                var operationB1DidFinish = false

                // Dispatch a subtask that acquires the same mutex
                let a2ActiveCondition = NSCondition()
                a2ActiveCondition.lock()

                dispatch_async(concurrentQueue) {
                    a2ActiveCondition.lock()
                    a2ActiveCondition.signal()
                    a2ActiveCondition.unlock()

                    synchronized(mutexA) {
                        XCTAssert(operationA1DidFinish, "Operation A1 did not finish before A2")
                        operationA2DidFinish = true
                        expectationA2.fulfill()
                    }
                }

                // Wait for operation A2 to begin
                a2ActiveCondition.wait()
                a2ActiveCondition.unlock()

                // Dispatch a subtask that acquires a different mutex and should run concurrently
                let b1ActiveCondition = NSCondition()
                b1ActiveCondition.lock()

                dispatch_async(concurrentQueue) {
                    b1ActiveCondition.lock()
                    b1ActiveCondition.signal()
                    b1ActiveCondition.unlock()
                    synchronized(mutexB) {
                        operationB1DidFinish = true
                        expectationB1.fulfill()
                    }
                }

                // Wait for operation B1 to begin
                b1ActiveCondition.wait()
                b1ActiveCondition.unlock()

                NSThread.sleepForTimeInterval(0.2)

                XCTAssert(!operationA2DidFinish, "Operation A2 did not wait for A1")
                XCTAssert(operationB1DidFinish, "Operation B1 did not finish before A1")
                
                operationA1DidFinish = true
                expectationA1.fulfill()
            }
        }

        waitForExpectationsWithTimeout(1) { (possibleError: NSError?) in
            if let error = possibleError? {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
