import Foundation

class FakeDataTask: URLSessionDataTask {
  var resumedTask = false

  override func resume() {
    resumedTask = true
  }
}
