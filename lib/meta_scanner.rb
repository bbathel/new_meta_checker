class MetaScanner
  attr_accessor :gdoc, :file
  
  def initialize input, session
    sheet_or_doc = /(spreadsheets|document)/
    key = /d\/([\d\w\-]+)/
    sheet_number = /gid\=(\d+)/
    @session = session
    temp_sheet_number = if !sheet_number.match(input).nil? then sheet_number.match(input)[1].to_i else 0 end
    @gdoc = {
              url: input,
              type: sheet_or_doc.match(input)[0],
              key: key.match(input)[1].to_s,
              sheet_number: temp_sheet_number
            }
  end
  
  def get_file
    if self.gdoc[:type] === "spreadsheets"
      @file = @session.spreadsheet_by_key(@gdoc[:key]).worksheets[@gdoc[:sheet_number]] 
    elsif self.gdoc[:type] === "document"
      @file = @session.file_by_url(@gdoc[:url]).export_as_string('text/plain')
    end
  end
  
  
  def scan_stuff
    if self.gdoc[:type] === "spreadsheets"
      @meta = MetaImageScanner.new(@file)
    elsif self.gdoc[:type] === "document"
      @meta = ""
    end
  end  
  
  
=begin  
if !@session.spreadsheet_by_key(gdoc_key).worksheets[sheet_number].nil?
      @gdoc = @session.spreadsheet_by_key(gdoc_key).worksheets[sheet_number] 
    else
      "incorrect gdoc url"
    end
=end
end