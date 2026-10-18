import Darwin
import Foundation

public struct ProcessEntry: Equatable, Sendable {
  // 可执行文件名，不是 proc_name 那个最多 32 字节的截断名
  public var name: String
  public var commandLine: String?

  public init(name: String, commandLine: String?) {
    self.name = name
    self.commandLine = commandLine
  }
}

public protocol ProcessListing: Sendable {
  func processes(includingCommandLines: Bool) -> [ProcessEntry]
}

public struct LiveProcessListing: ProcessListing {
  public init() {}

  public func processes(includingCommandLines: Bool) -> [ProcessEntry] {
    let capacity = proc_listallpids(nil, 0)
    guard capacity > 0 else { return [] }
    // 两次调用之间可能有新进程，多留些空间
    var pids = [pid_t](repeating: 0, count: Int(capacity) + 64)
    let count = proc_listallpids(&pids, Int32(pids.count * MemoryLayout<pid_t>.size))
    guard count > 0 else { return [] }
    return pids.prefix(Int(count)).compactMap { pid in
      guard pid > 0, let path = executablePath(pid) else { return nil }
      return ProcessEntry(
        name: (path as NSString).lastPathComponent,
        commandLine: includingCommandLines ? commandLine(pid) : nil)
    }
  }

  private func executablePath(_ pid: pid_t) -> String? {
    var buffer = [CChar](repeating: 0, count: 4 * Int(MAXPATHLEN))
    let length = proc_pidpath(pid, &buffer, UInt32(buffer.count))
    guard length > 0 else { return nil }
    return String(decoding: buffer.prefix(Int(length)).map { UInt8(bitPattern: $0) }, as: UTF8.self)
  }

  // KERN_PROCARGS2 的布局：argc（Int32）、可执行文件路径、若干 \0 填充、argv 各项以 \0 分隔，后面是环境变量。
  // 只能读到同一用户的进程，读不到时当作没有命令行
  private func commandLine(_ pid: pid_t) -> String? {
    var mib: [Int32] = [CTL_KERN, KERN_PROCARGS2, pid]
    var size = 0
    guard sysctl(&mib, 3, nil, &size, nil, 0) == 0, size > MemoryLayout<Int32>.size else {
      return nil
    }
    var buffer = [UInt8](repeating: 0, count: size)
    guard sysctl(&mib, 3, &buffer, &size, nil, 0) == 0 else { return nil }
    let argc = buffer.withUnsafeBytes { $0.loadUnaligned(as: Int32.self) }
    var index = MemoryLayout<Int32>.size
    while index < size, buffer[index] != 0 { index += 1 }
    while index < size, buffer[index] == 0 { index += 1 }
    var arguments: [String] = []
    while arguments.count < argc, index < size {
      let start = index
      while index < size, buffer[index] != 0 { index += 1 }
      arguments.append(String(decoding: buffer[start..<index], as: UTF8.self))
      index += 1
    }
    return arguments.joined(separator: " ")
  }
}
