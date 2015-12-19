import Foundation
import Result

public protocol RequestPerformer {
  func performRequest(request: NSURLRequest, completionHandler: Result<HTTPResponse, NSError> -> Void)-> NSURLSessionDataTask
}
