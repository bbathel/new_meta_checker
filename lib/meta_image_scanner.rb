class MetaImageScanner
  
  def initialize spreadsheet
    @sheet = spreadsheet
  end
  
  def pull_data
    page_content_hash = assemble_page_content_hash(collect_live_urls)
    
  end
  
  
  def collect_live_urls
    live_urls = []
    for row in 1..@sheet.num_rows
      live_urls.push(@sheet[row, 1]) if /http/ =~ @sheet[row, 1]
    end
    return live_urls
  end
  
  def assemble_page_content_hash(urls)
    page_content_hash = {}
      urls.each do |url|
        page_content = pull_page_content(url)
        page_content_hash[url] = page_content
      end
    return page_content_hash
  end
  
end
