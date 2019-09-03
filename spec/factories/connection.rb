FactoryBot.define do
  factory :connection do
    user1 { create(:user) }
    user2 { create(:user) }
  end
end
