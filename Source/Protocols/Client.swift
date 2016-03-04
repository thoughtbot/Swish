import Foundation
import Argo
import Result

/// An abstract API client.
public protocol Client {
  /**
    Perform the specified request and call the completion block appropriately.

    This is intended to be an abstraction layer on top of `RequestPerformer`
    that is able to perform additional transformations such as JSON
    deserialization and error transformation. It also handles building
    instances of `NSURLRequest` from the `Request` instance, as well as passing
    the response `JSON` to the `Request`'s `parse` method.

    - parameter request: The `Request` to be performed.
    - parameter completionHandler: The closure to call when the request is complete.

    - returns: An instance of `NSURLSessionDataTask` that represents the
               request being performed.
  */
  func performRequest<T: Request>(request: T, completionHandler: Result<T.ResponseObject, NSError> -> ()) -> NSURLSessionDataTask
}
