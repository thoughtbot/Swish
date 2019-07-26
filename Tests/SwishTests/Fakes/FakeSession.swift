import Foundation

class FakeSession: URLSession {
  var providedRequest = URLRequest(url: URL(string: "https://example.com")!)
  var dataTask = FakeDataTask()

  fileprivate let data: Data?
  fileprivate let response: HTTPURLResponse?
  fileprivate let error: Error?

  var performedRequest: Bool {
    return dataTask.resumedTask
  }

  init(data: Data, response: HTTPURLResponse) {
    self.data = data
    self.response = response
    self.error = nil
    super.init()
  }

  init(error: Error) {
    self.data = nil
    self.response = nil
    self.error = error
    super.init()
  }

  convenience override init() {
    self.init(data: Data(), response: HTTPURLResponse())
  }

  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    providedRequest = request
    dataTask = FakeDataTask()
    completionHandler(data, response, error)
    return dataTask
  }
}
