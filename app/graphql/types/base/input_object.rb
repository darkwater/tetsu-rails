module Types::Base
  class InputObject < GraphQL::Schema::InputObject
    argument_class Types::Base::Argument
  end
end
