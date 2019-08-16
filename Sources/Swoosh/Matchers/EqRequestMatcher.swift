import Swish

internal struct EqRequestMatcher<T: Request>: RequestMatcher where T: Equatable {
  func match<S>(_ request: S) -> Result<S.ResponseObject, SwishError>? where S: Request {
    if self.request == request as? T {
      return response as? Result<S.ResponseObject, SwishError>
    } else {
      return .none
    }
  }

  let request: T
  let response: Result<T.ResponseObject, SwishError>
}
