import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    ///设置屏幕固定宽高
//     self.setContentSize(NSSize(width: 414,height: 736))
//     self.setContentSize(NSSize(width: 1024,height: 768))
//     self.setContentSize(NSSize(width: 800,height: 600))
//     let window: NSWindow! = self.contentView?.window
    ///去掉屏幕调整相关功能
//     window.styleMask.remove(.resizable)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
