import Foundation
import Result

public protocol Client {
  @discardableResult
  func perform<T: Request>(_ request: T, completionHandler: @escaping (Result<T.ResponseObject, SwishError>) -> ()) -> URLSessionDataTask
}
