module Jekyll
  module Filters
    def summarize(str, splitstr = /\s*<!-- more -->/)
      str.split(splitstr)[0]
    end
  end
end
