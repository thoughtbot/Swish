import Foundation

public typealias EmptyResponse = Void

public protocol Request {
  associatedtype ResponseObject

  func build() -> URLRequest
  func parse(_ data: Data) throws -> ResponseObject
}

public extension Request where ResponseObject: Decodable {
  func parse<Wrapped>(_ data: Data) throws -> ResponseObject where ResponseObject == Optional<Wrapped> {
    return try? JSONDecoder().decode(ResponseObject.self, from: data)
  }

  func parse<Wrapped>(_ data: Data) throws -> ResponseObject where ResponseObject == Wrapped {
    return try JSONDecoder().decode(ResponseObject.self, from: data)
  }
}

public extension Request where ResponseObject == EmptyResponse {
  func parse(_ data: Data) throws -> ResponseObject {
  }
}
