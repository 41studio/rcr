module Apipie
  module Validator
    class HashValidator < BaseValidator
      include Apipie::DSL::Base
      include Apipie::DSL::Param

      def self.build(param_description, argument, options, block)
        self.new(param_description, block, options[:param_group]) if block.is_a?(Proc) && block.arity <= 0 && argument == Hash
      end

      def initialize(param_description, argument, param_group)
        super(param_description)
        @proc = argument
        @param_group = param_group
        self.instance_exec(&@proc)
        # specifying action_aware on Hash influences the child params,
        # not the hash param itself: assuming it's required when
        # updating as well
        if param_description.options[:action_aware] && param_description.options[:required]
          param_description.required = true
        end
        prepare_hash_params
      end

      def params_ordered
        @params_ordered ||= _apipie_dsl_data[:params].map do |args|
          options = args.find { |arg| arg.is_a? Hash }
          options[:parent] = self.param_description
          Apipie::ParamDescription.from_dsl_data(param_description.method_description, args)
        end
      end

      def validate(value)
        return false if !value.respond_to? :keys
        if @hash_params
          @hash_params.each do |k, p|
            if Apipie.configuration.validate_presence?
              raise ParamMissing.new(p) if p.required && !value.has_key?(k)
            end
            if Apipie.configuration.validate_value?
              p.validate(value[k]) if value.has_key?(k)
            end
          end
        end
        return true
      end

      def process_value(value)
        if @hash_params && value
          return @hash_params.each_with_object({}) do |(key, param), api_params|
            if value.has_key?(key)
              api_params[param.as] = param.process_value(value[key])
            end
          end
        end
      end

      def description
        "Must be a Hash"
      end

      def expected_type
        'hash'
      end

      # where the group definition should be looked up when no scope
      # given. This is expected to return a controller.
      def _default_param_group_scope
        @param_group && @param_group[:scope]
      end

      def merge_with(other_validator)
        if other_validator.is_a? HashValidator
          @params_ordered = ParamDescription.unify(self.params_ordered + other_validator.params_ordered)
          prepare_hash_params
        else
          super
        end
      end

      def prepare_hash_params
        @hash_params = params_ordered.reduce({}) do |h, param|
          h.update(param.name.to_sym => param)
        end
      end
    end
  end
end