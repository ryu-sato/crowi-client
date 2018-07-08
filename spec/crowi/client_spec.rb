require "spec_helper"

RSpec.describe Crowi::Client do

  # Page path for test
  # @note Test page is not removed after test because removing page is not permitted throw API.
  let(:test_page_path) { '/tmp/crowi-client テストページ'  }
  let(:crowi_client)   { CrowiClient.new(crowi_url: ENV['CROWI_URL'],
                                         access_token: ENV['CROWI_ACCESS_TOKEN']) }

  describe '# CrowiClient\'s basic attributes and methods :' do
    # Test for VERSION
    it "check version number is exist" do
      expect(Crowi::Client::VERSION).not_to be nil
    end
  end

  describe '# API related Crowi pages :' do
    # Test for function to get page list
    it "get list of page" do
      req = CPApiRequestPagesList.new path_exp: '/'
      expect(crowi_client.request(req).ok).to eq true
    end
  
    # Test for function to get page
    it "get page" do
      aggregate_failures 'some pattern to get page' do
        # get page specified path
        req = CPApiRequestPagesGet.new path: '/'
        expect(crowi_client.request(req).ok).to eq true
  
        # get page specified page_id
        req = CPApiRequestPagesGet.new page_id: crowi_client.page_id(path_exp: '/')
        expect(crowi_client.request(req).ok).to eq true
  
        # get page specified path and revision_id
        reqtmp = CPApiRequestPagesList.new path_exp: '/'
        ret = crowi_client.request(reqtmp)
        page = ret&.data&.find{ |page| page.path == '/' }
        req = CPApiRequestPagesGet.new path: page.path, revision_id: page.revision._id
        expect(crowi_client.request(req).ok).to eq true
      end
    end
  
    # Test for function to create page
    it "create page" do
      body = "# crowi-client\n"
      req = CPApiRequestPagesCreate.new path: test_page_path,
              body: body
      expect(crowi_client.request(req).ok).to eq true
    end

    # Test for function to update page
    it "update page" do
      test_cases = [nil, CrowiPage::GRANT_PUBLIC, CrowiPage::GRANT_RESTRICTED,
                    CrowiPage::GRANT_SPECIFIED, CrowiPage::GRANT_OWNER]
      page_id = crowi_client.page_id(path_exp: test_page_path)
  
      body = "# crowi-client\n"
      test_cases.each do |grant| 
        body = body + grant.to_s
        req = CPApiRequestPagesUpdate.new page_id: page_id,
                body: body, grant: grant
        expect(crowi_client.request(req).ok).to eq true
      end
    end
  
    # Test for function to get the page list, which is seen
    it "get seen pages" do
      page_id = crowi_client.page_id(path_exp: test_page_path)
      req = CPApiRequestPagesSeen.new page_id: page_id
      expect(crowi_client.request(req).ok).to eq true
    end
  
    # Test for function to react LIKE
    it "add LIKE reaction" do
      page_id = crowi_client.page_id(path_exp: test_page_path)
      req = CPApiRequestLikesAdd.new page_id: page_id
      expect(crowi_client.request(req).ok).to eq true
    end
  
    # Test for function to cancel LIKE reaction
    it "remove LIKE reaction" do
      page_id = crowi_client.page_id(path_exp: test_page_path)
      req = CPApiRequestLikesRemove.new page_id: page_id
      expect(crowi_client.request(req).ok).to eq true
    end
  
    # Test for function to set update post
    it "update post" do
      req = CPApiRequestPagesUpdatePost.new path: test_page_path
      expect(crowi_client.request(req).ok).to eq true
    end

    # Test for function to check page existence
    # @todo Assure page existence.
    #       (ex. path '/' is not promises existence, and path '/tmp/#####FAKE_PATH#####' is also)
    it "check page existence" do
      aggregate_failures 'exist page, and not exist page' do
        expect(crowi_client.page_exist?( path_exp: test_page_path )).to eql(true)
        expect(crowi_client.page_exist?( path_exp: '/tmp/#####FAKE_PAGE#####' )).to eql(false)
      end
    end
  end

  describe '# API related Crowi attachments :' do

    let(:attachment_name) { '添付ファイルテスト.txt' }
    let(:attachment_body) { '添付ファイルテスト' }

    # Test for function to get attachment list
    it "get attachments list" do
      page_id = crowi_client.page_id(path_exp: test_page_path)
      req = CPApiRequestAttachmentsList.new page_id: page_id
      expect(crowi_client.request(req).ok).to eq true
    end
 
    # Test for function to add attachment
    it "add attachment" do

      # 添付ディレクトリ配下にファイルを作成してから添付ファイルをアップロード
      Dir.mktmpdir do |tmp_dir|
        attachment_file_name = File.join(tmp_dir, attachment_name)

        File.open(attachment_file_name, 'w') do |tmp_file|
          tmp_file.binmode
          tmp_file.write(attachment_body)
        end

        File.open(attachment_file_name, 'r') do |tmp_file|
          page_id = crowi_client.page_id(path_exp: test_page_path)
          req = CPApiRequestAttachmentsAdd.new page_id: page_id, file: tmp_file
          expect(crowi_client.request(req).ok).to eq true
        end
      end
    end
  
    # Test for function to check attachment existence
    it "check attachment existence" do
      expect(crowi_client.attachment_exist?(path_exp: test_page_path, 
                                            attachment_name: attachment_name)).to eql(true)
    end
 
    # Test for function to get attachment info
    it "get attachment info" do
      a = crowi_client.attachment(path_exp: test_page_path, attachment_name: attachment_name)
      expect(a.originalName).to eq attachment_name
    end

    # Test for function to remove attachment file
    it "remove attachment" do
      page_id = crowi_client.page_id(path_exp: test_page_path)
      reqtmp = CPApiRequestAttachmentsList.new page_id: page_id
      ret = crowi_client.request(reqtmp)
      attachment_id = ret.data[0]._id
      req = CPApiRequestAttachmentsRemove.new attachment_id: attachment_id
      expect(crowi_client.request(req).ok).to eq true
    end
  end
end
