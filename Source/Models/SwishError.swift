import Foundation
import Argo

public enum SwishError {
  case argoError(Argo.DecodeError)
  case deserializationError(NSError)
  case parseError(NSError)
  case serverError(code: Int, data: Data?)
  case urlSessionError(NSError)
}

extension SwishError: Error { }

public extension SwishError {
  var rawError: NSError {
    switch self {
    case let .urlSessionError(e):
      return e
    case let .parseError(e):
      return e
    case let .deserializationError(e):
      return e
    case let .serverError(code, json):
      return .error(code, data: json)
    case let .argoError(e):
      return .error(String(describing: e))
    }
  }
}
