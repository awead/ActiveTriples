module ActiveTriples
  class NodeConfig
    attr_accessor :predicate, :term, :class_name, :type, :behaviors, :multivalue, :cast

    def initialize(term, predicate, args={})
      self.term = term
      self.predicate = predicate
      self.class_name = args.delete(:class_name)
      self.multivalue = args.delete(:multivalue) { true }
      self.cast = args.delete(:cast) { true }
      raise ArgumentError, "Invalid arguments for Rdf Node configuration: #{args} on #{predicate}" unless args.empty?
      yield(self) if block_given?
    end

    def [](value)
      value = value.to_sym
      self.respond_to?(value) ? self.send(value) : nil
    end

    def class_name
      return nil if @class_name.nil?
      raise "class_name for #{term} is a #{@class_name.class}; must be a class" unless @class_name.kind_of? Class or @class_name.kind_of? String
      if @class_name.kind_of?(String)
        begin
          new_class = @class_name.constantize
          @class_name = new_class
        rescue NameError
        end
      end
      @class_name
    end

    def with_index (&block)
      # needed for solrizer integration
      iobj = IndexObject.new
      yield iobj
      self.type = iobj.data_type
      self.behaviors = iobj.behaviors
    end

    # this enables a cleaner API for solr integration
    class IndexObject
      attr_accessor :data_type, :behaviors
      def initialize
        @behaviors = []
        @data_type = :string
      end
      def as(*args)
        @behaviors = args
      end
      def type(sym)
        @data_type = sym
      end
      def defaults
        :noop
      end
    end
  end
end

