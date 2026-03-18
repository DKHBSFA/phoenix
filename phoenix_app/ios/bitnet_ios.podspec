Pod::Spec.new do |s|
  s.name         = 'bitnet_ios'
  s.version      = '0.1.0'
  s.summary      = 'BitNet b1.58 inference engine for Phoenix'
  s.homepage     = 'https://github.com/microsoft/BitNet'
  s.license      = 'MIT'
  s.author       = 'Phoenix'
  s.source       = { :path => '.' }
  s.platform     = :ios, '15.0'

  s.source_files = 'bitnet-cpp/**/*.{c,cpp,h}'
  s.compiler_flags = '-O3 -DNDEBUG -ffast-math'
  s.pod_target_xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'OTHER_CFLAGS' => '-DGGML_USE_ACCELERATE',
  }
  s.frameworks = 'Accelerate'
end
