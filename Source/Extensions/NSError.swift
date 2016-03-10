import Foundation

private let swishDomain = "com.thoughtbot.swish"

public let NetworkErrorDataKey = swishDomain + ".errorData"

extension NSError {
  static func error(message: String, function: String = #function, file: String = #file, line: Int = #line) -> NSError {
    var info = userInfoFor(function, file, line)

    info[NSLocalizedDescriptionKey] = message

    return NSError(domain: swishDomain, code: 0, userInfo: info)
  }

  static func error(statusCode: Int, data: AnyObject?, function: String = #function, file: String = #file, line: Int = #line) -> NSError {
    var info = userInfoFor(function, file, line)

    info[NSLocalizedDescriptionKey] = messageForStatusCode(statusCode)
    info[NetworkErrorDataKey] = data

    return NSError(domain: swishDomain, code: statusCode, userInfo: info)
  }
}

private func userInfoFor(function: String, _ file: String, _ line: Int) -> [String: AnyObject] {
  return [
    "\(swishDomain).function": function,
    "\(swishDomain).file": file,
    "\(swishDomain).line": line,
  ]
}

private func messageForStatusCode(code: Int) -> String {
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
