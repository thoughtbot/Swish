import Foundation

extension NSError {
  static func error(message: String?, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) -> NSError {
    let domain = "com.thoughtbot.swish"

    var userInfo: [String: AnyObject] = [
      "\(domain).function": function,
      "\(domain).file": file,
      "\(domain).line": line,
    ]

    if let message = message {
      userInfo[NSLocalizedDescriptionKey] = message
    }

    return NSError(domain: domain, code: 0, userInfo: userInfo)
  }
}
