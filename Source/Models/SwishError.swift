import Foundation
import Argo

public enum SwishError {
  case argoError(Argo.DecodeError)
  case deserializationError(Error)
  case parseError(Error)
  case serverError(code: Int, data: Data?)
  case urlSessionError(Error)
}

extension SwishError: Error { }

extension SwishError: CustomNSError {
  public static let errorDomain = "com.thoughtbot.swish"
}

extension SwishError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case let .serverError(code, _):
      return message(forStatus: code)

    case let .deserializationError(error),
         let .parseError(error),
         let .urlSessionError(error):
      return (error as? LocalizedError)?.errorDescription

    case let .argoError(localizedError as LocalizedError):
      return localizedError.errorDescription

    case let .argoError(error):
      return String(describing: error)
    }
  }
}

private func message(forStatus code: Int) -> String {
  switch code {
  case 300...399:
    return "Multiple choices: \(code)"
  case 400...499:
    return "Bad request: \(code)"
  case 500...599:
    return "Server error: \(code)"
  default:
    return "Unknown error: \(code)"
  }
}
