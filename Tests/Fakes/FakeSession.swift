import Foundation

class FakeSession: URLSession {
  var providedRequest = URLRequest(url: URL(string: "https://example.com")!)
  var dataTask = FakeDataTask()

  fileprivate let data: Data?
  fileprivate let response: URLResponse?
  fileprivate let error: Error?

  var performedRequest: Bool {
    return dataTask.resumedTask
  }

  init(data: Data? = .none, response: URLResponse? = .none, error: Error? = .none) {
    self.data = data
    self.response = response
    self.error = error
    super.init()
  }

  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    providedRequest = request
    dataTask = FakeDataTask()
    completionHandler(data, response, error)
    return dataTask
  }
}
