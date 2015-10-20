import Foundation
import Argo
import Result

public typealias EmptyResponse = Void

public protocol Request {
  typealias ResponseType
  func build() -> NSURLRequest
  func parse(j: JSON) -> Result<ResponseType, NSError>
}

public extension Request where ResponseType: Decodable, ResponseType.DecodedType == ResponseType {
  func parse(j: JSON) -> Result<ResponseType, NSError> {
    return .fromDecoded(ResponseType.decode(j))
  }
}

public extension Request where ResponseType: CollectionType, ResponseType.Generator.Element: Decodable, ResponseType.Generator.Element.DecodedType == ResponseType.Generator.Element {
  func parse(j: JSON) -> Result<[ResponseType.Generator.Element], NSError> {
    return .fromDecoded(ResponseType.decode(j))
  }
}

public extension Request where ResponseType == EmptyResponse {
  func parse(j: JSON) -> Result<ResponseType, NSError> {
    return .Success()
  }
}
