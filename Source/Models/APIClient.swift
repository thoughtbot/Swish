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
  public func performRequest<T: Request>(request: T, completionHandler: Result<T.ResponseObject, T.ResponseError> -> Void) -> NSURLSessionDataTask {
    return requestPerformer.performRequest(request.build()) { result in
      let object = (result >>- deserialize >>- request.parse).mapError(request.transformError)
      onMain { completionHandler(object) }
    }
  }
}

private func deserialize(response: HTTPResponse) -> Result<JSON, SwishError> {
  let json = parseJSON(response)

  switch (response.code, json) {

  case let (_, .Failure(e)):
    return .Failure(e)

  case let (200...299, .Success(j)):
    return .Success(JSON(j))

  case let (code, .Success(j)):
    return .Failure(.ServerError(code: code, json: j))
  }
}

private func parseJSON(response: HTTPResponse) -> Result<AnyObject, SwishError> {
  guard let data = response.data where data.length > 0 else {
    return .Success(NSNull())
  }

  let result = materialize(
    try NSJSONSerialization
      .JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
  )

  return result.mapError(SwishError.InvalidJSONResponse)
}
