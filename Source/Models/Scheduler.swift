public typealias Scheduler = ((() -> Void) -> Void)

public let immediateScheduler: Scheduler = { completion in
  completion()
}

public let mainQueueScheduler: Scheduler = { completion in
  DispatchQueue.main.async(execute: completion)
}
