module Mail
  class Scanner
    def self.scan text, &block
      new(text).instance_exec(&block)
    end

    def initialize text
      @text  = text
      @lines = text.split("\n").map(&:strip)
    end

    def scan_to exp=nil, &cond
      cond ||= ->(l) { l =~ exp }
      passed = []
      while line = @lines.shift
        if result = cond.call(line)
          return passed, result
        elsif line.present? && !link?(line)
          passed.push line
        end
      end
    end

    def link? line
      line =~ /https?:\/\//
    end
  end
end
