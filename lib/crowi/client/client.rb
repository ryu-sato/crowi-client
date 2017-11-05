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

  # ページIDを取得する
  def page_id(params = {})
    if (params[:path] == nil)
      return CPInvalidRequest.new "Parameter path is required."
    end
    ret = request(CPApiRequestPagesList.new path: params[:path])
    return ret.data[0].id
  end

  # ページが存在するか調べる
  # @param [String] path ページパス
  # @return [true/false] ページの存在
  def page_exist?(path: nil)
    ret = request(CPApiRequestPagesList.new path: path)
    return ret&.ok && ret&.data&.find { |page| page.path == path } != nil
  end

  # ページに添付ファイルが存在するか調べる
  # @param [String] page_id ページID
  # @param [String] attachment_name 添付ファイル名
  # @return [true/false] 添付ファイルの存在
  def attachment_exist?(path: nil, attachment_name: nil)
    ret = request(CPApiRequestAttachmentsList.new page_id: page_id(path: path))
    return ret&.ok && ret&.data&.find { |a| a.originalName == attachment_name } != nil
  end

  # 指定した添付ファイルのIDを取得する
  # @param  [String] path page's path
  # @return [String] attachment's file name
  def attachment_id(path: nil, attachment_name: nil)
      ret = request(CPApiRequestAttachmentsList.new page_id: page_id(path: path))
      return ret&.data&.find { |a| a.originalName == attachment_name }&._id
  end

  # 指定した添付ファイル情報を取得する
  # @param  [String] path page's path
  # @return [String] attachment's file name
  def attachment(path: nil, attachment_name: nil)
      ret = request(CPApiRequestAttachmentsList.new page_id: page_id(path: path))
      return ret&.data&.find { |a| a.originalName == attachment_name }
  end

end

