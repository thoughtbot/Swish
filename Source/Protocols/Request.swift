import Foundation
import Argo
import Result

public typealias EmptyResponse = Void

public protocol Request {
  associatedtype ResponseObject
  associatedtype ResponseParser: Parser = JSON

  func build() -> URLRequest
  func parse(_ j: ResponseParser.Representation) -> Result<ResponseObject, SwishError>
}

public extension Request where ResponseObject: Decodable, ResponseObject.DecodedType == ResponseObject {
  func parse(_ j: JSON) -> Result<ResponseObject, SwishError> {
    return .fromDecoded(ResponseObject.decode(j))
  }
}

public extension Request where ResponseObject: Collection, ResponseObject.Iterator.Element: Decodable, ResponseObject.Iterator.Element.DecodedType == ResponseObject.Iterator.Element {
  func parse(_ j: JSON) -> Result<[ResponseObject.Iterator.Element], SwishError> {
    return .fromDecoded(ResponseObject.decode(j))
  }
}

public extension Request where ResponseObject == EmptyResponse {
  func parse(_ j: JSON) -> Result<ResponseObject, SwishError> {
    return .Success()
  }
}
