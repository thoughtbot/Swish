import Argo
import Result

public extension Result {
  static func fromDecoded<T>(_ decoded: Decoded<T>) -> Result<T, SwishError> {
    switch decoded {
    case let .Success(obj):
      return .Success(obj)
    case let .Failure(error):
      return .Failure(.argoError(error))
    }
  }
}
