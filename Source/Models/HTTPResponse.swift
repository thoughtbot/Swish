import Foundation

public struct HTTPResponse {
  public let data: Data
  public let response: HTTPURLResponse

  public var code: Int {
    return response.statusCode
  }

  public init(data: Data, response: HTTPURLResponse) {
    self.data = data
    self.response = response
  }
}
