import Foundation
import Swish
import Argo
import Result

struct FakeRequest: Request {
  typealias ResponseObject = String

  func build() -> NSURLRequest {
    return NSURLRequest(URL: NSURL(string: "http://example.com")!)
  }

  func parse(j: JSON) -> Result<String, NSError> {
    return .fromDecoded(j <| "text")
  }
}

struct FakeEmptyDataRequest: Request {
  typealias ResponseObject = EmptyResponse

  func build() -> NSURLRequest {
    return NSURLRequest(URL: NSURL(string: "http://example.com")!)
  }
}
