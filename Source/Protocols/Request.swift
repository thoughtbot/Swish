import Foundation
import Result

public typealias EmptyResponse = Void

public protocol Request {
  associatedtype ResponseObject

  func build() -> URLRequest
  func parse(_ data: Data) throws -> ResponseObject
}

public extension Request where ResponseObject: Decodable {
  func parse(_ data: Data) throws -> ResponseObject {
    return try JSONDecoder().decode(ResponseObject.self, from: data)
  }
}

public extension Request where ResponseObject == EmptyResponse {
  func parse(_ data: Data) throws -> ResponseObject {
  }
}
