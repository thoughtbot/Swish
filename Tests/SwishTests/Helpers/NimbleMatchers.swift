import Nimble

public func beVoid() -> Predicate<Void> {
  return Predicate { (expr) -> PredicateResult in
    let message = ExpectationMessage.expectedActualValueTo("equal ()")
    let actualValue: Void? = try expr.evaluate()

    switch actualValue {
    case ()?:
      return PredicateResult(bool: true, message: message)
    default:
      return PredicateResult(bool: false, message: message)
    }
  }
}
