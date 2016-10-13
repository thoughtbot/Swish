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

extension SwishError: Equatable { }

public func == (lhs: SwishError, rhs: SwishError) -> Bool {
  switch (lhs, rhs) {
  case let (.argoError(l), .argoError(r)):
    return l == r
  case let (.parseError(l), .parseError(r)):
    return l == r
  case let (.deserializationError(l), .deserializationError(r)):
    return l == r
  case let (.serverError(lCode, lData), .serverError(rCode, rData)):
    return lCode == rCode && lData == rData
  case let (.urlSessionError(l), .urlSessionError(r)):
    return l == r
  default:
    return false
  }
}
