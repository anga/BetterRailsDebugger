class BaseLangParser
  def initialize(path, options)
    @path, @options = path, options
  end

  def analize
    raise NotImplementedError
  end
end