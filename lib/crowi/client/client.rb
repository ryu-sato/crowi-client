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
  def request(req)
    req.param[:access_token] = EasySettings['token'] 
    req.execute URI.join(@cp_entry_point, req.entry_point).to_s
  end

end
