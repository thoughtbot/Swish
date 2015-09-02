import Foundation
import Argo
import Result

public protocol Request {
  typealias ResponseType
  func build() -> NSURLRequest
  func parse(j: JSON) -> Result<ResponseType, NSError>
}
