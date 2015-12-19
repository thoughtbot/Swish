import Foundation
import Result

/// An abstract object that is able to perform `NSURLRequest`s.
public protocol RequestPerformer {
  /**
    Perform the specified request and call the completion block appropriately.

    This is intended to be the lowest level object in the stack. It should only
    be a thin layer on top of `NSURLSession` that performs the specified
    `NSURLRequest`, and then cleans up the return value into a `Result` of
    `HTTPResponse` or `NSError`.

    - parameter request: The `NSURLRequest` to be performed.
    - parameter completionHandler: The closure to call when the request is complete.

    - returns: An instance of `NSURLSessionDataTask` that represents the
               request being performed.
  */
  func performRequest(request: NSURLRequest, completionHandler: Result<HTTPResponse, NSError> -> Void)-> NSURLSessionDataTask
}
