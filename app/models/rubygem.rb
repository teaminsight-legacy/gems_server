class Rubygem < ActiveRecord::Base
  ## Schema ##
  # :name,        :string,  :null => false
  # :downloads,   :integer, :null => false, :default => 0
  # :slug,        :string                                   # storing of url safe name, unused in
                                                            # rubygems.org currently
  # :created_at,  :datetime
  # :updated_at,  :datetime
  attr_accessor :spec

  has_many :versions, :dependent => :destroy

  include Patterns

  validates :name, :presence => true, :uniqueness => true, :format => { :with => NAME_PATTERN }

  scope :joins_most_recent_latest_ruby_version, joins([
    "LEFT JOIN versions AS ruby_versions ON ruby_versions.rubygem_id = rubygems.id AND",
      "ruby_versions.latest = TRUE AND ruby_versions.platform = 'ruby'",
    "LEFT JOIN versions AS rv_excluder ON rv_excluder.rubygem_id = rubygems.id AND",
      "rv_excluder.latest = TRUE AND rv_excluder.platform = 'ruby' AND",
      "rv_excluder.id <> ruby_versions.id AND rv_excluder.position > ruby_versions.position"
  ].join(" ")).where("rv_excluder.id IS NULL")
  scope :joins_most_recent_latest_version, joins([
    "LEFT JOIN versions AS latest_versions ON latest_versions.rubygem_id = rubygems.id AND",
      "latest_versions.latest = TRUE",
    "LEFT JOIN versions AS lv_excluder ON lv_excluder.rubygem_id = rubygems.id AND",
      "lv_excluder.latest = TRUE AND",
      "lv_excluder.id <> latest_versions.id AND lv_excluder.position > latest_versions.position"
  ].join(" ")).where("lv_excluder.id IS NULL")
  scope :joins_most_recent_version, joins([
    "LEFT JOIN versions ON versions.rubygem_id = rubygems.id",
    "LEFT JOIN versions AS v_excluder ON v_excluder.rubygem_id = rubygems.id AND",
      "v_excluder.id <> versions.id AND v_excluder.position > versions.position"
  ].join(" ")).where("v_excluder.id IS NULL")
  scope :order_by_name, order("LOWER(rubygems.name)")

  class << self

    def get(conditions = {})
      self.where(conditions).first || self.new(conditions)
    end

    def get_from_spec(spec)
      rubygem = self.get({ :name => spec.name })
      rubygem.spec = spec
      rubygem
    end

    def with_most_recent_version
      select_sql = [ :number, :description, :summary ].collect do |column|
        [ "COALESCE(ruby_versions.#{column}, ruby_versions.#{column}, versions.#{column})",
          "AS version_#{column}"
        ].join(" ")
      end
      scope = self.select(select_sql.unshift("rubygems.*"))
      scope = scope.joins_most_recent_latest_ruby_version
      scope.joins_most_recent_latest_version.joins_most_recent_version
    end

  end
end
