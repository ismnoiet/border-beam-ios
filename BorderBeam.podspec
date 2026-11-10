Pod::Spec.new do |s|
  s.name         = "BorderBeam"
  s.version      = "1.0.0"
  s.summary      = "GPU-rendered (Metal shader) animated border beam for any SwiftUI view."
  s.homepage     = "https://github.com/ismnoiet/border-beam-ios"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "ismnoiet" => "ismnoiet" }

  # colorEffect shaders require iOS 17+
  s.platform     = :ios, "17.0"
  s.swift_version = "5.9"

  s.source       = {
    :git => "https://github.com/ismnoiet/border-beam-ios.git",
    :tag => "#{s.version}"
  }

  s.source_files = "Sources/BorderBeam/**/*.{swift,metal}"
  s.frameworks   = "SwiftUI"
end
