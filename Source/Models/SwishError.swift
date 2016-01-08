import Foundation
import Argo

public enum SwishError {
  case SessionError(NSError)
  case ServerError(code: Int, json: AnyObject)
  case JSONSerializationError(NSError)
  case ArgoError(DecodeError)
}

extension SwishError: ErrorType { }

public extension SwishError {
  var rawError: NSError {
    switch self {
    case let .SessionError(e):
      return e
    case let .JSONSerializationError(e):
      return e
    case let .ServerError(code, json):
      return .error(code, json: json)
    case let .ArgoError(e):
      return .error(String(e))
    }
  }
}
