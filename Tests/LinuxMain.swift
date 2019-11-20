import XCTest

import SwiftRingBufferTests

var tests = [XCTestCaseEntry]()
tests += SwiftRingBufferTests.allTests()
XCTMain(tests)