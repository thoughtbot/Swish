import Result

public protocol Deserializer {
  func deserialize(data: NSData?) -> Result<AnyObject, SwishError>
}
