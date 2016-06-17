import Foundation

class FakeSession: URLSession {
  var providedRequest = URLRequest()
  var dataTask = FakeDataTask()

  private let data: Data?
  private let response: URLResponse?
  private let error: NSError?

  var performedRequest: Bool {
    return dataTask.resumedTask
  }

  init(data: Data? = .none, response: URLResponse? = .none, error: NSError? = .none) {
    self.data = data
    self.response = response
    self.error = error
    super.init()
  }

  override func dataTask(with request: URLRequest, completionHandler: ((Data?, URLResponse?, NSError?) -> Void)?) -> URLSessionDataTask {
    providedRequest = request
    dataTask = FakeDataTask()
    completionHandler?(data, response, error)
    return dataTask
  }
}
