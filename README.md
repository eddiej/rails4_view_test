## The Setup

An ActiveRecord model *User* that uses a database view `users_view` as its table:

**Model**

```ruby
class User < ActiveRecord::Base
  self.table_name = 'users_view'
  self.primary_key = 'id'
end
```

**Users Table**

```
create_table :users do |t|
 t.string :name
end
```

**Database View**

```
CREATE VIEW users_view AS SELECT u.id, u.name FROM users u
```

## The Problem
When a new user is instantiated or created, the id defaults to 0 rather than nil. In th database, the correct records are created, but these can't be retrieved afterwards as every User object created in the application has an id of 0.

```ruby
> u = User.create({name: 'Ned'})
   (0.2ms)  BEGIN
  SQL (0.4ms)  INSERT INTO `users_view` (`name`) VALUES ('Ned')
   (2.3ms)  COMMIT
 => #<User id: 0, name: "Ned">
```

```ruby
> u.id
 => 0
```

```ruby
> u.reload
  User Load (0.5ms)  SELECT  `users_view`.* FROM `users_view` WHERE `users_view`.`id` = 0 LIMIT 1
ActiveRecord::RecordNotFound: Couldn't find User with 'id'=0
```

## Tests

These tests fail:

```ruby
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User creation" do
    it "doesn't assign as ID on new" do
      expect(User.new(name: 'Eddie').id).to eq nil
    end
    it "assigns an ID > 0 on create" do
      expect(User.create(name: 'Eddie').id).to be > 0
    end
  end
end

```
See [https://travis-ci.org/eddiej/rails4\_view_test/](https://travis-ci.org/eddiej/rails4_view_test/)