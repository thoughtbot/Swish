import Argo
import Result

public extension Result {
  static func fromDecoded<T>(decoded: Decoded<T>) -> Result<T, NSError> {
    switch decoded {
    case let .Success(obj): return .Success(obj)
    case .TypeMismatch, .MissingKey:
      return .Failure(error(decoded.description))
    }
  }
}
