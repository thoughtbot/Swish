import Foundation
import Result

public protocol RequestPerformer {
  @discardableResult
  func perform(request: URLRequest, completionHandler: @escaping (Result<HTTPResponse, SwishError>) -> Void)-> URLSessionDataTask
}
