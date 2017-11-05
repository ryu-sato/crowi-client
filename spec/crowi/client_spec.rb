require "spec_helper"

RSpec.describe Crowi::Client do

  # Page path for test
  # @note Test page is not removed after test because removing page is not permitted throw API.
  let(:test_page_path) { '/tmp/crowi-client test page' }

  describe '# CrowiClient\'s basic attributes and methods.' do

    # Test for VERSION
    it "has a version number" do
      expect(Crowi::Client::VERSION).not_to be nil
    end

  end

  describe '# Crowi pages' do
  
    # Test for function to get page list
    it "pages list" do
      req = CPApiRequestPagesList.new path: '/'
      expect(CrowiClient.instance.request(req).ok).to eq true
    end
  
    # Test for function to get page
    it "pages get" do
      aggregate_failures 'some pattern to get page' do
        # get page specified path
        req = CPApiRequestPagesGet.new path: '/'
        expect(CrowiClient.instance.request(req).ok).to eq true
  
        # get page specified page_id
        req = CPApiRequestPagesGet.new page_id: CrowiClient.instance.page_id(path: '/')
        expect(CrowiClient.instance.request(req).ok).to eq true
  
        # get page specified path and revision_id
        reqtmp = CPApiRequestPagesList.new path: '/'
        ret = CrowiClient.instance.request(reqtmp)
        page = ret&.data&.find{ |page| page.path == '/' }
        req = CPApiRequestPagesGet.new path: page.path, revision_id: page.revision._id
        expect(CrowiClient.instance.request(req).ok).to eq true
      end
    end
  
    # Test for function to create page
    it "pages create" do
      body = "# crowi-client\n"
      req = CPApiRequestPagesCreate.new path: test_page_path,
              body: body
      expect(CrowiClient.instance.request(req).ok).to eq true
    end
  
    # Test for function to update page
    it "pages update" do
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
  
    # Test for function to get the page list, which is seen
    it "pages seen" do
      page_id = CrowiClient.instance.page_id(path: '/')
      req = CPApiRequestPagesSeen.new page_id: page_id
      expect(CrowiClient.instance.request(req).ok).to eq true
    end
  
    # Test for function to react LIKE
    it "likes add" do
      page_id = CrowiClient.instance.page_id(path: test_page_path)
      req = CPApiRequestLikesAdd.new page_id: page_id
      expect(CrowiClient.instance.request(req).ok).to eq true
    end
  
    # Test for function to cancel LIKE reaction
    it "likes remove" do
      page_id = CrowiClient.instance.page_id(path: test_page_path)
      req = CPApiRequestLikesRemove.new page_id: page_id
      expect(CrowiClient.instance.request(req).ok).to eq true
    end
  
    # Test for function to set update post
    it "update post" do
      req = CPApiRequestPagesUpdatePost.new path: test_page_path
      expect(CrowiClient.instance.request(req).ok).to eq true
    end

    # Test for function to check page existence
    # @todo Assure page existence.
    #       (ex. path '/' is not promises existence, and path '/tmp/#####FAKE_PATH#####' is also)
    it "page existence" do
      aggregate_failures 'exist page, and not exist page' do
        expect(CrowiClient.instance.page_exist?( path: '/' )).to eql(true)
        expect(CrowiClient.instance.page_exist?( path: '/tmp/#####FAKE_PAGE#####' )).to eql(false)
      end
    end

  end

  describe '# Crowi attachments' do
  
    # Test for function to get attachment list
    it "attachments list" do
      page_id = CrowiClient.instance.page_id(path: test_page_path)
      req = CPApiRequestAttachmentsList.new page_id: page_id
      expect(CrowiClient.instance.request(req).ok).to eq true
    end
  
 
    # Test for function to add attachment
    it "attachments add" do
      page_id = CrowiClient.instance.page_id(path: test_page_path)
      req = CPApiRequestAttachmentsAdd.new page_id: page_id,
                                           file: File.new('LICENSE.txt')
      expect(CrowiClient.instance.request(req).ok).to eq true
    end
  
    # Test for function to check attachment existence
    it "attachment existence" do
      expect(CrowiClient.instance.attachment_exist?( path: test_page_path, attachment_name: 'LICENSE.txt' )).to eql(true)
    end
 
    # Test for function to get attachment info
    it "attachment info" do
      a = CrowiClient.instance.attachment(path: test_page_path, attachment_name: 'LICENSE.txt')
      expect(a.originalName).to eq 'LICENSE.txt'
    end

    # Test for function to remove attachment file
    it "attachments remove" do
      page_id = CrowiClient.instance.page_id(path: test_page_path)
      reqtmp = CPApiRequestAttachmentsList.new page_id: page_id
      ret = CrowiClient.instance.request(reqtmp)
      attachment_id = ret.data[0]._id
      req = CPApiRequestAttachmentsRemove.new attachment_id: attachment_id
      expect(CrowiClient.instance.request(req).ok).to eq true
    end
  
  end

end
