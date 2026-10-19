import AppKit

// 菜单栏沙漏用系统 SF Symbols 的沙漏。苹果允许在 App 界面里使用和调整这些符号，
// 但不允许用在 App 图标上，所以 App 图标另行设计。
// 系统沙漏是反白画法：实心部分是空玻璃，挖空的白色才是沙。这里先用两张系统沙漏拼出一个
// 全实心的外形，再按沙量挖出上腔的沙（沙面是平的）和下腔的沙堆（按原版的形状等比放大，顶上平一小段），
// 中间一道沙流，造型和粗细照系统沙漏
enum Hourglass {
  // 落完一轮沙的时长，分 12 档。菜单栏每 30 秒刷新一次，换档时最多晚 30 秒
  static let cycle: TimeInterval = 30 * 60
  private static let steps = 12
  // 沙漏按菜单栏的 16pt 设计，下面的尺寸都是在这个大小下量的。
  // Regular 的线条在菜单栏里比旁边的图标细，用 Semibold
  private static let designSize: CGFloat = 16
  private static let weight = NSFont.Weight.semibold

  // 上腔和沙堆的形状：x 以符号宽度为 1，y 以符号高度为 1、从下往上量。
  // 按 16pt 在 2 倍屏上（28×36 像素）量出来，写成像素再除以 28 和 36 方便对照。
  // 上腔顶到外沿 2.5 像素，跟底座一样厚
  private static let chamberTop: CGFloat = 30 / 36
  private static let chamberShoulder: CGFloat = 26.5 / 36
  private static let chamberNeck: CGFloat = 19.75 / 36
  private static let chamberLeft: CGFloat = 6.5 / 28
  private static let chamberRight: CGFloat = 20.5 / 28
  private static let neckLeft: CGFloat = 12.5 / 28
  private static let neckRight: CGFloat = 14.5 / 28
  private static let pileBase: CGFloat = 5.5 / 36
  private static let pileTop: CGFloat = 12.5 / 36
  private static let pileLeft: CGFloat = 6.75 / 28
  private static let pileRight: CGFloat = 20.25 / 28
  // 符号以第 13 列像素的正中间左右对称。加宽时把这一列复制一份，加宽后正好以像素边界对称，
  // 1 点（2 像素）宽的沙流骑在这条边界上
  private static let center: CGFloat = 13.5 / 28
  private static let widening: CGFloat = 0.5

