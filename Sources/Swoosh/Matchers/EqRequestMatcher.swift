import Swish

internal struct EqRequestMatcher<T: Request>: RequestMatcher where T: Equatable {
  func match<S>(_ request: S) -> Result<S.ResponseObject, SwishError>? where S: Request {
    return self.response as? Result<S.ResponseObject, SwishError>
  }

  let request: T
  let response: Result<T.ResponseObject, SwishError>
}
