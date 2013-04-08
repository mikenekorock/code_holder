require "csv"

module Railstar
  class DuplicateValue < Exception; end
  class DuplicatePosition < Exception; end
  class UndefinedCode < Exception; end

  class CodeHolder < Hash
    def initialize(code_dir=nil)
      @code_dir = code_dir || "./config/resources/code"
    end

    def method_missing(name, *args)
      self[name] ||= load(name, *args)
    end

    def load(name, options={})
      CodeList.new(name, @code_dir)
    end

    def codes
      dirs = Dir.glob(File.join(@code_dir, "*.csv"))
      files = []
      dirs.each do |dir|
        files << dir.split("/").last
      end
      files.sort.uniq.map{|a| a.sub(/.csv$/, "")}
    end
  end

  class CodeList < Hash
    def initialize(name, code_dir)
      puts "LOAD code #{name}"
      super(nil)

      @order = []
      @type = {}

      mode = "config"
      CSV.foreach(search_file(name, code_dir), :encoding => "UTF-8") do |row|
        if mode == "config"
          if row.first == "type"
            @type[row[1].to_sym] = row[2]
          end
          mode = "header" if row.first == "#DATA"
        elsif mode == "header"
          @headers = row.map(&:to_sym)
          mode = "data"
        elsif mode == "data" && (row.first != "") && (row.first != nil)
          code = Code.new(@headers.zip(row).flatten, @type)
          raise DuplicateValue, code.value if self[code.value]
          self[code.value.to_s] = code
          self.instance_eval <<-EOS
            def #{code.key}
              self["#{code.value}"]
            end
          EOS
          if code.position != "" && code.position != nil
            raise DuplicatePosition if @order[code.position]
            @order[code.position] = code.value
          end
        end
      end
      @order.compact!
    end

    def headers
      @headers
    end

    def search_file(name, code_dir)
      files = [ File.join(code_dir, "#{name}.csv") ]
      files.each do |file|
        return file if File.exist?(file)
      end
      raise UndefinedCode, "not found #{files}"
    end

    def to_opt(value=:name)
      @order.map{|k| [self[k].data(value), self[k]] }
    end
  end

  class Code < String
    def initialize(args, type={})
      @data = Hash[*args]
      @type = type
      super(@data[:value])
    end

    def data(key)
      @data[key.to_sym]
    end

    def position
      @data[:position].to_i
    end

    def method_missing(name, *args)
      case @type[name]
      when "integer"
        @data[name.to_sym].to_i
      else
        @data[name.to_sym]
      end
    end
  end
end

C = Railstar::CodeHolder.new

