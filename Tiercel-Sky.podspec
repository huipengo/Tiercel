
Pod::Spec.new do |s|
  s.name             = 'Tiercel-Sky'
  s.version          = '3.2.4'
  s.swift_version    = '5.0'
  s.summary          = 'Tiercel-Sky is a lightweight, pure-Swift download framework. forked from https://github.com/Danie1s/Tiercel'


  s.homepage         = 'https://github.com/Danie1s/Tiercel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniels' => '176516837@qq.com' }
  s.source           = { :git => 'git@github.com:huipengo/Tiercel.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/**/*.swift'
  s.requires_arc = true

end
