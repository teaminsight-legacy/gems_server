class GemCutter
  attr_accessor :body, :user
  attr_accessor :rubygem, :version, :spec
  attr_accessor :error

  def initialize(body, user = nil)
    self.body = body
    self.user = user
  end

  def pull_spec
    Gem::Package.open(StringIO.new(body), "r", nil) do |pkg|
      self.spec = pkg.metadata
      return true
    end
    false
  rescue Gem::Package::FormatError
    # TODO: use validations style instead
    #notify("RubyGems.org cannot process this gem.\nPlease try rebuilding it" +
    #       " and installing it locally to make sure it's valid.", 422)
  rescue Exception => e
    # TODO: use validations style instead
    #notify("RubyGems.org cannot process this gem.\nPlease try rebuilding it" +
    #       " and installing it locally to make sure it's valid.\n" +
    #       "Error:\n#{e.message}\n#{e.backtrace.join("\n")}", 422)
  end

  def find
    self.rubygem = Rubygem.get_from_spec(spec)
    self.version = Version.get_from_spec(spec, self.rubygem)

    if self.version.new_record?
      true
    else
      # TODO: use validations style instead
      #notify("Repushing of gem versions is not allowed.\n" +
      #       "Please use `gem yank` to remove bad gem releases.", 409)
      false
    end
  end

  def save
    if self.update
      #@indexer.write_gem @body, @spec TODO
      #after_write
      #notify("Successfully registered gem: #{version.to_title}", 200)
      true
    else
      puts self.rubygem.errors.full_messages.inspect
      puts self.version.errors.full_messages.inspect
      false
    end
  end

  protected

  def update
    self.rubygem.save! && self.version.save!
  end

end
