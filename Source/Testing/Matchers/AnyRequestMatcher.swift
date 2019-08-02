internal struct AnyRequestMatcher<T: Request>: RequestMatcher {
  func match<S>(_: S) -> Result<S.ResponseObject, SwishError>? where S: Request {
    if S.self == T.self {
      return response as? Result<S.ResponseObject, SwishError>
    } else {
      return .none
    }
  }

  let response: Result<T.ResponseObject, SwishError>
}
