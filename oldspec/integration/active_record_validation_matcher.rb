module ActiveRecordValidationMatcher
  class RequireA
    def initialize(expected)
      @expected = expected
    end

    def matches?(target)
      @target = target
      @target.send("#{@expected}=", nil)
      @target.valid?
      @target.errors.on(@expected) == I18n.translate('activerecord.errors.messages')[:blank]
    end

    def failure_message
      "expected #{@target.inspect} to require presence of #{@expected}"
    end

    def negative_failure_message
      "expected #{@target.inspect} not to require presence of #{expected}"
    end
  end
  
  class RequireMinimum
    def initialize(expected, length = 1)
      @expected = expected
      @length = length
    end

    def matches?(target)
      @target = target
      @target.send("#{@expected}=", nil)
      @target.valid?
      @target.errors.on(@expected) == I18n.translate('activerecord.errors.messages')[:too_short] % @length
    end

    def failure_message
      "expected #{@target.inspect} to require #{@expected} at least #{@length} character long"
    end

    def negative_failure_message
      "expected #{@target.inspect} not require #{expected} at least #{@length} character long"
    end
  end
  
  def require_a(expected)
    RequireA.new(expected) 
  end
  
  def require_an(expected)
    RequireA.new(expected)
  end
  
  def require_some(expected)
    RequireA.new(expected)
  end
  
  def require_minimum(expected, length = 1)
    RequireMinimum.new(expected, length)
  end
end