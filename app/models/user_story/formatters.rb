module UserStory::Formatters
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def to_csv
      CSV.generate do |csv|
        csv << columns = [:id, :definition, :description, :stakeholder, :story_points, :updated_at, :created_at].map(&:to_s)
        all.each do |product|
          csv << product.attributes.values_at(*columns)
        end
      end
    end
  end
end
