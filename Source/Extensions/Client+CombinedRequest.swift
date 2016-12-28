import Result

extension Client {
  @discardableResult
  public func perform<A: Request, B: Request>(_ requestA: A, _ requestB: B, completionHandler: @escaping (Result<(A.ResponseObject, B.ResponseObject), SwishError>) -> Void) -> Cancelable {
    return CombinedRequest(requestA, requestB, client: self)
      .perform(completionHandler: completionHandler)
  }
}
