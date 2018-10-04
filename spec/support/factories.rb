# FactoryBot.define :database_template do |t|
FactoryBot.define do
  factory :database_template do
    path    { 'foo/index' }
    format  { 'html' }
    locale  { 'en' }
    handler { 'erb' }
    partial { 'false' }
    body    { "something here in the body of the page: <%= 2 + 2 %>" }
  end
end
