# Panoramic [![Build Status](https://secure.travis-ci.org/apeacox/panoramic.png)](http://travis-ci.org/apeacox/panoramic)
An [ActionView::Resolver] implementation to store rails views (layouts, templates and partials) on database. Simply put: what you can do with views on filesystem, can be done on database.

**NOTE:** at the moment, only ActiveRecord is supported, I've planned to add more ORMs (see Todo). If you can't wait, adding other ORMs should be very trivial.

## Installation
Add the following line to Gemfile:

```ruby
gem "panoramic"
```

## Usage

### Mandatory fields
Your model should have the following fields:

* body (text): the source of template
* path (string): where to find template (ex: layouts/application,
  you_controller/action, etc...)
* locale (string): it depends from available locales in your app
* handler (string): as locale field, it depends from avaiable handlers
  (erb, haml, etc...)
* partial (boolean): determines if it's a partial or not (false by
  default)
* format (string): A valid mimetype from Mime::SET.symbols

they're what the rails' Resolver API needs to lookup templates.

### Model
A simple macro in model will activate your new Resolver. You can use a dedicated model to manage all the views in your app, or just for specific needs (ex: you want a custom template for some static pages, the other views will be fetched from filesystem).

```ruby
class TemplateStorage < ActiveRecord::Base
  store_templates
end
```

### Controller
To add Panoramic::Resolver in controller, depending on your needs, you may choose:

* [prepend_view_path]: search for templates *first* in your resolver, *then* on filesystem
* [append_view_path]: search for templates *first* on filesystem, *then* in your resolver

**NOTE**: the above methods are both class and instance methods.


```ruby
class SomeController < ApplicationController
  prepend_view_path TemplateStorage.resolver

  def index
    # as you may already know, rails will serve 'some/index' template by default, but it doesn't care where it is stored.
  end

  def show
    # explicit render
    render :template => 'custom_template'
  end

  def custom_template
    # use another model to fetch templates
    prepend_view_path AnotherModel.resolver
  end
end
```

And let's say you want to use database template resolving in all your controllers, but
want to use panoramic only for certain paths (prefixed with X) you can use

```ruby
class ApplicationController < ActionController::Base
  prepend_view_path TemplateStorage.resolver(:only => 'use_this_prefix_only')
end
```

This helps reducing the number of database requests, if Rails for example tries to look
for layouts per controller.

### ActionMailer

```ruby
class MyEmail < ActionMailer::Base
  prepend_view_path TemplateStorage.resolver
```

## Documentation
Need more help? Check out ```spec/dummy/```, you'll find a *dummy* rails app I used to make tests ;-)

## Testing
Enter Panoramic gem path, run ```bundle install``` to install development and test dependencies, then ```rake spec```.


## Todo

### Long term
* add generators

## Contributing
Fork, make your changes, then send a pull request.

## Credits
The main idea was *heavily inspired* from José Valim's awesome book [Crafting Rails Applications]. It helped me to better understand some Rails internals.

[ActionView::Resolver]: http://api.rubyonrails.org/classes/ActionView/Resolver.html
[append_view_path]: http://apidock.com/rails/AbstractController/ViewPaths/ClassMethods/append_view_path
[prepend_view_path]: http://apidock.com/rails/AbstractController/ViewPaths/ClassMethods/prepend_view_path
[Crafting Rails Applications]: http://pragprog.com/titles/jvrails/crafting-rails-applications
