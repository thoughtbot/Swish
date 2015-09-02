import Foundation
@testable import Swish
import Result

class FakeRequestPerformer: RequestPerformer {
  let returnedJSON: [String: AnyObject]?
  var passedRequest: NSURLRequest?

  init(returnedJSON: [String: AnyObject]? = .None) {
    self.returnedJSON = returnedJSON
  }

  func performRequest(request: NSURLRequest, completionHandler: Result<HTTPResponse, NSError> -> Void) {
    passedRequest = request
    let data = returnedJSON.flatMap {
      try? NSJSONSerialization.dataWithJSONObject($0, options: NSJSONWritingOptions(rawValue: 0))
    }

    let result: Result<HTTPResponse, NSError> = .Success(HTTPResponse(data: data, response: .None))

    completionHandler(result)
  }
}
