import Foundation
@testable import Swish
import Result

enum ResponseData {
  case data(Data?)
  case json(Any)
}

extension ResponseData {
  var data: Data? {
    switch self {
    case let .data(d): return d
    case let .json(j): return try? JSONSerialization.data(withJSONObject: j)
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

  @discardableResult
  func perform(_ request: URLRequest, completionHandler: @escaping (Result<HTTPResponse, SwishError>) -> Void) -> URLSessionDataTask {
    passedRequest = request

    let response = request.url.flatMap {
      HTTPURLResponse(url: $0, statusCode: statusCode, httpVersion: .none, headerFields: .none)
    }

    let complete = { [data] in
      completionHandler(
        .success(HTTPResponse(data: data, response: response))
      )
    }

    if background {
      DispatchQueue.global().async(execute: complete)
    } else {
      complete()
    }

    return URLSessionDataTask()
  }
}
