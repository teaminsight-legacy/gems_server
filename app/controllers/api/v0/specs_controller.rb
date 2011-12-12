class Api::V0::SpecsController < ApplicationController
  
  def index
    send_file "/Users/jcr/Downloads/gems/specs.4.8.gz"
  end
  
  def prerelease
    send_file "/Users/jcr/Downloads/gems/prerelease_specs.4.8.gz"
  end
  
end
