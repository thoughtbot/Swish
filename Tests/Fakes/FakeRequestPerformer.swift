import Foundation
@testable import Swish
import Result

func serializeJSON(_ j: [String: AnyObject]) -> Data? {
  return try? JSONSerialization
    .data(withJSONObject: j, options: JSONSerialization.WritingOptions(rawValue: 0))
}

enum ResponseData {
  case data(Data?)
  case json([String: AnyObject])
}

extension ResponseData {
  var data: Foundation.Data? {
    switch self {
    case let .data(d): return d
    case let .json(j): return serializeJSON(j)
    }
  }
}

class FakeRequestPerformer: RequestPerformer {
  let statusCode: Int
  let data: Data?
  let background: Bool
  var passedRequest: URLRequest?

  init(responseData: ResponseData, statusCode: Int = 200, background: Bool = false) {
    self.data = responseData.data
    self.statusCode = statusCode
    self.background = background
  }

  func performRequest(_ request: URLRequest, completionHandler: (Result<HTTPResponse, SwishError>) -> Void) -> URLSessionDataTask {
    passedRequest = request

    let response = request.url.flatMap {
      HTTPURLResponse(url: $0, statusCode: statusCode, httpVersion: .none, headerFields: .none)
    }

    let complete = { [data] in
      completionHandler(
        .Success(HTTPResponse(data: data, response: response))
      )
    }

    if background {
      dispatch_get_global_queue(DispatchQueue.GlobalAttributes.qosDefault, 0).async(execute: complete)
    } else {
      complete()
    }

    return NSURLSessionDataTask()
  }
}
