import Foundation
import Argo
import Result

public protocol Request {
  typealias ResponseType
  func build() -> NSURLRequest
  func parse(j: JSON) -> Result<ResponseType, NSError>
}

extension Request where ResponseType: Decodable, ResponseType.DecodedType == ResponseType {
  func parse(j: JSON) -> Result<ResponseType, NSError> {
    return .fromDecoded(ResponseType.decode(j))
  }
}
