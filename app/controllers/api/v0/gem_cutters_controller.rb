class Api::V0::GemCuttersController < ApplicationController
  
  def create
    respond_to do |format|
      if self.build_resource.save
        format.any { redirect_to "/" }
      else
        format.any  { render :action => "new" }
      end
    end
  end

  protected
  
  def build_resource
    @gem_cutter ||= end_of_association_chain.new
  end

end

=begin
return "Please ensure #{File.expand_path(Geminabox.data)} is writable by the geminabox web server." unless File.writable? Geminabox.data
    unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
      @error = "No file selected"
      return erb(:upload)
    end

    tmpfile.binmode

    Dir.mkdir(File.join(options.data, "gems")) unless File.directory? File.join(options.data, "gems")

    dest_filename = File.join(options.data, "gems", File.basename(name))


    if Geminabox.disallow_replace? and File.exist?(dest_filename)
      existing_file_digest = Digest::SHA1.file(dest_filename).hexdigest
      tmpfile_digest = Digest::SHA1.file(tmpfile.path).hexdigest

      if existing_file_digest != tmpfile_digest
        return error_response(409, "Gem already exists, you must delete the existing version first.")
      else
        return [200, "Ignoring upload, you uploaded the same thing previously."]
      end
    end

    File.open(dest_filename, "wb") do |f|
      while blk = tmpfile.read(65536)
        f << blk
      end
    end
    reindex
    redirect "/"
=end