require_relative 'api_request_base'

# ページ一覧リクエスト用クラス
# @ref https://github.com/weseek/crowi-plus/blob/master/lib/routes/page.js
class CPApiRequestPagesList < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/pages.list', METHOD_GET,
          { path: param[:path], user: param[:user] })
  end

protected

  # バリデーションエラーを取得する
  # @override
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:path] || @param[:user])
      return CPInvalidRequest.new 'Parameter path or page_id is required.'
    end
  end

end


# ページ取得リクエスト用クラス
# @ref https://github.com/weseek/crowi-plus/blob/master/lib/routes/page.js
class CPApiRequestPagesGet < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/pages.get', METHOD_GET,
          { page_id: param[:page_id], 
            path: param[:path], revision_id: param[:revision_id] })
  end

protected

  # バリデーションエラーを取得する
  # @override
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:path] || @param[:page_id]) 
      return CPInvalidRequest.new 'Parameter path or page_id is required.'
    end
  end

end


# ページ作成リクエスト用クラス
# @ref https://github.com/weseek/crowi-plus/blob/master/lib/routes/page.js
class CPApiRequestPagesCreate < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/pages.create', METHOD_POST,
          { body: param[:body], path: param[:path], grant: param[:grant] })
  end

protected

  # バリデーションエラーを取得する
  # @override
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:body] && @param[:path]) 
      return CPInvalidRequest.new 'Parameters body and path are required.'
    end
  end

end

# ページ更新リクエスト用クラス
# @ref https://github.com/weseek/crowi-plus/blob/master/lib/routes/page.js
class CPApiRequestPagesUpdate < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/pages.update', METHOD_POST,
          { body: param[:body], page_id: param[:page_id],
            revision_id: param[:revision_id], grant: param[:grant] })
  end

protected

  # バリデーションエラーを取得する
  # @override
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:page_id] && @param[:body]) 
      return CPInvalidRequest.new 'Parameters page_id and body are required.'
    end
  end

end

# ページ閲覧済マークを付与リクエスト用クラス
# @ref https://github.com/weseek/crowi-plus/blob/master/lib/routes/page.js
# @note 詳細不明
class CPApiRequestPagesSeen < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/pages.seen', METHOD_POST, { page_id: param[:page_id] })
  end

protected

  # バリデーションエラーを取得する
  # @override
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:page_id]) 
      return CPInvalidRequest.new 'Parameter page_id required.'
    end
  end

end

# ライクページ指定リクエスト用クラス
# @ref https://github.com/weseek/crowi-plus/blob/master/lib/routes/page.js
class CPApiRequestLikesAdd < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/likes.add', METHOD_POST, { page_id: param[:page_id] })
  end

protected

  # バリデーションエラーを取得する
  # @override
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:page_id]) 
      return CPInvalidRequest.new 'Parameter page_id required.'
    end
  end

end

# ライクページ指定解除リクエスト用クラス
# @ref https://github.com/weseek/crowi-plus/blob/master/lib/routes/page.js
class CPApiRequestLikesRemove < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/likes.remove', METHOD_POST, { page_id: param[:page_id] })
  end

protected

  # バリデーションエラーを取得する
  # @override
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:page_id]) 
      return CPInvalidRequest.new 'Parameter page_id required.'
    end
  end

end

# 更新ページ一覧リクエスト用クラス
# @ref https://github.com/weseek/crowi-plus/blob/master/lib/routes/page.js
# @note notification for 3rd party tool (like Slack)
class CPApiRequestPagesUpdatePost < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    super('/_api/pages.updatePost', METHOD_GET, { path: param[:path] })
  end

protected

  # バリデーションエラーを取得する
  # @override
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:path]) 
      return CPInvalidRequest.new 'Parameter path required.'
    end
  end

end

# ページ削除リクエスト用クラス（API利用不可）
# @ref https://github.com/weseek/crowi-plus/blob/master/lib/routes/page.js
class CPApiRequestPagesRemove < CPApiRequestBase

  # コンストラクタ
  # @override
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(param = {})
    raise Exception, 'API of pages.remove is forbidden'
    super('/_api/pages.remove', METHOD_GET,
          { page_id: param[:page_id], revision_id: param[:revision_id] })
  end

protected

  # バリデーションエラーを取得する
  # @override
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    if ! (@param[:page_id] || @param[:revision_id]) 
      return CPInvalidRequest.new 'Parameter page_id or revision_id is required.'
    end
  end

end

