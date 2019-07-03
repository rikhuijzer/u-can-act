# This defines a Rails constant, so that this line doesn't throw an error on Circleci:
# In: ~/.rvm/gems/ruby-2.6.3/gems/rubocop-rails-2.0.1/lib/rubocop/cop/rails_cops.rb
# module RuboCop
#   # RuboCop included the Rails cops directly before version 1.0.0.
#   # We can remove them to avoid warnings about redefining constants.
#   module Cop
#     remove_const('Rails') if const_defined?('Rails')
#   end
# end
module RuboCop
  module Cop
    Rails = 5
  end
end
