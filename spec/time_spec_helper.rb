unless Time.respond_to?(:original_now)
  class Time
    class << self
      alias original_now now
    end
 
    def self.travel_to(time = Time.now, &block)
      @now = time
      yield
    ensure
      @now = nil
    end
  
    def self.freeze(&block)
      travel_to Time.now, &block
    end
  
    def self.now
      @now || original_now
    end
  end
end
