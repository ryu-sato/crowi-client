# crowi-client -- client of crowi with use API

A client of crowi with use API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crowi-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crowi-client

## Usage

At first, you need to create setting file ```config/settings.yml``` in your application directory.
And set token key of crowi API, and URL of crowi (ex. http://localhost:3000) in ```settings.yml```.

```YAML
# Example of config/settings.yml. YOU NEED TO REPLACE token!!!
token: xEKAueUZDrQlr30iFZr96ti3GUd8sqP/pTkS3DGrwcc=
url: http://localhost:3000/
```

Then, you can use crowi client with ```require 'crowi-client'```.

```ruby
require 'crowi-client'
puts CrowiClient.instance.page_exist?( path_exp: '/' )
puts CrowiClient.instance.attachment_exist?( path_exp: '/', attachment_name: 'LICENSE.txt' )
```

## Examples

```ruby
# get page's ID
puts CrowiClient.instance.page_id( path_exp: '/' )
```

```ruby
# Check existence of page by page path (you can use regular expression)
CrowiClient.instance.page_exist?( path_exp: '/' )
```

```ruby
# Check existence of attachment by file name of attachment
CrowiClient.instance.attachment_exist?( path_exp: '/', attachment_name: 'LICENSE.txt' )
```

```ruby
# get attachment's ID
puts CrowiClient.instance.attachment_id( path_exp: '/', attachment_name: 'LICENSE.txt' )
```

```ruby
# get attachment (return data is object of CrowiAttachment)
puts CrowiClient.instance.attachment( path_exp: '/', attachment_name: 'LICENSE.txt' )
```

```ruby
# pages list
req = CPApiRequestPagesList.new path_exp: '/'
puts CrowiClient.instance.request(req)
```

```ruby
# pages get - path_exp
req = CPApiRequestPagesList.new path_exp: '/'
puts CrowiClient.instance.request(req)
```

```ruby
# pages get - page_id
req = CPApiRequestPagesGet.new page_id: CrowiClient.instance.page_id(path: '/')
puts CrowiClient.instance.request(req)
```

```ruby
# pages get - revision_id
reqtmp = CPApiRequestPagesList.new path_exp: '/'
ret = CrowiClient.instance.request(reqtmp)
path = ret.data[0].path
revision_id = ret.data[0].revision._id
req = CPApiRequestPagesGet.new path: path, revision_id: revision_id
puts CrowiClient.instance.request(req)
```

```ruby
# pages create
test_page_path = '/tmp/crowi-client test page'
body = "# crowi-client\n"
req = CPApiRequestPagesCreate.new path: test_page_path,
        body: body
puts CrowiClient.instance.request(req)
```

```ruby
# pages update
test_page_path = '/tmp/crowi-client test page'
test_cases = [nil, CrowiPage::GRANT_PUBLIC, CrowiPage::GRANT_RESTRICTED,
              CrowiPage::GRANT_SPECIFIED, CrowiPage::GRANT_OWNER]
page_id = CrowiClient.instance.page_id(path: test_page_path)

body = "# crowi-client\n"
test_cases.each do |grant|
  body = body + grant.to_s
  req = CPApiRequestPagesUpdate.new page_id: page_id,
          body: body, grant: grant
  puts CrowiClient.instance.request(req)
end
```

```ruby
# pages seen
page_id = CrowiClient.instance.page_id(path: '/')
req = CPApiRequestPagesSeen.new page_id: page_id
puts CrowiClient.instance.request(req)
```

```ruby
# likes add
test_page_path = '/tmp/crowi-client test page'
page_id = CrowiClient.instance.page_id(path: test_page_path)
req = CPApiRequestLikesAdd.new page_id: page_id
puts CrowiClient.instance.request(req)
```

```ruby
# likes remove
test_page_path = '/tmp/crowi-client test page'
page_id = CrowiClient.instance.page_id(path: test_page_path)
req = CPApiRequestLikesRemove.new page_id: page_id
puts CrowiClient.instance.request(req)
```

```ruby
# update post
test_page_path = '/tmp/crowi-client test page'
req = CPApiRequestPagesUpdatePost.new path: test_page_path
puts CrowiClient.instance.request(req)
```


```ruby
# attachments list
test_page_path = '/tmp/crowi-client test page'
page_id = CrowiClient.instance.page_id(path: test_page_path)
req = CPApiRequestAttachmentsList.new page_id: page_id
puts CrowiClient.instance.request(req)
```

```ruby
# attachments add
test_page_path = '/tmp/crowi-client test page'
page_id = CrowiClient.instance.page_id(path: test_page_path)
req = CPApiRequestAttachmentsAdd.new page_id: page_id,
                                     file: File.new('LICENSE.txt')
puts CrowiClient.instance.request(req)
```

```ruby
# attachments remove
test_page_path = '/tmp/crowi-client test page'
page_id = CrowiClient.instance.page_id(path: test_page_path)
reqtmp = CPApiRequestAttachmentsList.new page_id: page_id
ret = CrowiClient.instance.request(reqtmp)
attachment_id = ret.data[0]._id
req = CPApiRequestAttachmentsRemove.new attachment_id: attachment_id
puts CrowiClient.instance.request(req)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ryu-sato/crowi-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Crowi::Client project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ryu-sato/crowi-client/blob/master/CODE_OF_CONDUCT.md).

## ToDo

- [ ] Support crowi with basic Authentication
