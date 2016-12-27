import Argo
import Foundation
import Result

extension Client {
  @available(*, unavailable, renamed: "perform(_:completionHandler:)")
  func performRequest<T: Request>(_: T, completionHandler _: @escaping (Result<T.ResponseObject, SwishError>) -> ()) -> URLSessionDataTask {
    fatalError("unavailable")
  }
}

extension RequestPerformer {
  @available(*, unavailable, renamed: "perform(_:completionHandler:)")
  public func performRequest(_: URLRequest, completionHandler _: @escaping (Result<HTTPResponse, SwishError>) -> Void) -> URLSessionDataTask {
    fatalError("unavailable")
  }
}

extension Result {
  @available(*, unavailable, renamed: "Result.init(_:)")
  public static func fromDecoded(_: Decoded<T>) -> Result<T, SwishError> {
    fatalError("unavailable")
  }
}
