Factory.define :database_template do |t|
  t.path    'foo/index'
  t.format  'html'
  t.locale  'en'
  t.handler 'erb'
  t.partial 'false'
  t.body    "something here in the body of the page: <%= 2 + 2 %>"
end
