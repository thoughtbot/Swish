import Swish

internal struct EqRequestMatcher<T: Request>: RequestMatcher where T: Equatable {
  func match<S>(_ request: S) -> Result<S.ResponseObject, SwishError>? where S: Request {
    if S.self == T.self,
      let request = request as? T,
      self.request == request {
      return self.response as? Result<S.ResponseObject, SwishError>
    } else {
      return .none
    }
  }

  let request: T
  let response: Result<T.ResponseObject, SwishError>
}
