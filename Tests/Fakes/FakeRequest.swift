import Foundation
import Swish
import Argo
import Result

struct FakeRequest: Request {
  typealias ResponseObject = String

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "http://example.com")!)
  }

  func parse(_ j: JSON) -> Result<String, SwishError> {
    return .fromDecoded(j <| "text")
  }
}

struct FakeEmptyDataRequest: Request {
  typealias ResponseObject = EmptyResponse

  func build() -> URLRequest {
    return URLRequest(url: URL(string: "http://example.com")!)
  }
}
