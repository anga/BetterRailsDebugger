class Parser
  def initialize(path, options)
    @path = path
    @options = options
  end

  def self.analize(path, options)
    self.new(path, options).run
  end

  def run
    # Check if file exist or not
    raise ArgumentError.new "File #{@path} does not exist" if !File.exist? @path
    # Detect lang by file ext
    lang = get_lang_from_path
    raise ArgumentError.new "Sorry, we do not support that language" if lang != 'ruby' # Only ruby by the moment
    # Create lang instance with options
    lang_instance = get_lang_instance lang
    # parse
  end

  # get file ext and return language as 'ruby', 'javascript', 'php' or nil if unknown
  def get_lang_from_path
    case File.extname(@path).downcase
      when '.rb'
        'ruby'
      when '.js'
        'javascript'
      when '.php'
        'php'
      else
        nil
    end
  end

  def get_lang_instance
    # TODO
  end
end