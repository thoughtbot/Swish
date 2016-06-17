import Foundation
import Result

public struct NetworkRequestPerformer: RequestPerformer {
  private let session: URLSession

  public init(session: URLSession = URLSession.shared()) {
    self.session = session
  }
}

public extension NetworkRequestPerformer {
  func performRequest(_ request: URLRequest, completionHandler: (Result<HTTPResponse, SwishError>) -> Void) -> URLSessionDataTask {
    let task = session.dataTask(with: request) { data, response, error in
      if let error = error {
        completionHandler(.Failure(.urlSessionError(error)))
      } else {
        let response = HTTPResponse(data: data, response: response)
        completionHandler(.Success(response))
      }
    }

    task.resume()
    return task
  }
}
