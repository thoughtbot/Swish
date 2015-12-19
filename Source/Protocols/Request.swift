import Foundation
import Argo
import Result

public typealias EmptyResponse = Void

public protocol Request {
  typealias ResponseObject
  func build() -> NSURLRequest
  func parse(j: JSON) -> Result<ResponseObject, NSError>
}

public extension Request where ResponseObject: Decodable, ResponseObject.DecodedType == ResponseObject {
  func parse(j: JSON) -> Result<ResponseObject, NSError> {
    return .fromDecoded(ResponseObject.decode(j))
  }
}

public extension Request where ResponseObject: CollectionType, ResponseObject.Generator.Element: Decodable, ResponseObject.Generator.Element.DecodedType == ResponseObject.Generator.Element {
  func parse(j: JSON) -> Result<[ResponseObject.Generator.Element], NSError> {
    return .fromDecoded(ResponseObject.decode(j))
  }
}

public extension Request where ResponseObject == EmptyResponse {
  func parse(j: JSON) -> Result<ResponseObject, NSError> {
    return .Success()
  }
}
