import Swish

internal struct AnyRequestMatcher<T: Request>: RequestMatcher {
  func match<S>(_ request: S) -> Result<S.ResponseObject, SwishError>? where S: Request {
    return self.response as? Result<S.ResponseObject, SwishError>
  }

  let response: Result<T.ResponseObject, SwishError>
}
