Dummy::Application.routes.draw do
  get '/foo/default_layout' => 'foo#default_layout'
  get '/foo/custom_layout' => 'foo#custom_layout'
end
