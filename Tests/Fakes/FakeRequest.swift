import Foundation
import Swish

struct FakeRequest: Request {
  typealias ResponseObject = String

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "http://example.com")!)
  }

  func parse(_ data: Data) throws -> String {
    struct Body: Codable { var text: String }
    let body = try JSONDecoder().decode(Body.self, from: data)
    return body.text
  }
}

struct FakeEmptyDataRequest: Request {
  typealias ResponseObject = EmptyResponse

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "http://example.com")!)
  }
}

struct FakeStringRequest: Request {
  typealias ResponseObject = String

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "http://example.com")!)
  }

  func parse(_ data: Data) throws -> String {
    if let string = String(data: data, encoding: .utf8) {
      return string
    } else {
      throw FakeError(message: "invalid UTF-8")
    }
  }
}

struct FakeError: Error {
  var message: String
}
