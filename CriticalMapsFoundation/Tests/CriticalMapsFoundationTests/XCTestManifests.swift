import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(CriticalMapsFoundationTests.allTests),
        ]
    }
#endif
