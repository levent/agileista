module ActiveRecordAssociationMatcher
  class AbstractAssociationMatcher
    def initialize(expected)
      @expected = expected
      @expected_options = {}
    end

    def matches?(target)
      @target = target
      begin
        reflection = @target.class.reflect_on_association(@expected)
        if reflection.macro.eql?(expected_macro)
          actual_options = reflection.options
          @expected_options.each do |key, value|
            return false unless actual_options.has_key?(key)
            return false unless actual_options[key] == value
          end
          return true
        else
          return false
        end
            
      rescue
        return false
      end
    end
    
    def with(options)
      @expected_options.merge!(options)
      return self
    end

    def failure_message
      message = "expected #{@target.class} to #{expected_macro_description} #{@expected}"
      message << " with #{@expected_options.inspect}" if @expected_options.any?
      return message
    end

    def negative_failure_message
      message = "expected #{@target.class} not to #{expected_macro_description} #{@expected}"
      message << " with #{@expected_options.inspect}" if @expected_options.any?
      return message
    end
  end
  
  class BelongTo < AbstractAssociationMatcher
    def expected_macro
      :belongs_to
    end
    
    def expected_macro_description
      "belong to"
    end
  end
  
  class HaveMany < AbstractAssociationMatcher
    def expected_macro
      :has_many
    end
    
    def expected_macro_description
      "have many"
    end
  end
  
  class HaveAndBelongToMany < AbstractAssociationMatcher
    def expected_macro
      :has_and_belongs_to_many
    end
    
    def expected_macro_description
      "have and belong to many"
    end
  end
  
  class HaveOne < AbstractAssociationMatcher
    def expected_macro
      :has_one
    end
    
    def expected_macro_description
      "have one"
    end
  end

  def belong_to(expected)
    BelongTo.new(expected) 
  end
  
  def have_many(expected)
    HaveMany.new(expected)
  end
  
  def have_and_belong_to_many(expected)
    HaveAndBelongToMany.new(expected)
  end
  
  def have_one(expected)
    HaveOne.new(expected)
  end
end