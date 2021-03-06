[![wercker status](https://app.wercker.com/status/8d49d851e9cdf0c7e1b7c840cc2fe6ad/s/master "wercker status")](https://app.wercker.com/project/byKey/8d49d851e9cdf0c7e1b7c840cc2fe6ad)

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

Export these environments.

```
export CROWI_ACCESS_TOKEN=0123456789abcdef0123456789abcdef0123456789ab
export CROWI_URL=http://localhost:3000/
```

```ruby
require 'crowi-client'

crowi_client = CrowiClient.new(crowi_url: ENV['CROWI_URL'], access_token: ENV['CROWI_ACCESS_TOKEN'])

p crowi_client.page_exist?( path_exp: '/' )
p crowi_client.attachment_exist?( path_exp: '/', attachment_name: 'LICENSE.txt' )
```

## Examples

```ruby
# get page's ID
p crowi_client.page_id( path_exp: '/' )
```

```ruby
# Check existence of page by page path (you can use regular expression)
crowi_client.page_exist?( path_exp: '/' )
```

```ruby
# Check existence of attachment by file name of attachment
crowi_client.attachment_exist?( path_exp: '/', attachment_name: 'LICENSE.txt' )
```

```ruby
# get attachment's ID
p crowi_client.attachment_id( path_exp: '/', attachment_name: 'LICENSE.txt' )
```

```ruby
# get attachment (return data is object of CrowiAttachment)
p crowi_client.attachment( path_exp: '/', attachment_name: 'LICENSE.txt' )
```

```ruby
# pages list
req = CPApiRequestPagesList.new path_exp: '/'
p crowi_client.request(req)
```

```ruby
# pages get - path_exp
req = CPApiRequestPagesList.new path_exp: '/'
p crowi_client.request(req)
```

```ruby
# pages get - page_id
req = CPApiRequestPagesGet.new page_id: crowi_client.page_id(path_exp: '/')
p crowi_client.request(req)
```

```ruby
# pages get - revision_id
reqtmp = CPApiRequestPagesList.new path_exp: '/'
ret = crowi_client.request(reqtmp)
path = ret.data[0].path
revision_id = ret.data[0].revision._id
req = CPApiRequestPagesGet.new path: path, revision_id: revision_id
p crowi_client.request(req)
```

```ruby
# pages create
test_page_path = '/tmp/crowi-client test page'
body = "# crowi-client\n"
req = CPApiRequestPagesCreate.new path: test_page_path,
        body: body
p crowi_client.request(req)
```

```ruby
# pages update
test_page_path = '/tmp/crowi-client test page'
test_cases = [nil, CrowiPage::GRANT_PUBLIC, CrowiPage::GRANT_RESTRICTED,
              CrowiPage::GRANT_SPECIFIED, CrowiPage::GRANT_OWNER]
page_id = crowi_client.page_id(path_exp: test_page_path)

body = "# crowi-client\n"
test_cases.each do |grant|
  body = body + grant.to_s
  req = CPApiRequestPagesUpdate.new page_id: page_id,
          body: body, grant: grant
  p crowi_client.request(req)
end
```

```ruby
# pages seen
page_id = crowi_client.page_id(path_exp: '/')
req = CPApiRequestPagesSeen.new page_id: page_id
p crowi_client.request(req)
```

```ruby
# likes add
test_page_path = '/tmp/crowi-client test page'
page_id = crowi_client.page_id(path_exp: test_page_path)
req = CPApiRequestLikesAdd.new page_id: page_id
p crowi_client.request(req)
```

```ruby
# likes remove
test_page_path = '/tmp/crowi-client test page'
page_id = crowi_client.page_id(path_exp: test_page_path)
req = CPApiRequestLikesRemove.new page_id: page_id
p crowi_client.request(req)
```

```ruby
# update post
test_page_path = '/tmp/crowi-client test page'
req = CPApiRequestPagesUpdatePost.new path: test_page_path
p crowi_client.request(req)
```


```ruby
# attachments list
test_page_path = '/tmp/crowi-client test page'
page_id = crowi_client.page_id(path_exp: test_page_path)
req = CPApiRequestAttachmentsList.new page_id: page_id
p crowi_client.request(req)
```

```ruby
# attachments add
test_page_path = '/tmp/crowi-client test page'
page_id = crowi_client.page_id(path_exp: test_page_path)
req = CPApiRequestAttachmentsAdd.new page_id: page_id,
                                     file: File.new('LICENSE.txt')
p crowi_client.request(req)
```

```ruby
# attachments remove
test_page_path = '/tmp/crowi-client test page'
page_id = crowi_client.page_id(path_exp: test_page_path)
reqtmp = CPApiRequestAttachmentsList.new page_id: page_id
ret = crowi_client.request(reqtmp)
attachment_id = ret.data[0]._id
req = CPApiRequestAttachmentsRemove.new attachment_id: attachment_id
p crowi_client.request(req)
```

### Basic Authentication

```ruby
require 'crowi-client'

# Create crowiclient instance with username and password that is used by basic authentication
crowi_client = CrowiClient.new(crowi_url: ENV['CROWI_URL'], access_token: ENV['CROWI_ACCESS_TOKEN'],
                               rest_client_param: { user: 'who', password: 'bar'})

# Check existence of page
p crowi_client.page_exist?( path_exp: '/' ) ? '/ exist' : '/ not exist'

# Create page whose path is '/tmp'
req = CPApiRequestPagesCreate.new path: '/tmp', body: 'tmp'
p crowi_client.request(req)
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

- [x] Support crowi with basic Authentication
