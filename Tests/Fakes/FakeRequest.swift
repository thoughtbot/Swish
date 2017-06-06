import Foundation
import Swish
import Result

struct FakeRequest: Request {
  typealias ResponseObject = String

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "http://example.com")!)
  }

  func parse(_ data: Data) throws -> String {
    let body = try JSONDecoder().decode(FakeResponseBody.self, from: data)
    return body.text
  }
}

private struct FakeResponseBody: Codable {
  var text: String
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
