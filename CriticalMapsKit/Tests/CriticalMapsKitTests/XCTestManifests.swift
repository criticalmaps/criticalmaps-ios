import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(CriticalMapsKitTests.allTests),
        ]
    }
#endif
