import Foundation
import Swish
import Result

struct FakeRequest: Request {
  typealias ResponseObject = String

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "http://example.com")!)
  }

  func parse(_ data: Data) -> Result<String, SwishError> {
    let decoder = JSONDecoder()
    let result = Result<String, AnyError> {
      let body = try decoder.decode(FakeResponseBody.self, from: data)
      return body.text
    }
    return result.mapError { SwishError.decodeError($0.error) }
  }
}

struct FakeEmptyDataRequest: Request {
  typealias ResponseObject = EmptyResponse

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "http://example.com")!)
  }
}

private struct FakeResponseBody: Codable {
  var text: String
}
