//
//  NetworkOperatorTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 01.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class NetworkOperatorTests: XCTestCase {
    
    struct ResponseData: Codable {
        var content: String
    }
    
    struct TestRequest: APIRequestDefining {
        var endpoint: Endpoint = .default
        var httpMethod: HTTPMethod = .get
        var headers: HTTPHeaders? = nil
        typealias ResponseDataType = ResponseData
    }
    
    func testNoData() {
        XCTAssertRequest(dataProvider: mockDataProvider(statusCode: 201), expectedResult: .failure(.noData(nil)))
    }
    
    func testInvalidStatusCode() {
        XCTAssertRequest(dataProvider: mockDataProvider(data: "foo", statusCode: 404), expectedResult: .failure(.invalidResponse))
    }
    
    func testDecodingError() {
        enum FooError: Error  {
            case f
        }
        
        XCTAssertRequest(dataProvider: mockDataProvider(rawData: "foo".data(using: .utf8), statusCode: 201), expectedResult: .failure(.decodingError(FooError.f)))
    }
    
    func testSuccess() {
        XCTAssertRequest(dataProvider: mockDataProvider(data: "foo", statusCode: 201), expectedResult: .success(ResponseData(content:"foo")))
    }
    
    private func XCTAssertRequest(dataProvider: MockNetworkDataProvider , expectedResult: Result<ResponseData, NetworkError>, line: UInt = #line) {
        
        let exp = expectation(description: "wait for response")
        exp.expectedFulfillmentCount = 2
        
        let networkOperator = NetworkOperator(networkIndicatorHelper: NetworkActivityIndicatorHelper(), dataProvider: dataProvider)
        
        let resultCallback: ResultCallback<ResponseData> = { result in
            switch (result, expectedResult) {
            case (.failure(let lhsError), .failure(let rhsError)):
                XCTAssert(lhsError == rhsError, line: line)
            case (.success(let lhsResponse), .success(let rhsResponse)):
                XCTAssert(lhsResponse.content == rhsResponse.content, line: line)
            default:
                XCTAssert(false, line: line)
            }
            exp.fulfill()
        }
        
        // GET
        networkOperator.get(request: TestRequest(), completion: resultCallback)
        
        // Post
        networkOperator.post(request: TestRequest(), bodyData: "Foo".data(using: .utf8)!, completion: resultCallback)
        
        
        wait(for: [exp], timeout: 1)
    }
    
    private func mockDataProvider(data: String? = nil, rawData: Data? = nil, statusCode: Int = 200) -> MockNetworkDataProvider {
        let responseData: Data? = data != nil ? try! ResponseData(content: data!).encoded() : nil
        return MockNetworkDataProvider(data: responseData ?? rawData,
                                       response: HTTPURLResponse(url: Constants.apiEndpoint, statusCode: statusCode, httpVersion: nil, headerFields: nil),
                                       error: nil)
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError(_), .decodingError(_)):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.noData(_), .noData(_)):
            return true
        default:
            return false
        }
    }
}
