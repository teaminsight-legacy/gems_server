class Import
  attr_accessor :mode
  attr_accessor :path

  def initialize(mode, args = {})
    self.mode = mode
    self.parse_args_for_mode(args)
    self.validate!
  end

  def validate!
    case(self.mode)
    when :local
      raise(ArgumentError, "A path is required to locally import") if self.path.blank?
    end
  end

  def process
    gems = Dir[File.join(self.path, "*.gem")].sort
    puts "Processing #{gems.size} gems..."
    gems.each do |path|
      print "  cutting: #{File.basename(path)} ... "
      gemcutter = GemCutter.new(File.open(path).read)
      if gemcutter.pull_spec && gemcutter.find && gemcutter.save
        print "successful\n"
      else
        print "failed\n"
        puts " -- #{gemcutter.error}"
      end
    end
    puts "Done."
  end

  protected

  def parse_args_for_mode(args)
    case(self.mode)
    when :local
      self.path = File.expand_path(args[:path]) if !args[:path].blank?
    end
  end

  class << self

    def local(args)
      self.new(:local, args)
    end

  end
end
