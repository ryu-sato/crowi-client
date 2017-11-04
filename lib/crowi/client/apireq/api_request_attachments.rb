require_relative 'api_request_base'

# 添付ファイル一覧リクエスト用クラス
# @ref https://github.com/crowi/crowi/blob/master/lib/routes/attachment.js
class CPApiRequestAttachmentsList < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/attachments.list', METHOD_GET, { page_id: param[:page_id] })
  end

  # リクエストを実行する
  # @override
  # @param  [String] entry_point APIのエントリーポイントとなるURL（ex. http://localhost:3000/_api/pages.list）
  # @return [CrowiPage] リクエスト実行結果
  def execute(entry_point)
    if invalid?
      return validation_msg
    end
    ret = JSON.parse RestClient.get entry_point, params: @param
    if (ret['ok'] == false)
      return CPInvalidRequest.new "API return false with msg: #{ret['msg']}"
    end
    attachments = []
    ret['attachments'].each do |attachment|
      attachments.push(CrowiAttachment.new(attachment))
    end
    return CPApiReturn.new(ok: ret['ok'], data: attachments)
  end

protected

  # バリデーションエラーを取得する
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:page_id])
      CPInvalidRequest.new 'Parameter page_id is required.'
    end
  end

end

# 添付ファイル追加リクエスト用クラス
# @ref https://github.com/crowi/crowi/blob/master/lib/routes/attachment.js
class CPApiRequestAttachmentsAdd < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/attachments.add', METHOD_POST,
          { page_id: param[:page_id], file: param[:file] })
  end

  # リクエストを実行する
  # @override
  # @param  [String] entry_point APIのエントリーポイントとなるURL（ex. http://localhost:3000/_api/pages.list）
  # @return [String] リクエスト実行結果（JSON形式）
  def execute(entry_point)
    if invalid?
      return validation_msg
    end
    req = RestClient::Request.new(
      method: :post,
      url:    entry_point,
      payload: {
        access_token: @param[:access_token],
        page_id:      @param[:page_id],
        file:         @param[:file]
      }
    )
    ret = JSON.parse req.execute
    if (ret['ok'] == false)
      return CPInvalidRequest.new "API return false with msg: #{ret['msg']}"
    end
    return CPApiReturn.new(ok: ret['ok'], data: CrowiPage.new(ret['page']))
  end

protected

  # バリデーションエラーを取得する
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:file] && @param[:page_id])
      CPInvalidRequest.new 'Parameters file and page_id are required.'
    end
  end

end


# 添付ファイル削除リクエスト用クラス
# @ref https://github.com/crowi/crowi/blob/master/lib/routes/attachment.js
class CPApiRequestAttachmentsRemove < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/attachments.remove', METHOD_POST,
          { attachment_id: param[:attachment_id] })
  end


  # リクエストを実行する
  # @override
  # @param  [String] entry_point APIのエントリーポイントとなるURL（ex. http://localhost:3000/_api/pages.list）
  # @return [CrowiPage] リクエスト実行結果
  def execute(entry_point)
    if invalid?
      return validation_msg
    end
    ret = JSON.parse RestClient.post entry_point, @param.to_json,
                          { content_type: :json, accept: :json }
    if (ret['ok'] == false)
      return CPInvalidRequest.new "API return false with msg: #{ret['msg']}"
    end
    return CPApiReturn.new(ok: ret['ok'], data: nil)
  end

protected

  # バリデーションエラーを取得する
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:attachment_id])
      CPInvalidRequest.new 'Parameter attachment_id is required.'
    end
  end

end

