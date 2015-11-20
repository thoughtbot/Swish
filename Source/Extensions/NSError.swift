import Foundation

public let NetworkErrorJSONKey = "com.thoughtbot.swish.errorJSON"

extension NSError {
  static func error(statusCode: Int, json: AnyObject, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) -> NSError {
    let domain = "com.thoughtbot.swish"

    let userInfo: [String: AnyObject] = [
      "\(domain).function": function,
      "\(domain).file": file,
      "\(domain).line": line,
      NSLocalizedDescriptionKey: messageForStatusCode(statusCode),
      NetworkErrorJSONKey: json
    ]

    return NSError(domain: domain, code: statusCode, userInfo: userInfo)
  }
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
