import Nimble
import Result

public func beVoid() -> MatcherFunc<Void> {
  return MatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "equal ()"

    let actualValue: Void? = try actualExpression.evaluate()
    switch actualValue {
    case ()?: return true
    default: return false
    }
  }
}

public func beSuccessful<T, E>() -> NonNilMatcherFunc<Result<T, E>> {
  return NonNilMatcherFunc { actual, failure in
    let result = try actual.evaluate()

    switch result {
    case .success?: return true
    default: return false
    }
  }
}