  static func progress(at date: Date) -> Double {
    date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: cycle) / cycle
  }

  // 上腔在高度 y 处的内宽
  private static func chamberWidth(at y: CGFloat) -> CGFloat {
    if y >= chamberShoulder { return chamberRight - chamberLeft }
    let t = (y - chamberNeck) / (chamberShoulder - chamberNeck)
    return (neckRight - neckLeft) + ((chamberRight - chamberLeft) - (neckRight - neckLeft)) * t
  }

  // 上腔从瓶颈装到 level 时的沙量（面积，未归一）
  private static func topVolume(upTo level: CGFloat) -> CGFloat {
    let steps = 60
    let height = (level - chamberNeck) / CGFloat(steps)
    return (0..<steps).reduce(0) { sum, i in
      sum + chamberWidth(at: chamberNeck + height * (CGFloat(i) + 0.5)) * height
    }
  }

  // 上腔剩下 remaining（0...1）的沙时，沙面所在的高度
  private static func level(remaining: CGFloat) -> CGFloat {
    let target = topVolume(upTo: chamberTop) * remaining
    var low = chamberNeck
    var high = chamberTop
    for _ in 0..<30 {
      let middle = (low + high) / 2
      if topVolume(upTo: middle) < target { low = middle } else { high = middle }
    }
    return (low + high) / 2
  }

  // 一轮 12 档，每档 2.5 分钟，上腔每档少一截、沙堆每档长一截。第一档就已落下一点、
  // 最后一档上腔还留一点，每档都有沙流连着上下，看得出在走；漏空的样子只在翻转时出现
  private struct Sand {
    var running: Bool
    var surface: CGFloat
    var pileScale: CGFloat

    init(progress: Double?) {
      running = progress != nil
      let fallen: CGFloat =
        progress.map {
          let step = min(max(Int($0 * Double(steps)), 0), steps - 1)
          return CGFloat(step + 1) / CGFloat(steps + 1)
        } ?? 0
      surface = level(remaining: 1 - fallen)
      // 沙堆按面积和落下的沙量成正比，边长按平方根放大
      pileScale = fallen.squareRoot()
    }
  }

  // progress 为 nil 时沙全在上腔、不动；0...1 表示这一轮已经落下的比例。模板图由系统按深浅色着色
  static func image(pointSize: CGFloat, progress: Double?) -> NSImage {
    image(pointSize: pointSize, sand: Sand(progress: progress))
  }

  // 漏完后整个沙漏翻过来，degrees 从 0 到 180；转完沙全在上腔，接着换成下一轮第一档。
  // 先按屏幕分辨率把正立的沙漏画成位图再整张旋转：直接旋转着画，加宽时拼接的边界会露出细缝
  static func flipping(pointSize: CGFloat, degrees: CGFloat) -> NSImage {
    var done = Sand(progress: nil)
    done.surface = chamberNeck
    done.pileScale = 1
    let upright = image(pointSize: pointSize, sand: done)
    let image = NSImage(size: upright.size, flipped: false) { rect in
      guard let context = NSGraphicsContext.current else { return false }
      let pixels = abs(context.cgContext.userSpaceToDeviceSpaceTransform.d)
      guard
        let bitmap = NSBitmapImageRep(
          bitmapDataPlanes: nil, pixelsWide: Int((rect.width * pixels).rounded()),
          pixelsHigh: Int((rect.height * pixels).rounded()), bitsPerSample: 8,
          samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
          bytesPerRow: 0, bitsPerPixel: 0)
      else { return false }
      bitmap.size = rect.size
      NSGraphicsContext.saveGraphicsState()
      NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
      upright.draw(in: rect)
      NSGraphicsContext.restoreGraphicsState()
      let flat = NSImage(size: rect.size)
      flat.addRepresentation(bitmap)
      let rotation = NSAffineTransform()
      rotation.translateX(by: rect.midX, yBy: rect.midY)
      rotation.rotate(byDegrees: -degrees)
      rotation.translateX(by: -rect.midX, yBy: -rect.midY)
      rotation.concat()
      context.imageInterpolation = .high
      flat.draw(in: rect)
      return true
    }
    image.isTemplate = true
    return image
  }

  // 别的尺寸都由菜单栏的 16pt 按比例放大，造型、沙面和沙流的位置跟菜单栏完全一样。
  // 绘制回调在放大后的画布上重新执行，按目标分辨率画，不会发糊
  private static func image(pointSize: CGFloat, sand: Sand) -> NSImage {
    let design = design(sand: sand)
    guard pointSize != designSize else { return design }
    let scale = pointSize / designSize
    let size = NSSize(width: design.size.width * scale, height: design.size.height * scale)
    let image = NSImage(size: size, flipped: false) { rect in
      design.draw(in: rect)
      return true
    }
    image.isTemplate = true
    return image
  }

  private static func design(sand: Sand) -> NSImage {
    let configuration = NSImage.SymbolConfiguration(pointSize: designSize, weight: weight)
    guard
      let topSolid = NSImage(
        systemSymbolName: "hourglass.tophalf.filled", accessibilityDescription: nil)?
        .withSymbolConfiguration(configuration),
      let bottomSolid = NSImage(
        systemSymbolName: "hourglass.bottomhalf.filled", accessibilityDescription: nil)?
        .withSymbolConfiguration(configuration)
    else { return NSImage() }
    let native = topSolid.size

    // 沙面、沙堆顶、沙流两端对齐到整行像素，每一档都是干净的一步，不出现半个像素的灰边
    func snapper(_ context: NSGraphicsContext) -> (CGFloat) -> CGFloat {
      let pixels = abs(context.cgContext.userSpaceToDeviceSpaceTransform.d)
      return { fraction in (native.height * fraction * pixels).rounded() / pixels }
    }
    func apex(_ snap: (CGFloat) -> CGFloat) -> CGFloat {
      sand.pileScale > 0
        ? snap(pileBase + (pileTop - pileBase) * sand.pileScale) / native.height : pileBase
    }

    // 系统沙漏的外形加上上腔的沙，按系统符号原本的大小画
    let body = NSImage(size: native, flipped: false) { rect in
      guard let context = NSGraphicsContext.current else { return false }
      let snap = snapper(context)
      func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: rect.width * x, y: rect.height * y)
      }
      // 外形：两张系统沙漏各取实心的那一半，在中线拼起来。中线对齐到整像素，否则拼接处透出横线
      let split = snap(0.5)
      for (symbol, lower, upper) in [(topSolid, split, rect.height), (bottomSolid, 0, split)] {
        NSGraphicsContext.saveGraphicsState()
        CGRect(x: 0, y: lower, width: rect.width, height: upper - lower).clip()
        symbol.draw(in: rect)
        NSGraphicsContext.restoreGraphicsState()
      }
      context.saveGraphicsState()
      context.compositingOperation = .clear
      // 上腔的沙：腔体形状截到沙面。瓶颈不在整像素上，下沿也截到整像素，
      // 否则沙快漏完时瓶颈处只剩一道发灰的细线
      let neck = snap(chamberNeck)
      if snap(sand.surface) > neck {
        NSGraphicsContext.saveGraphicsState()
        CGRect(x: 0, y: neck, width: rect.width, height: snap(sand.surface) - neck).clip()
        let chamber = NSBezierPath()
        chamber.move(to: point(chamberLeft, chamberTop))
        chamber.line(to: point(chamberRight, chamberTop))
        chamber.line(to: point(chamberRight, chamberShoulder))
        chamber.line(to: point(neckRight, chamberNeck))
        chamber.line(to: point(neckLeft, chamberNeck))
        chamber.line(to: point(chamberLeft, chamberShoulder))
        chamber.close()
        chamber.fill()
        NSGraphicsContext.restoreGraphicsState()
      }
      context.restoreGraphicsState()
      return true
    }

    // 加宽：从正中那列像素的右边切开，右半往外挪半点（2 倍屏上 1 个像素），正中那列就复制了一份。
    // 整体拉伸会让斜线变粗、底座发灰，平移整像素则线条保持系统符号原本的清晰度。
    // 放大画时半点不一定是整像素，切口和平移量都取整到像素：切口落在半个像素处，
    // 拼接的两边都盖不满，会透出细缝；平移半个像素则边缘发虚
    let size = NSSize(width: native.width + widening, height: native.height)
    let image = NSImage(size: size, flipped: false) { rect in
      guard let context = NSGraphicsContext.current else { return false }
      let snap = snapper(context)
      let pixels = abs(context.cgContext.userSpaceToDeviceSpaceTransform.a)
      func snapX(_ x: CGFloat) -> CGFloat { (x * pixels).rounded() / pixels }
      let middle = native.width * center
      let axis = snapX(middle)
      let widen = max(snapX(widening), 1 / pixels)
      let streamWidth = snapX(1)
      let streamLeft = snapX(middle + widen / 2 - streamWidth / 2)
      for (from, to, shift) in [(CGFloat(0), axis, CGFloat(0)), (axis, rect.width, widen)] {
        NSGraphicsContext.saveGraphicsState()
        CGRect(x: from, y: 0, width: to - from, height: rect.height).clip()
        body.draw(in: CGRect(origin: CGPoint(x: shift, y: 0), size: native))
        NSGraphicsContext.restoreGraphicsState()
      }
      context.saveGraphicsState()
      context.compositingOperation = .clear
      // 下腔的沙堆：原版的三角形，以底边中点为基准按比例缩放，右半跟着外形挪出加宽量。
      // 顶上留一段平的，左右边就是沙流的边：尖顶在加宽时会被拉成两个半透明像素，看着像缺了个口
      if sand.pileScale > 0 {
        let half = (pileRight - pileLeft) / 2 * sand.pileScale * native.width
        let base = pileBase * native.height
        let top = apex(snap) * native.height
        let pile = NSBezierPath()
        pile.move(to: CGPoint(x: middle - half, y: base))
        pile.line(to: CGPoint(x: middle + half + widen, y: base))
        pile.line(to: CGPoint(x: streamLeft + streamWidth, y: top))
        pile.line(to: CGPoint(x: streamLeft, y: top))
        pile.close()
        pile.fill()
      }
      // 沙流：上端伸进上腔的沙，下端伸进沙堆顶一点。瓶颈窄于沙流，只接到边上会因为抗锯齿发灰，
      // 看着像断了
      if sand.running {
        let top = min(sand.surface, chamberNeck + 0.05)
        let bottom = max(apex(snap) - 0.03, pileBase)
        if top > bottom {
          CGRect(
            x: streamLeft, y: snap(bottom), width: streamWidth, height: snap(top) - snap(bottom)
          ).fill()
        }
      }
      context.restoreGraphicsState()
      return true
    }
    image.isTemplate = true
    return image
  }
}
