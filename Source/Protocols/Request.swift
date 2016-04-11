import Foundation
import Argo
import Result

public typealias EmptyResponse = Void

public protocol Request {
  typealias ResponseObject
  typealias ResponseError: ErrorType = NSError
  func build() -> NSURLRequest
  func parse(j: JSON) -> Result<ResponseObject, SwishError>
  func transformError(error: SwishError) -> ResponseError
}

public extension Request where ResponseObject: Decodable, ResponseObject.DecodedType == ResponseObject {
  func parse(j: JSON) -> Result<ResponseObject, SwishError> {
    return .fromDecoded(ResponseObject.decode(j))
  }
}

public extension Request where ResponseObject: CollectionType, ResponseObject.Generator.Element: Decodable, ResponseObject.Generator.Element.DecodedType == ResponseObject.Generator.Element {
  func parse(j: JSON) -> Result<[ResponseObject.Generator.Element], SwishError> {
    return .fromDecoded(ResponseObject.decode(j))
  }
}

public extension Request where ResponseObject == EmptyResponse {
  func parse(j: JSON) -> Result<ResponseObject, SwishError> {
    return .Success()
  }
}

public extension Request where ResponseError == NSError {
  func transformError(error: SwishError) -> ResponseError {
    return error.NSError
  }
}
