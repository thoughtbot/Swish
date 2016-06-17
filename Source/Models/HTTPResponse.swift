import Foundation

public struct HTTPResponse {
  public let data: Data?
  public let code: Int

  public init(data: Data?, response: URLResponse?) {
    self.data = data
    self.code = (response as? HTTPURLResponse)?.statusCode ?? 500
  }
}
