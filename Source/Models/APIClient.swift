import Foundation
import Argo
import Result

public struct APIClient {
  private let requestPerformer: RequestPerformer

  public init(requestPerformer: RequestPerformer = NetworkRequestPerformer()) {
    self.requestPerformer = requestPerformer
  }
}

extension APIClient: Client {
  public func performRequest<T: Request>(request: T, completionHandler: Result<T.ResponseType, NSError> -> Void) {
    requestPerformer.performRequest(request.build()) { result in
      let object = result >>- deserialize >>- request.parse
      onMain { completionHandler(object) }
    }
  }
}

private func deserialize(response: HTTPResponse) -> Result<JSON, NSError> {
  switch response.code {
  case 200...299:
    return parseJSON(response)
  case 300...399:
    return .Failure(.error("Multiple choices: \(response.code)"))
  case 400...499:
    return .Failure(.error("Bad request: \(response.code)"))
  case 500...599:
    return .Failure(.error("Server error: \(response.code)"))
  default:
    return .Failure(.error("Unknown error: \(response.code)"))
  }
}

private func parseJSON(response: HTTPResponse) -> Result<JSON, NSError> {
  guard let data = response.data where data.length > 0 else {
    return .Success(JSON.Null)
  }

  do {
    let object = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
    return .Success(JSON.parse(object))
  } catch let error as NSError {
    return .Failure(error)
  }
}
