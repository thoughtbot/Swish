import Foundation

public struct HTTPResponse {
  public let data: NSData?
  public let code: Int

  public init(data: NSData?, response: NSURLResponse?) {
    self.data = data
    self.code = (response as? NSHTTPURLResponse)?.statusCode ?? 500
  }
}
