require 'crowi/client/model/crowi_model'

# Crowi Attachment model class
class CrowiAttachment < CrowiModelBase
  attr_reader :_id, :fileFormat, :fileName, :originalName, :filePath,
              :creator, :page, :__v, :createdAt, :fileSize, :url

  # Constractor
  # @param [Hash] Attachment model shown as hash
  # @todo Except running register method always called parse method.
  def initialize(params = {})
    init_params = {
      _id: nil, fileFormat: '', fileName: '', originalName: '', filePath: nil,
      creator: nil, page: '', __v: 0, createdAt: '', fileSize: 0, url: ''
    }

    params = init_params.merge(params.map { |k,v| [k.to_sym, v] }.to_h)
    if (params[:_id] == nil)
      raise ArgumentError.new('Parameters id is required.')
    end

    CrowiModelFactory.instance.register({
      attachment_creator:   Proc.new { |param| param != nil && param.is_a?(String) ? param : CrowiUser.new(param) },
      attachment_createdAt: Proc.new { |date_str|
                              date_str != nil && DateTime.parse(date_str) },
    })
    maked_params = {}
    params.each do |k,v|
      maker = CrowiModelFactory.instance.maker('attachment_' + k.to_s)
      maked_params[k] = maker.call(v)
    end
    super(maked_params)
  end

end

