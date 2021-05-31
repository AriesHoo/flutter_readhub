#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_macos_webview.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_macos_webview'
  s.version          = '0.0.4'
  s.summary          = 'Flutter plugin that lets you display native WebView on macOS'
  s.description      = <<-DESC
Flutter plugin that lets you display native WebView on macOS
                       DESC
  s.homepage         = 'http://github.com/vanelizarov/flutter_macos_webview'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'vanelizarov' => 'elizarov.vanya@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.6'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
