
Pod::Spec.new do |s|
  s.name         = "BGDatabaseAccesser"
  s.version      = "0.0.2"
  s.summary      = "easy to operate database by wrapper FMDB."
  s.description  = <<-DESC
      Lightweight access to the database by wrapper FMDB.
                   DESC

  s.homepage     = "https://github.com/xiongbengang/BGDatabaseAccesser"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Bengang" => "316379737@qq.com" }
  s.source       = { :git => "https://github.com/xiongbengang/BGDatabaseAccesser.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.public_header_files = "Classes/**/*.h"
  s.dependency 'FMDB', '~> 2.7.2'
  s.dependency 'YYModel', '~> 1.0.4'

end
