# Advanced Usage #

What if the endpoints you need to query don't return JSON? Perhaps you have an
endpoint, `GET https://www.example.com/isAuthorized` that returns a `200 OK`
with `"yes"` or `"no"` as a response body. We'll have to do a few things:

- Define a custom `ResponseParser` to provide to our `Request` object, because
the default one parses `JSON`.
- Define a custom `Deserializer` to provide to our `APIClient`, because the 
default one uses `NSJSONSerialization`.

We'll start with the custom `Deserializer`. It will simply pass along the 
`NSData` if it exists:

```swift
struct DataDeserializer: Deserializer {
  func deserialize(data: NSData?) -> Result<AnyObject, SwishError> {
    guard let data = data where data.length > 0 else {
      return .Success(NSNull())
    }

    return .Success(data)
  }
}
```

Then, our custom `ResponseParser` will use `String(data:encoding:)` to
transform the incoming `NSData` to a `String` representation:

```swift
struct StringParser: Parser {
  typealias Representation = String

  static func parse(j: AnyObject) -> Result<String, SwishError> {
    guard let data = j as? NSData else {
      let error = NSError.error("Bad data!")

      return .Failure(.InvalidJSONResponse(error))
    }

    let error = NSError.error("Couldn't convert to string!")
    let string = String(data: data, encoding: NSUTF8StringEncoding)

    return Result(string, failWith: .InvalidJSONResponse(error))
  }
}
```

Finally, our `Request` will convert the `String` into a `Bool`:

```swift
struct AuthorizedRequest: Request {
  typealias ResponseObject = Bool
  typealias ResponseParser = StringParser

  func build() -> NSURLRequest {
    let endpoint = NSURL(string: "https://www.example.com/isAuthorized")!

    return NSURLRequest(URL: endpoint)
  }

  func parse(j: String) -> Result<Bool, SwishError> {
    switch j {
      case "yes":
        return Result(true)
      case "no":
        return Result(false)
      default:
        let error = NSError.error("Unexpected response body!")
        return Result(error: .InvalidJSONResponse(error))
    }
  }
}
```

Now, we're ready to make our request:

```swift
let client = APIClient(
  requestPerformer: NetworkRequestPerformer(),
  deserializer: DataDeserializer()
)
let request = AuthorizedRequest()

let dataTask = client.performRequest(request) { (result: Result<Bool, SwishError>) in
  // whatever you need to do
}
```

A simplyfing change we could make would be to implement `Parser` whose `Representation` would be `Bool`, rather than `String`, allowing us to avoid overriding the `parse` function in `AuthorizedRequest`. We'll leave that as an exercise to the reader!
