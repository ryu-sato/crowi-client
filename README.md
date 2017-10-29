# crowi-plus-client -- client of crowi-plus with use API

A client of crowi-plus with use API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crowi-plus-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crowi-plus-client

## Usage

```ruby
# pages list
req = CPApiRequestPagesList.new path: '/'
puts CrowiPlusClient.instance.request(req)
```

```ruby
# pages get - path
req = CPApiRequestPagesList.new path: '/'
puts CrowiPlusClient.instance.request(req)
```

```ruby
# pages get - page_id
reqtmp = CPApiRequestPagesList.new path: '/'
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
page_id = ret['pages'][0]['_id']
req = CPApiRequestPagesGet.new page_id: page_id
puts CrowiPlusClient.instance.request(req)
```

```ruby
# pages get - revision_id
reqtmp = CPApiRequestPagesList.new path: '/'
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
path = ret['pages'][0]['path']
revision_id = ret['pages'][0]['revision']['_id']
req = CPApiRequestPagesGet.new path: path, revision_id: revision_id
puts CrowiPlusClient.instance.request(req)
```

```ruby
# pages create
test_page_path = '/tmp/crowi-plus-client test page'
body = "# crowi-plus-client\n"
req = CPApiRequestPagesCreate.new path: test_page_path,
        body: body
puts CrowiPlusClient.instance.request(req)
```

```ruby
# pages update
test_page_path = '/tmp/crowi-plus-client test page'
GRANT_PUBLIC = 1
GRANT_RESTRICTED = 2
GRANT_SPECIFIED = 3
GRANT_OWNER = 4
test_cases = [nil, GRANT_PUBLIC, GRANT_RESTRICTED, GRANT_SPECIFIED, GRANT_OWNER]
reqtmp = CPApiRequestPagesList.new path: test_page_path
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
page_id = ret['pages'][0]['_id']

body = "# crowi-plus-client\n"
test_cases.each do |grant|
  body = body + grant.to_s
  req = CPApiRequestPagesUpdate.new page_id: page_id,
          body: body, grant: grant
  puts CrowiPlusClient.instance.request(req)
end
```

```ruby
# pages seen
reqtmp = CPApiRequestPagesList.new path: '/'
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
page_id = ret['pages'][0]['_id']
req = CPApiRequestPagesSeen.new page_id: page_id
puts CrowiPlusClient.instance.request(req)
```

```ruby
# likes add
test_page_path = '/tmp/crowi-plus-client test page'
reqtmp = CPApiRequestPagesList.new path: test_page_path
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
page_id = ret['pages'][0]['_id']
req = CPApiRequestLikesAdd.new page_id: page_id
puts CrowiPlusClient.instance.request(req)
```

```ruby
# likes remove
test_page_path = '/tmp/crowi-plus-client test page'
reqtmp = CPApiRequestPagesList.new path: test_page_path
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
page_id = ret['pages'][0]['_id']
req = CPApiRequestLikesRemove.new page_id: page_id
puts CrowiPlusClient.instance.request(req)
```

```ruby
# update post
test_page_path = '/tmp/crowi-plus-client test page'
req = CPApiRequestPagesUpdatePost.new path: test_page_path
puts CrowiPlusClient.instance.request(req)
```


```ruby
# attachments list
test_page_path = '/tmp/crowi-plus-client test page'
reqtmp = CPApiRequestPagesList.new path: test_page_path
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
page_id = ret['pages'][0]['_id']
req = CPApiRequestAttachmentsList.new page_id: page_id
puts CrowiPlusClient.instance.request(req)
```

```ruby
# attachments add
test_page_path = '/tmp/crowi-plus-client test page'
reqtmp = CPApiRequestPagesList.new path: test_page_path
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
page_id = ret['pages'][0]['_id']
req = CPApiRequestAttachmentsAdd.new page_id: page_id,
                                     file: File.new('LICENSE.txt')
puts CrowiPlusClient.instance.request(req)
```

```ruby
# attachments remove
test_page_path = '/tmp/crowi-plus-client test page'
reqtmp = CPApiRequestPagesList.new path: test_page_path
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
page_id = ret['pages'][0]['_id']
reqtmp = CPApiRequestAttachmentsList.new page_id: page_id
ret = JSON.parse(CrowiPlusClient.instance.request(reqtmp))
attachment_id = ret['attachments'][0]['_id']
req = CPApiRequestAttachmentsRemove.new attachment_id: attachment_id
puts CrowiPlusClient.instance.request(req)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ryu-sato/crowi-plus-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Crowi::Plus::Client project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ryu-sato/crowi-plus-client/blob/master/CODE_OF_CONDUCT.md).
