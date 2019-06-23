import Foundation

internal protocol RequestMatcher {
  func match<T: Request>(_ request: T) -> Result<T.ResponseObject, SwishError>?
}
