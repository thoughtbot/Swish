import Foundation
import Result

public struct APIClient {
  fileprivate let requestPerformer: RequestPerformer
  fileprivate let scheduler: Scheduler

  public init(requestPerformer: RequestPerformer = NetworkRequestPerformer(), scheduler: @escaping Scheduler = mainQueueScheduler) {
    self.requestPerformer = requestPerformer
    self.scheduler = scheduler
  }
}

extension APIClient: Client {
  @discardableResult
  public func perform<T: Request>(_ request: T, completionHandler: @escaping (Result<T.ResponseObject, SwishError>) -> Void) -> URLSessionDataTask {
    return requestPerformer.perform(request.build()) { [schedule = scheduler] result in
      let object = result
        .flatMap(self.validate)
        .flatMap(request.parse)

      schedule { completionHandler(object) }
    }
  }
}

private extension APIClient {
  func validate(_ httpResponse: HTTPResponse) -> Result<Data, SwishError> {
    switch httpResponse.code {
    case (200...299):
      return .success(httpResponse.data)
    default:
      return .failure(.serverError(code: httpResponse.code, data: httpResponse.data))
    }
  }
}
