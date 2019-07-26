import Swish

internal struct PredicateRequestMatcher<T: Request>: RequestMatcher {
  func match<S>(_ request: S) -> Result<S.ResponseObject, SwishError>? where S: Request {
    if S.self == T.self,
      let request = request as? T {
      return self.matchFunction(request) as? Result<S.ResponseObject, SwishError>
    } else {
      return .none
    }
  }

  let matchFunction: (T) -> Result<T.ResponseObject, SwishError>?
}
