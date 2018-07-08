require 'rest-client'
require 'json'
require 'yaml'
require 'uri'

require 'crowi/client/apireq/api_request_pages'
require 'crowi/client/apireq/api_request_attachments'

# Crowi のクライアントクラス
class CrowiClient

  # コンストラクタ
  def initialize(crowi_url: '', access_token: '')
    raise ArgumentError, 'Config `crowi_url` is required.'    if crowi_url.empty?
    raise ArgumentError, 'Config `access_token` is required.' if access_token.empty?

    @crowi_url = crowi_url
    @access_toke = access_token
    @cp_entry_point = URI.join(crowi_url, '/_api/').to_s
  end

  # APIリクエストを送信する
  # @param [ApiRequestBase] req APIリクエスト
  # @return [String] APIリクエストの応答（JSON形式）
  def request(req)
    req.param[:access_token] = @access_toke
    return req.execute URI.join(@cp_entry_point, req.entry_point).to_s
  end

  # ページIDを取得する
  # @param [String] path_exp ページパス
  # @return [String] ページID
  def page_id(path_exp: nil)
    ret = request(CPApiRequestPagesList.new path_exp: path_exp)
    return nil if (ret.kind_of? CPInvalidRequest || ret.data.nil?)
    return ret.data.find { |page| URI.unescape(page.path) == path_exp }&.id
  end

  # ページが存在するか調べる
  # @param [String] path ページパス
  # @return [true/false] ページの存在
  def page_exist?(path_exp: nil)
    ret = request(CPApiRequestPagesList.new path_exp: path_exp)
    return ret&.ok && ret&.data&.find { |p| p.path.match(path_exp) } != nil
  end

  # ページに添付ファイルが存在するか調べる
  # @param [String] path_exp ページパス（正規表現）
  # @param [String] attachment_name 添付ファイル名
  # @return [true/false] 添付ファイルの存在
  def attachment_exist?(path_exp: nil, attachment_name: nil)
    ret = request(CPApiRequestAttachmentsList.new page_id: page_id(path_exp: path_exp))
    return ret&.ok && ret&.data&.find { |a| a.originalName == attachment_name } != nil
  end

  # 指定した添付ファイルのIDを取得する
  # @param  [String] path_exp ページパス（正規表現）
  # @return [String] attachment's file name
  def attachment_id(path_exp: nil, attachment_name: nil)
      ret = request(CPApiRequestAttachmentsList.new page_id: page_id(path_exp: path_exp))
      return ret&.data&.find { |a| a.originalName == attachment_name }&._id
  end

  # 指定した添付ファイル情報を取得する
  # @param  [String] path_exp ページパス（正規表現）
  # @return [String] attachment's file name
  def attachment(path_exp: nil, attachment_name: nil)
      ret = request(CPApiRequestAttachmentsList.new page_id: page_id(path_exp: path_exp))
      return ret&.data&.find { |a| a.originalName == attachment_name }
  end

end

