import Foundation
import Argo
import Result

public protocol Client {
  var scheduler: Scheduler { get }

  @discardableResult
  func perform<T: Request>(_ request: T, completionHandler: @escaping (Result<T.ResponseObject, SwishError>) -> ()) -> URLSessionDataTask
}

extension Client {
  public var scheduler: Scheduler {
    return mainQueueScheduler
  }
}
