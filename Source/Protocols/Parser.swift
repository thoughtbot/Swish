import Result

public protocol Parser {
  associatedtype Representation

  static func parse(_ j: Any) -> Result<Representation, SwishError>
}
