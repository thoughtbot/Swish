import Foundation
import Result

public typealias EmptyResponse = Void

public protocol Request {
  associatedtype ResponseObject

  func build() -> URLRequest
  func parse(_ data: Data) -> Result<ResponseObject, SwishError>
}

public extension Request where ResponseObject: Decodable {
  func parse(_ data: Data) -> Result<ResponseObject, SwishError> {
    let decoder = JSONDecoder()
    let result = Result<ResponseObject, AnyError>(try decoder.decode(ResponseObject.self, from: data))
    return result.mapError { SwishError.decodeError($0.error) }
  }
}

public extension Request where ResponseObject == EmptyResponse {
  func parse(_ data: Data) -> Result<ResponseObject, SwishError> {
    return .success(())
  }
}
