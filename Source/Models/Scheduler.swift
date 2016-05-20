public typealias Scheduler = ((() -> Void) -> Void)

public let immediateScheduler: Scheduler = { completion in
  completion()
}

public let mainQueueScheduler: Scheduler = { completion in
  dispatch_async(dispatch_get_main_queue(), completion)
}
