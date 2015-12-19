import Argo
import Result

public extension Result {
  static func fromDecoded<T>(decoded: Decoded<T>) -> Result<T, NSError> {
    switch decoded {
    case let .Success(obj):
      return .Success(obj)
    case let .Failure(decodedError):
      return .Failure(.error(decodedError.description))
    }
  }
}
