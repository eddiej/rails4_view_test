require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User creation" do
    it "doesn't assign as ID on new" do
      expect(User.new.id).to eq nil
    end
    it "assigns an ID > 0 on create" do
      expect(User.create.id).to be > 0
    end
  end
end
