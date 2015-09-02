import Foundation

class FakeDataTask: NSURLSessionDataTask {
  var resumedTask = false

  override func resume() {
    resumedTask = true
  }
}
