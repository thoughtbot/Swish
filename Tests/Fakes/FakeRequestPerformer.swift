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
  let background: Bool
  var passedRequest: NSURLRequest?

  init(responseData: ResponseData, statusCode: Int = 200, background: Bool = false) {
    self.data = responseData.data
    self.statusCode = statusCode
    self.background = background
  }

  func performRequest(request: NSURLRequest, completionHandler: Result<HTTPResponse, SwishError> -> Void) -> NSURLSessionDataTask {
    passedRequest = request

    let response = request.URL.flatMap {
      NSHTTPURLResponse(URL: $0, statusCode: statusCode, HTTPVersion: .None, headerFields: .None)
    }

    let complete = { [data] in
      completionHandler(
        .Success(HTTPResponse(data: data, response: response))
      )
    }

    if background {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), complete)
    } else {
      complete()
    }

    return NSURLSessionDataTask()
  }
}
