import Foundation
import Swish
import Argo
import Result

struct FakeRequest: Request {
  typealias ResponseType = String

  func build() -> NSURLRequest {
    return NSURLRequest(URL: NSURL(string: "http://example.com")!)
  }

  func parse(j: JSON) -> Result<String, NSError> {
    return .fromDecoded(j <| "text")
  }
}

struct FakeNullDataRequest: Request {
  typealias ResponseType = ()

  func build() -> NSURLRequest {
    return NSURLRequest(URL: NSURL(string: "http://example.com")!)
  }

  func parse(j: JSON) -> Result<(), NSError> {
    switch j {
    case JSON.Null: return Result.Success(())
    default:
      return Result.Failure(Result<(), NSError>.error())
    }
  }
}
