import Argo
import Result

public extension ResultProtocol where Error == SwishError {
  init(_ decoded: Decoded<Value>) {
    switch decoded {
    case let .success(obj):
      self.init(value: obj)
    case let .failure(error):
      self.init(error: .argoError(error))
    }
  }
}
