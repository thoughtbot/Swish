import Foundation
import Argo
import Result

public protocol Client {
  func performRequest<T: Request>(_ request: T, completionHandler: @escaping (Result<T.ResponseObject, SwishError>) -> ()) -> URLSessionDataTask
}
