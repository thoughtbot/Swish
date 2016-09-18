import Result

public protocol Parser {
  associatedtype Representation

  static func parse(_ j: AnyObject) -> Result<Representation, SwishError>
}
