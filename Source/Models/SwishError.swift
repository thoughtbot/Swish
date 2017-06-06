import Foundation

public enum SwishError {
  case decodeError(Error)
  case deserializationError(Error)
  case parseError(Error)
  case serverError(code: Int, data: Data?)
  case urlSessionError(Error, response: HTTPURLResponse?)
}

extension SwishError: Error { }

extension SwishError: CustomNSError {
  public static let errorDomain = "com.thoughtbot.swish"

  public var errorCode: Int {
    switch self {
    case .decodeError:
      return 1
    case .deserializationError:
      return 2
    case .parseError:
      return 3
    case .serverError:
      return 4
    case .urlSessionError:
      return 5
    }
  }

#if !swift(>=3.1)
  public var errorUserInfo: [String: Any] {
    var userInfo: [String: Any] = [:]
    userInfo[NSLocalizedDescriptionKey] = errorDescription
    return userInfo
  }
#endif
}

extension SwishError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case let .serverError(code, _):
      return message(forStatus: code)

    case let .decodeError(error),
         let .deserializationError(error),
         let .parseError(error),
         let .urlSessionError(error, _):
      return (error as? LocalizedError)?.errorDescription
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
