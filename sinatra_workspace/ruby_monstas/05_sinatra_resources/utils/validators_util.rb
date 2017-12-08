class NameValidator
  def initialize(name, names)
    @name = name.to_s
    @names = names
  end

  def valid?
    validate
    @message.nil?
  end

  def message
    @message
  end

  private

  def validate
    if @name.empty?
      @message = "A name is needed"
    elsif @names.include?(@name)
      @message = "name already logged"
    end
  end
end