class SprintAuditSweeper < ActionController::Caching::Sweeper #:nodoc:
  observe SprintElement
  
  def after_create(record)
    record.send(:audit_create, current_user)
  end

  def after_destroy(record)
    record.send(:audit_destroy, current_user)
  end

  def before_update(record)
    record.send(:audit_update, current_user)
  end

  def current_user
    controller.send :current_user if controller.respond_to?(:current_user)
  end

end