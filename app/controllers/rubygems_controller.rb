class RubygemsController < InheritedResources::Base
  actions :index
  respond_to :html, :only => [ :index ]

  protected

  def collection
    unless @rubygems
      @view = RubygemsHelper::RubygemsIndex.new(params[:page])
      @rubygems ||= view.rubygems
    end
    @rubygems
  end

end
