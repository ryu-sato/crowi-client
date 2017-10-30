# APIリクエストのバリデーションエラー
# @note rescue する必要はないので Exception クラスは継承しない
class CPInvalidRequest
  attr_reader :msg

  # コンストラクタ
  # @param [String] msg エラーメッセージ（原因と対策が分かるとよい）
  def initialize(msg)
    @msg = msg
  end

  def to_s
    return @msg
  end
end

# APIリクエストの基本クラス
class CPApiRequestBase
  METHOD_GET = "GET"
  METHOD_POST = "POST"
  attr_reader :entry_point, :method, :param

  # コンストラクタ
  # @param [String] entry_point APIリクエストのエントリポイントとなるURLパス(ex. '/page.list')
  # @param [Enumerator] method APIリクエストのタイプ
  # @param [Hash] param APIリクエストのパラメータ
  def initialize(entry_point, method, param = {})
    @entry_point = entry_point
    @method = method
    @param = param.reject { |k, v| !v }
  end

  # パラメータを代入
  # @param [Hash] param APIリクエストのパラメータ
  def param=(param = {})
    @param = param
  end

  # パラメータのバリデーションチェックを行う
  # @return [true/false] バリデーションチェック結果
  def valid?
    return (!_invalid)
  end

  # バリデーションエラーの説明
  # @return [String] バリデーションエラーの説明
  def validation_msg
    return _invalid&.to_s
  end

  # リクエストを実行する
  # @param  [String] entry_point APIのエントリーポイントとなるURL（ex. http://localhost:3000/_api/pages.list）
  # @return [String] リクエスト実行結果（JSON形式）
  def execute(entry_point)
    RestClient.log = 'stdout'
    if ! valid?
      return validation_msg
    end

    case @method
    when 'GET'
      return RestClient.get entry_point, params: @param
    when 'POST'
      return RestClient.post entry_point, @param.to_json,
                             { content_type: :json, accept: :json }
    end
  end

protected

  # バリデーションエラーを取得する
  # @return [nil/CPInvalidRequest] バリデーションエラー結果
  def _invalid
    return CPInvalidRequest "Invalid API request.";
  end

end

