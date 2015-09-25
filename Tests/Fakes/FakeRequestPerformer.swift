import Foundation
@testable import Swish
import Result

class FakeRequestPerformer: RequestPerformer {
  let returnedJSON: [String: AnyObject]?
  let statusCode: Int
  var passedRequest: NSURLRequest?

  init(returnedJSON: [String: AnyObject]? = .None, statusCode: Int = 200) {
    self.returnedJSON = returnedJSON
    self.statusCode = statusCode
  }

  func performRequest(request: NSURLRequest, completionHandler: Result<HTTPResponse, NSError> -> Void) {
    passedRequest = request
    let data = returnedJSON.flatMap {
      try? NSJSONSerialization.dataWithJSONObject($0, options: NSJSONWritingOptions(rawValue: 0))
    }

    var response: NSHTTPURLResponse? = .None
    if let url = request.URL {
      response = NSHTTPURLResponse(URL: url, statusCode: statusCode, HTTPVersion: .None, headerFields: .None)
    }

    let result: Result<HTTPResponse, NSError> = .Success(HTTPResponse(data: data, response: response))

    completionHandler(result)
  }
}
