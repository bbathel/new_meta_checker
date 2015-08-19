class MetaCheckerController < ApplicationController

  
  prepend_before_filter :load_session
  before_filter :require_login 


  def index
    @meta_checker=""
    @User = session
  end
  
  def do_stuff
    
    @input = params[:input]
    @scanner = MetaScanner.new params[:input], @session
    @scanner.get_file
    @scanner.scan_stuff
    
    
  end
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def paste_params
      params.permit(:input,:meta_checker)
    end
end
