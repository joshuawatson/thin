module Thin
  # Acts like a Hash, but allows duplicated keys
  class Headers
    @@allowed_duplicates = %w(Set-Cookie Set-Cookie2 Warning WWW-Authenticate)
    
    def initialize
      @sent = {}
      @items = []
    end

    def []=(key, value)
      if @sent.has_key?(key) && !@@allowed_duplicates.include?(key)
        # If we don't allow duplicate for that field
        # we overwrite the one that is already there
        @items.assoc(key)[1] = value
      else
        @sent[key] = true
        @items << [key, value]
      end
    end
    
    def [](key)
      if item = @items.assoc(key)
        item[1]
      end
    end
    
    def size
      @items.size
    end
    
    def to_s
      @items.inject('') { |out, (name, value)| out << HEADER_FORMAT % [name, value] }
    end
  end
end