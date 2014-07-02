#!/usr/bin/env ruby

require "logger"
require "csv"
require "cgi"
require "tmpdir"
require "fileutils"
require "zip/zip"

class ComplianceDoc
  def initialize
    super
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end

  def build(source)

    # create tmp directory
    dir = Dir.mktmpdir
    @logger.info( "[DSU] create temp directory : #{dir}")

    # load toc_entries template
    template = File.open("toc_entries.html")
    toc_template = template.read
    template.close
    toc_entries = ""
    
    # load sheet template
    template = File.open("template.html")
    text = template.read
    template.close
    
    # parse csv file
    i = 0
    CSV.foreach(source) do |row|
      j = 0
      i += 1

      # skip line header and empty line
      next if i<3
      name = row[0]
      next if(name.nil? || name.empty?)

      # initialize map and format text
      map = {}
      row.each do |column|
        key = "c#{j}".to_sym
        if(column.nil?)
          value = ""
        else
          value = CGI::escapeHTML(column)
          value = value.gsub(/\n/,"<br/>")
        end
        map[key] = value
        j += 1
      end
      result = text % map
      
      toc_entries << toc_template % map

      # write html page
      path =  File.expand_path(name + ".html", dir)
      File.open(path, 'w') { |file| file.write(result) }
      @logger.info("[DSU] write file : #{path}")

    end
    
    

    # load index template
    template = File.open("index.html")
    text = template.read
    template.close

    map = {}
    map["entries".to_sym] = toc_entries
    result = text % map
    
    # write index.html page
    path =  File.expand_path("index.html", dir)
    File.open(path, 'w') { |file| file.write(result) }
    @logger.info("[DSU] write file : #{path}")
    
    
    # append style sheet and compress all files
    FileUtils.cp("compliance.css", dir)
    compress(dir, source.sub(/.csv/) { '.zip' })

    # remove tmp directory
    FileUtils.remove_dir(dir)
    @logger.info("[DSU] remove temp directory : #{dir}")

  end

  def compress(dir, name)
    @logger.info("[DSU] write zip file : #{name}")
    FileUtils.remove_file(name, :force => true)
    Zip::ZipFile.open(name, Zip::ZipFile::CREATE) { |zipfile|
      Dir.foreach(dir) do |item|
        next if item.start_with? "."
                                                  
	item_path = "#{dir}/#{item}"
	@logger.info("[DSU] add zip entry : #{item_path}")
	zipfile.add( item,item_path) if File.file?item_path
        
      end
    }
    File.chmod(0644,name)
  end

end

if __FILE__ == $0
  if( !ARGV[0].nil? && File.file?(ARGV[0]))
    builder = ComplianceDoc.new
    builder.build ARGV[0]
  end
end

