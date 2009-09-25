# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{phpdocr}
  s.version = "0.1"

  s.authors = ["Eskild Hustvedt"]
  s.date = %q{2009-09-25}
  s.email = %q{code at zerodogg dot org}
  s.files = [ 'phpdocr', 'README', 'COPYING', 'NEWS', 'phpdocr.1' ]
  s.bindir = '.'
  s.executables = [ 'phpdocr' ]
  s.homepage = %q{http://random.zerodogg.org/phpdocr}
  s.summary = %q{A simple way to access PHP documentation from the command-line}
  s.description = s.summary
  s.requirements << 'Either of: elinks, links2, links, w3m, html2text or lynx'
  s.add_dependency('mechanize')
end
