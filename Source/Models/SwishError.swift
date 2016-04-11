import Foundation
import Argo

public enum SwishError {
  case ArgoError(Argo.DecodeError)
  case InvalidJSONResponse(Foundation.NSError)
  case ServerError(code: Int, json: AnyObject)
  case URLSessionError(Foundation.NSError)
}

extension SwishError: ErrorType { }

public extension SwishError {
  var NSError: Foundation.NSError {
    switch self {
    case let .URLSessionError(e):
      return e
    case let .InvalidJSONResponse(e):
      return e
    case let .ServerError(code, json):
      return .error(code, json: json)
    case let .ArgoError(e):
      return e as Foundation.NSError
    }
  }
}
