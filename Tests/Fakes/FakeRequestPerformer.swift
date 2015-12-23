import Foundation
@testable import Swish
import Result

func serializeJSON(j: [String: AnyObject]) -> NSData? {
  return try? NSJSONSerialization
    .dataWithJSONObject(j, options: NSJSONWritingOptions(rawValue: 0))
}

enum ResponseData {
  case Data(NSData?)
  case JSON([String: AnyObject])
}

extension ResponseData {
  var data: NSData? {
    switch self {
    case let .Data(d): return d
    case let .JSON(j): return serializeJSON(j)
    }
  }
}

class FakeRequestPerformer: RequestPerformer {
  let statusCode: Int
  let data: NSData?
  var passedRequest: NSURLRequest?

  init(responseData: ResponseData, statusCode: Int = 200) {
    self.data = responseData.data
    self.statusCode = statusCode
  }

  func performRequest(request: NSURLRequest, completionHandler: Result<HTTPResponse, NSError> -> Void) -> NSURLSessionDataTask {
    passedRequest = request

    let response = request.URL.flatMap {
      NSHTTPURLResponse(URL: $0, statusCode: statusCode, HTTPVersion: .None, headerFields: .None)
    }

    completionHandler(
      .Success(HTTPResponse(data: data, response: response))
    )

    return NSURLSessionDataTask()
  }
}
