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
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
    return try JSONDecoder().decode(ResponseObject.self, from: data)
  }
}

public extension Request where ResponseObject == EmptyResponse {
  func parse(_ data: Data) throws -> ResponseObject {
  }
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
