import Foundation

public protocol RequestPerformer {
  @discardableResult
  func perform(_ request: URLRequest, completionHandler: @escaping (Result<HTTPResponse, SwishError>) -> Void) -> URLSessionDataTask
}
