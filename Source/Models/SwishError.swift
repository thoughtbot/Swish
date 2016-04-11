import Foundation
import Argo

public enum SwishError {
  case ArgoError(Argo.DecodeError)
  case InvalidJSONResponse(NSError)
  case ServerError(code: Int, json: AnyObject)
  case URLSessionError(NSError)
}

extension SwishError: ErrorType { }

public extension SwishError {
  var rawError: NSError {
    switch self {
    case let .URLSessionError(e):
      return e
    case let .InvalidJSONResponse(e):
      return e
    case let .ServerError(code, json):
      return .error(code, json: json)
    case let .ArgoError(e):
      return .error(String(e))
    }
  }
}
