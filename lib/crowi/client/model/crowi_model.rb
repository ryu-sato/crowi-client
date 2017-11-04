require 'singleton'

require 'crowi/client/model/crowi_model_base'
require 'crowi/client/model/crowi_page'
require 'crowi/client/model/crowi_page_revision'
require 'crowi/client/model/crowi_user'
require 'crowi/client/model/crowi_attachment'

# Crowi model factory class
# @abstract include singleton class
# @attr_reader makers Model maker list
class CrowiModelFactory
  include Singleton
  attr_reader :makers

  # Constractor
  def initialize
    @makers = {}
    @makers.default = Proc.new { |param|
      next nil if param == nil
      case param
      when Array, String, Integer then
        ret = param
      when FalseClass then
        ret = false
      when TrueClass then
        ret = true
      end
      next ret
    }
  end

  # Register model maker
  # @param [Hash] Model factory list
  def register(makers = {})
    makers.each do |model_name, model_make_proc|
      unless model_make_proc.is_a?(Proc)
        raise ArgumentError.new('Maker is required sub class of Class.')
      end
    end
    @makers.merge!(makers)
  end

  # Get model maker
  # @param [String] model_name Model name
  # @return [Proc] Model maker
  def maker(model_name)
    return @makers[model_name&.to_sym]
  end

end

