class MetaCheckerController < ApplicationController

  
  prepend_before_filter :load_session
  before_filter :require_login 


  def index
    @meta_checker=""
    @User = session
  end
  
  def do_stuff
    
    @input = params[:input]
    @gdoc_key = /https\:\/\/docs\.google\.com\/spreadsheets\/d\/([\w\:\.\-]*)\/(\d*)/.match(params[:input])[1].to_s
    sheet_number = /https\:\/\/docs\.google\.com\/spreadsheets\/d\/([\w\:\.\-]*)\/[^\d](\d*)/.match(params[:input])[2].to_i || 0
    #@gdoc_key = "1DmyYzsmh3oIPmm-fmiaSaoeeAS17c1pLr78TTBRqa9Q"
    if !@session.spreadsheet_by_key(@gdoc_key).worksheets[sheet_number].nil?
      @gdoc = @session.spreadsheet_by_key(@gdoc_key).worksheets[sheet_number] 
    else
      flash[:notice] = "Incorrect gdoc url"
    end
    
    
    
    
  end
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def paste_params
      params.permit(:input,:meta_checker)
    end
end
