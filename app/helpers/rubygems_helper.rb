module RubygemsHelper

  class RubygemsIndex
    attr_accessor :page

    def initialize(page = nil)
      self.page = (page || 1)
    end

    def rubygems
      @rubygems ||= RubygemDecorator.decorate(self.actual_rubygems)
    end

    def page_start_at
      @page_start_at ||= ((self.page - 1) * self.gems_per_page) + 1
    end
    def gems_per_page
      @gems_per_page ||= 50
    end
    def total_number_of_gems
      @total_number_of_gems ||= Rubygem.count
    end

    protected

    def actual_rubygems
      unless @actual_rubygems
        scope = Rubygem.with_most_recent_version.order_by_name
        scope = scope.limit(self.gems_per_page).offset(self.page_start_at)
        @actual_rubygems = scope.all
      end
      @actual_rubygems
    end

  end

end
