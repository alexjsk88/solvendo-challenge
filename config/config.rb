# frozen_string_literal: true

# Config class to load ENV
class Config
  SYSTEM_LABEL = 'SOLVENDO__'

  def self.load_config
    configs = {}
    configs.merge!(configs(default_configs))
    configs.merge!(configs(ENV))
    configs
  end

  def self.configs(config_list)
    configs = {}
    config_list.each do |plain_config_pair|
      config_pair = extract_single_config(plain_config_pair)
      next unless config_pair

      configs[config_pair[0]] = config_pair[1]
    end
    configs
  end

  def self.default_configs
    File.read('.env.default').split.map do |plain_config|
      config = plain_config.split('=')
      [config[0], config[1]]
    end
  rescue StandardError
    []
  end

  def self.extract_single_config(pair)
    key = pair[0]
    value = pair[1]
    return [key.sub(SYSTEM_LABEL, ''), value] if key.start_with?(SYSTEM_LABEL)

    nil
  end
end
