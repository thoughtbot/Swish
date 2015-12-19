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
  public func performRequest<T: Request>(request: T, completionHandler: Result<T.ResponseObject, NSError> -> Void) -> NSURLSessionDataTask {
    return requestPerformer.performRequest(request.build()) { result in
      let object = result >>- deserialize >>- request.parse
      onMain { completionHandler(object) }
    }
  }
}

private func deserialize(response: HTTPResponse) -> Result<JSON, NSError> {
  let json = parseJSON(response)

  switch (response.code, json) {

  case let (_, .Failure(e)):
    return .Failure(e)

  case let (200...299, .Success(j)):
    return .Success(JSON.parse(j))

  case let (code, .Success(j)):
    return .Failure(.error(code, json: j))
  }
}

private func parseJSON(response: HTTPResponse) -> Result<AnyObject, NSError> {
  guard let data = response.data where data.length > 0 else {
    return .Success(NSNull())
  }

  return Result(
    try NSJSONSerialization
      .JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
  )
}
