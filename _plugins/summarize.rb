module Jekyll
  module Filters
    def summarize(str, splitstr = /\s*<!-- more -->/)
      str.split(splitstr)[0]
    end
    
    def not_summary(str, splitstr = /\s*<!-- more -->/)
      str.split(splitstr)[1]
    end
  end
end
