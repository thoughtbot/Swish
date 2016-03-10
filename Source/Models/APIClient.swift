import Foundation
import Argo
import Result

public struct APIClient {
  private let requestPerformer: RequestPerformer
  private let deserializer: Deserializer

  public init(requestPerformer: RequestPerformer = NetworkRequestPerformer(), deserializer: Deserializer = JSONDeserializer()) {
    self.requestPerformer = requestPerformer
    self.deserializer = deserializer
  }
}

extension APIClient: Client {
  public func performRequest<T: Request>(request: T, completionHandler: Result<T.ResponseObject, SwishError> -> Void) -> NSURLSessionDataTask {
    return requestPerformer.performRequest(request.build()) { result in
      let object = result
        >>- self.validateResponse
        >>- self.deserializer.deserialize
        >>- T.ResponseParser.parse
        >>- request.parse

      onMain { completionHandler(object) }
    }
  }
}

private extension APIClient {
  func validateResponse(httpResponse: HTTPResponse) -> Result<NSData?, SwishError> {
    switch httpResponse.code {
    case (200...299):
      return .Success(httpResponse.data)
    default:
      return .Failure(.ServerError(code: httpResponse.code, data: httpResponse.data))
    }
  }
}
