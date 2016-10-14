import Foundation
import Result

public struct NetworkRequestPerformer: RequestPerformer {
  fileprivate let session: URLSession

  public init(session: URLSession = .shared) {
    self.session = session
  }
}

public extension NetworkRequestPerformer {
  @discardableResult
  func perform(request: URLRequest, completionHandler: @escaping (Result<HTTPResponse, SwishError>) -> Void) -> URLSessionDataTask {
    let task = session.dataTask(with: request) { data, response, error in
      if let error = error {
        completionHandler(.failure(.urlSessionError(error as NSError)))
      } else {
        let response = HTTPResponse(data: data, response: response)
        completionHandler(.success(response))
      }
    }

    task.resume()
    return task
  }
}
