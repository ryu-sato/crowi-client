require 'singleton'
require 'rest-client'
require 'json'
require 'yaml'
require "easy_settings"

require 'crowi/client/apireq/api_request_pages'
require 'crowi/client/apireq/api_request_attachments'

# Crowi のクライアントクラス
class CrowiClient
  include Singleton

  # コンストラクタ（シングルトン）
  def initialize
    raise ArgumentError, 'Config url is required.'   unless EasySettings['url']
    raise ArgumentError, 'Config token is required.' unless EasySettings['token']
    @cp_entry_point = URI.join(EasySettings['url'], '/_api/').to_s
  end

  # APIリクエストを送信する
  # @param [ApiRequestBase] req APIリクエスト
  # @return [String] APIリクエストの応答（JSON形式）
  def request(req)
    req.param[:access_token] = EasySettings['token'] 
    return req.execute URI.join(@cp_entry_point, req.entry_point).to_s
  end

  # ページが存在するか調べる
  # @param [String] path ページパス
  # @param [String] page_id ページID
  # @return [true/false] ページの存在
  def page_exist?(path: nil, page_id: nil)
    req = CPApiRequestPagesGet.new path: path, page_id: page_id
    begin
      ret = JSON.parse request(req)
      return (ret['page'] && ret['page']['id'])
    rescue JSON::ParserError => e
      puts "ERROR is occured: #{e}"
      return false
    end
  end
end
