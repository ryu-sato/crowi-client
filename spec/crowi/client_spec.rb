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
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "pages get - path" do
    req = CPApiRequestPagesGet.new path: '/'
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "pages get - page_id" do
    req = CPApiRequestPagesGet.new page_id: CrowiClient.instance.page_id(path: '/')
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "pages get - revision_id" do
    reqtmp = CPApiRequestPagesList.new path: '/'
    ret = CrowiClient.instance.request(reqtmp)
    path = ret.data[0].path
    revision_id = ret.data[0].revision._id
    req = CPApiRequestPagesGet.new path: path, revision_id: revision_id
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "pages create" do
    test_page_path = '/tmp/crowi-client test page'
    body = "# crowi-client\n"
    req = CPApiRequestPagesCreate.new path: test_page_path,
            body: body
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "pages update" do
    test_page_path = '/tmp/crowi-client test page'
    test_cases = [nil, CrowiPage::GRANT_PUBLIC, CrowiPage::GRANT_RESTRICTED,
                  CrowiPage::GRANT_SPECIFIED, CrowiPage::GRANT_OWNER]
    page_id = CrowiClient.instance.page_id(path: test_page_path)

    body = "# crowi-client\n"
    test_cases.each do |grant| 
      body = body + grant.to_s
      req = CPApiRequestPagesUpdate.new page_id: page_id,
              body: body, grant: grant
      expect(CrowiClient.instance.request(req).ok).to eq true
    end
  end

  it "pages seen" do
    page_id = CrowiClient.instance.page_id(path: '/')
    req = CPApiRequestPagesSeen.new page_id: page_id
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "likes add" do
    test_page_path = '/tmp/crowi-client test page'
    page_id = CrowiClient.instance.page_id(path: test_page_path)
    req = CPApiRequestLikesAdd.new page_id: page_id
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "likes remove" do
    test_page_path = '/tmp/crowi-client test page'
    page_id = CrowiClient.instance.page_id(path: test_page_path)
    req = CPApiRequestLikesRemove.new page_id: page_id
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "update post" do
    test_page_path = '/tmp/crowi-client test page'
    req = CPApiRequestPagesUpdatePost.new path: test_page_path
    expect(CrowiClient.instance.request(req).ok).to eq true
  end


  it "attachments list" do
    test_page_path = '/tmp/crowi-client test page'
    page_id = CrowiClient.instance.page_id(path: test_page_path)
    req = CPApiRequestAttachmentsList.new page_id: page_id
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "attachments add" do
    test_page_path = '/tmp/crowi-client test page'
    page_id = CrowiClient.instance.page_id(path: test_page_path)
    req = CPApiRequestAttachmentsAdd.new page_id: page_id,
                                         file: File.new('LICENSE.txt')
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "attachment existence" do
    test_page_path = '/tmp/crowi-client test page'
    expect(CrowiClient.instance.attachment_exist?( path: test_page_path, attachment_name: 'LICENSE.txt' )).to eql(true)
  end

  it "attachments remove" do
    test_page_path = '/tmp/crowi-client test page'
    page_id = CrowiClient.instance.page_id(path: test_page_path)
    reqtmp = CPApiRequestAttachmentsList.new page_id: page_id
    ret = CrowiClient.instance.request(reqtmp)
    attachment_id = ret.data[0]._id
    req = CPApiRequestAttachmentsRemove.new attachment_id: attachment_id
    expect(CrowiClient.instance.request(req).ok).to eq true
  end

  it "page existence" do
    expect(CrowiClient.instance.page_exist?( path: '/' )).to eql(true)
  end
end
