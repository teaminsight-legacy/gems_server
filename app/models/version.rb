class Version < ActiveRecord::Base
  ## Schema ##
  # :full_name,         :string,    :null => false
  # :authors,           :text,      :null => false                      # this is a serialized array
  # :number,            :string,    :null => false
  # :platform,          :string,    :null => false
  # :rubyforge_project, :string
  # :summary,           :text
  # :description,       :text
  # :prerelease,        :boolean,   :null => false, :default => false
  # :indexed,           :boolean,   :null => false, :default => false
  # :latest,            :boolean,   :null => false, :default => false
  # :rubygem_id,        :integer,   :null => false
  # :position,          :integer
  # :built_at,          :datetime
  # :created_at,        :datetime
  # :updated_at,        :datetime
  attr_accessor :spec

  include Patterns

  belongs_to :rubygem

  validates :full_name,   :presence => true, :uniqueness => { :scope => :rubygem_id }
  validates :number,      :format => { :with => /\A#{Gem::Version::VERSION_PATTERN}\z/  }
  validates :platform,    :format => { :with => NAME_PATTERN }

  serialize :authors, Array

  before_validation :pull_from_spec,  :on => :create
  before_validation :full_nameify,    :on => :create
  before_save :set_prerelease
  after_save :manage_positions
  after_destroy :manage_positions

  scope :release, where(:prerelease => false)
  scope :indexed, where(:indexed => true)

  delegate :name, :to => :rubygem, :prefix => true, :allow_nil => true

  def platform_as_number
    self.platformed? ? 0 : 1
  end

  def platformed?
    self.platform != "ruby"
  end

  def to_gem_version
    Gem::Version.new(self.number)
  end

  def <=>(other)
    self_version  = self.to_gem_version
    other_version = other.to_gem_version

    if self_version == other_version
      self.platform_as_number <=> other.platform_as_number
    else
      self_version <=> other_version
    end
  end

  protected

  def pull_from_spec
    if self.spec && self.spec.kind_of?(Gem::Specification)
      self.authors = spec.authors
      self.description = spec.description
      self.summary = spec.summary
      self.built_at = spec.date
      self.indexed = true
    end
    true
  end

  def full_nameify
    if self.rubygem
      self.full_name = [
        self.rubygem_name, self.number, (self.platform if self.platformed?)
      ].compact.join("-")
    end
    true
  end

  def set_prerelease
    self.prerelease = !!self.to_gem_version.prerelease?
    true
  end

  def manage_positions
    numbers = self.rubygem.reload.versions.sort.reverse.map(&:number).uniq

    self.rubygem.versions.each do |version|
      Version.where(:id => version.id).update_all({ :position => numbers.index(version.number) })
    end

    default = Hash.new{|h, k| h[k] = [] }
    (self.rubygem.versions.release.indexed.inject(default) do |platforms, version|
      platforms[version.platform].push(version)
      platforms
    end).each_value do |platforms|
      Version.where(:id => platforms.sort.last.id).update_all({ :latest => true })
    end
  end

  class << self

    def get(conditions = {})
      self.where(conditions).first || self.new(conditions)
    end

    def get_from_spec(spec, rubygem = nil)
      rubygem ||= Rubygem.get({ :name => spec.name })
      version = rubygem.versions.get({
        :number => spec.version.to_s,
        :platform => spec.original_platform.to_s
      })
      version.rubygem = rubygem
      version.spec = spec
      version
    end

  end
end
