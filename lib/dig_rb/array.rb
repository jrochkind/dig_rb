unless Array.respond_to?(:dig)
  Array.class_eval do
    def dig(key, *args)
      value = self.at(key)
      return value if args.length == 0 || value.nil?
      DigRb.guard_dig(value)
      value.dig(*args)
    end
  end
end