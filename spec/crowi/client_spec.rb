require "spec_helper"

RSpec.describe Crowi::Client do
  let(:apiok) {
    { "ok" => true }
  }

  it "has a version number" do
    expect(Crowi::Client::VERSION).not_to be nil
  end

  it "pages list" do
    req = CPApiRequestPagesList.new path: '/'
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "pages get - path" do
    req = CPApiRequestPagesList.new path: '/'
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "pages get - page_id" do
    reqtmp = CPApiRequestPagesList.new path: '/'
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    page_id = ret['pages'][0]['_id']
    req = CPApiRequestPagesGet.new page_id: page_id
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "pages get - revision_id" do
    reqtmp = CPApiRequestPagesList.new path: '/'
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    path = ret['pages'][0]['path']
    revision_id = ret['pages'][0]['revision']['_id']
    req = CPApiRequestPagesGet.new path: path, revision_id: revision_id
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "pages create" do
    test_page_path = '/tmp/crowi-client test page'
    body = "# crowi-client\n"
    req = CPApiRequestPagesCreate.new path: test_page_path,
            body: body
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "pages update" do
    test_page_path = '/tmp/crowi-client test page'
    GRANT_PUBLIC = 1
    GRANT_RESTRICTED = 2
    GRANT_SPECIFIED = 3
    GRANT_OWNER = 4
    test_cases = [nil, GRANT_PUBLIC, GRANT_RESTRICTED, GRANT_SPECIFIED, GRANT_OWNER]
    reqtmp = CPApiRequestPagesList.new path: test_page_path
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    page_id = ret['pages'][0]['_id']

    body = "# crowi-client\n"
    test_cases.each do |grant| 
      body = body + grant.to_s
      req = CPApiRequestPagesUpdate.new page_id: page_id,
              body: body, grant: grant
      expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
    end
  end

  it "pages seen" do
    reqtmp = CPApiRequestPagesList.new path: '/'
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    page_id = ret['pages'][0]['_id']
    req = CPApiRequestPagesSeen.new page_id: page_id
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "likes add" do
    test_page_path = '/tmp/crowi-client test page'
    reqtmp = CPApiRequestPagesList.new path: test_page_path
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    page_id = ret['pages'][0]['_id']
    req = CPApiRequestLikesAdd.new page_id: page_id
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "likes remove" do
    test_page_path = '/tmp/crowi-client test page'
    reqtmp = CPApiRequestPagesList.new path: test_page_path
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    page_id = ret['pages'][0]['_id']
    req = CPApiRequestLikesRemove.new page_id: page_id
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "update post" do
    test_page_path = '/tmp/crowi-client test page'
    req = CPApiRequestPagesUpdatePost.new path: test_page_path
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end


  it "attachments list" do
    test_page_path = '/tmp/crowi-client test page'
    reqtmp = CPApiRequestPagesGet.new path: test_page_path
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    page_id = ret['page']['id']
    req = CPApiRequestAttachmentsList.new page_id: page_id
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "attachments add" do
    test_page_path = '/tmp/crowi-client test page'
    reqtmp = CPApiRequestPagesList.new path: test_page_path
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    page_id = ret['pages'][0]['_id']
    req = CPApiRequestAttachmentsAdd.new page_id: page_id,
                                         file: File.new('LICENSE.txt')
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "attachment existence" do
    test_page_path = '/tmp/crowi-client test page'
    expect(CrowiClient.instance.attachment_exist?( path: test_page_path, attachment_name: 'LICENSE.txt' )).to eql(true)
  end

  it "attachments remove" do
    test_page_path = '/tmp/crowi-client test page'
    reqtmp = CPApiRequestPagesList.new path: test_page_path
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    page_id = ret['pages'][0]['_id']
    reqtmp = CPApiRequestAttachmentsList.new page_id: page_id
    ret = JSON.parse(CrowiClient.instance.request(reqtmp))
    attachment_id = ret['attachments'][0]['_id']
    req = CPApiRequestAttachmentsRemove.new attachment_id: attachment_id
    expect(CrowiClient.instance.request(req)).to be_json_including(apiok)
  end

  it "page existence" do
    expect(CrowiClient.instance.page_exist?( path: '/' )).to eql(true)
  end
end
