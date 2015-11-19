func onMain(f: dispatch_block_t)  {
  dispatch_async(dispatch_get_main_queue(), f)
}
