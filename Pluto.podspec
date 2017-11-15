Pod::Spec.new do |s|
    s.name         = 'Pluto'
    s.version      = '1.0.3'
    s.summary      = 'iOS development kit. Language: ObjC'
    s.homepage     = 'https://github.com/PlutoMa/Pluto'
    s.license      = 'MIT'
    s.authors      = {'PlutoMa' => 'mademaomail@126.com'}
    s.platform     = :ios, '7.0'
    s.source       = {:git => 'https://github.com/PlutoMa/Pluto.git', :tag => s.version}
    s.source_files = 'Pluto/**/*.{h,m}'
    s.requires_arc = true
end
