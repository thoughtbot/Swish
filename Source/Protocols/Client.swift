import Foundation
import Argo
import Result

public protocol Client {
  func performRequest<T: Request>(request: T, completionHandler: Result<T.ResponseObject, NSError> -> ()) -> NSURLSessionDataTask
}
