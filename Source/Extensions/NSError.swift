import Foundation

private let swishDomain = "com.thoughtbot.swish"

public let NetworkErrorJSONKey = swishDomain + ".errorJSON"

extension NSError {
  static func error(message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) -> NSError {
    var info = userInfoFor(function, file, line)

    info[NSLocalizedDescriptionKey] = message

    return NSError(domain: swishDomain, code: 0, userInfo: info)
  }

  static func error(statusCode: Int, json: AnyObject, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) -> NSError {
    var info = userInfoFor(function, file, line)

    info[NSLocalizedDescriptionKey] = messageForStatusCode(statusCode)
    info[NetworkErrorJSONKey] = json

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
