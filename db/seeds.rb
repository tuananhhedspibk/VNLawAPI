Role.create! name: "User"
Role.create! name: "Lawyer"

random = Random.new

specializations_list = [
  "Hình sự", "Sở hữu trí tuệ", "Hôn nhân & gia đình",
  "Nhà đất - Xây dựng", "Tài chính - Ngân hàng",
  "Dân sự", "Lao động - Bảo hiểm xã hội", "Doanh nghiệp"
]

for i in (0..7) do
  Specialization.create!(
    name: specializations_list[i]
  )
end

api_key = "b1c7f840acdee887f402236e82736eba"
api_hash_val = Digest::SHA256.hexdigest "b1c7f840acdee887f402236e82736eba"

ApiKey.create! access_token: api_hash_val

user_ids = [
  "0K0a7kCxqhSfKN5iJ1oNiLShqSt1",
  "0RQBhsa2JsMWZovGyjn75VWYa9n1",
  "0lwAtZAVwfgWkTarcWVraUWybjC2",
  "3FI0yqkR6XTLICjzOCeFu7R2gDj1",
  "4kZrOPnlFHcBGqDx89AunPHg9EQ2",
  "Alz8dRGl23gZASPdeSLsqSxBF1k1",
  "mVNbOUT0HNeJRxhHzrs0nA9dOqI3"]

user_names = [
  "testnotifi.1511420786026",
  "light.1516676291611",
  "name.1510115243847",
  "testchat.1511111570013",
  "truong.1508822781704",
  "linhtm.1509005103447",
  "nhatan.1508821523027"
]

user_emails = [
  "testnotifi@gmail.com",
  "light@gmail.com",
  "name@gmail.com",
  "testchat@gmail.com",
  "truong@gmail.com",
  "linhtm@gmail.com",
  "nhatan@gmail.com"
]

for i in (0..6) do
  au_tk = User.generate_unique_secure_token

  User.create!(
    id: user_ids[i],
    email: user_emails[i],
    password: "123456",
    authentication_token: au_tk
  )

  Profile.create!(
    user_id: user_ids[i],
    userName: user_names[i],
    displayName: user_emails[i]
  )

  if i >= 4
    Lawyer.create!(
      user_id: user_ids[i]
    )

    UserRole.create!(
      user_id: user_ids[i],
      role_id: 2
    )
  else
    UserRole.create!(
      user_id: user_ids[i],
      role_id: 1
    )
  end
end

for i in (1..3) do
  for j in (1..3)
    LawyerSpecialize.create!(
      lawyer_id: i,
      specialization_id: j
    )
  end
end

for i in (0..3) do
  for j in (1..3) do
    Review.create!(
      lawyer_id: j,
      user_id: user_ids[i],
      content: Faker::HarryPotter.book,
      star: random.rand(1..5)
    )
  end
end


for i in (0..3) do
  for j in (1..3) do
    Room.create!(
      lawyer_id: j,
      user_id: user_ids[i],
      description: Faker::HarryPotter.house
    )
  end
end

for i in (1..12) do
  Task.create!(
    room_id: i,
    content: Faker::HarryPotter.quote,
  )
end

for i in (1..7) do
  MoneyAccount.create!(
    profile_id: i,
    ammount: 10000
  )
end

for i in (1..7) do
  DepositHistory.create!(
    money_account_id: i,
    ammount: 10
  )
end

ContentType.create! name: "File"
ContentType.create! name: "Image"
