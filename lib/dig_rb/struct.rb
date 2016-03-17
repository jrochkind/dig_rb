unless Struct.instance_methods.include?(:dig)
  Struct.class_eval do

    # Extracts the nested value specified by the sequence of <i>idx</i>
    # objects by calling +dig+ at each step, returning +nil+ if any
    # intermediate step is +nil+.

    #    klass = Struct.new(:a)
    #    o = klass.new(klass.new({b: [1, 2, 3]}))

    #    o.dig(:a, :a, :b, 0)              #=> 1
    #    o.dig(:b, 0)                      #=> nil
    def dig(key, *args)
      value = if key.respond_to?(:to_sym)
                return nil unless self.respond_to?(key.to_sym)
                self.send(key.to_sym)
              elsif key.respond_to?(:to_int)
                return nil unless self.length >= key.to_int + 1
                self[key.to_int]
              else
                raise TypeError, "no implicit conversion of #{key.class} into Integer"
              end

      return value if args.length == 0 || value.nil?
      DigRb.guard_dig(value)
      value.dig(*args)
    end
  end
end
