import Nimble

public func beVoid() -> MatcherFunc<Void> {
  return MatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "equal ()"

    let actualValue = try actualExpression.evaluate()
    switch actualValue {
    case .Some(()):
      return true
    default:
      return false
    }
  }
}
