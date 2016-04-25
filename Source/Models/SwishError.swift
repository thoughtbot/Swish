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

extension SwishError: Equatable { }

public func == (lhs: SwishError, rhs: SwishError) -> Bool {
  switch (lhs, rhs) {
  case let (.ArgoError(l), .ArgoError(r)):
    return l == r
  case let (.InvalidJSONResponse(l), .InvalidJSONResponse(r)):
    return l == r
  case let (.ServerError(lCode, lJSON), .ServerError(rCode, rJSON)):
    return lCode == rCode && JSON(lJSON) == JSON(rJSON)
  case let (.URLSessionError(l), .URLSessionError(r)):
    return l == r
  default:
    return false
  }
}
