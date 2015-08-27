class User < ActiveRecord::Base
  self.table_name = 'users_view'
  self.primary_key = 'id'
end
