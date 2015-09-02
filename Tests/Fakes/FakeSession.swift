import Foundation

class FakeSession: NSURLSession {
  var providedRequest = NSURLRequest()
  var dataTask = FakeDataTask()

  private let data: NSData?
  private let response: NSURLResponse?
  private let error: NSError?

  var performedRequest: Bool {
    return dataTask.resumedTask
  }

  init(data: NSData? = .None, response: NSURLResponse? = .None, error: NSError? = .None) {
    self.data = data
    self.response = response
    self.error = error
    super.init()
  }

  override func dataTaskWithRequest(request: NSURLRequest, completionHandler: ((NSData?, NSURLResponse?, NSError?) -> Void)?) -> NSURLSessionDataTask {
    providedRequest = request
    dataTask = FakeDataTask()
    completionHandler?(data, response, error)
    return dataTask
  }
}
