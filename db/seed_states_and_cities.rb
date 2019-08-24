CSV.foreach("#{Rails.root}/db/data/states/united_states.csv", headers: true) do |csv_row|
  country = Country.united_states
  State.where(country: country, name: csv_row.fetch('name')).first_or_create!
end

CSV.foreach("#{Rails.root}/db/data/states/mexico.csv", headers: true) do |csv_row|
  country = Country.mexico
  State.where(country: country, name: csv_row.fetch('name')).first_or_create!
end
