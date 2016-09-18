import Argo
import Result

public extension Result {
  static func fromDecoded<T>(_ decoded: Decoded<T>) -> Result<T, SwishError> {
    switch decoded {
    case let .success(obj):
      return .success(obj)
    case let .failure(error):
      return .failure(.argoError(error))
    }
  }
}
