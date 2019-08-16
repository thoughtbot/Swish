import Swish

internal struct AnyRequestMatcher<T: Request>: RequestMatcher {
  func match<S>(_: S) -> Result<S.ResponseObject, SwishError>? where S: Request {
    return response as? Result<S.ResponseObject, SwishError>
  }

  let response: Result<T.ResponseObject, SwishError>
}
