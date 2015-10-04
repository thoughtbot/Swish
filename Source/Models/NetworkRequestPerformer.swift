import Foundation
import Result

public struct NetworkRequestPerformer: RequestPerformer {
  private let session: NSURLSession

  init(session: NSURLSession = NSURLSession.sharedSession()) {
    self.session = session
  }
}

public extension NetworkRequestPerformer {
  func performRequest(request: NSURLRequest, completionHandler: Result<HTTPResponse, NSError> -> Void) {
    session.dataTaskWithRequest(request) { data, response, error in
      if let error = error {
        completionHandler(.Failure(error))
      } else {
        let response = HTTPResponse(data: data, response: response)
        completionHandler(.Success(response))
      }
    }.resume()
  }
}
