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
  "4kZrOPnlFHcBGqDx89AunPHg9EQ2",
  "Alz8dRGl23gZASPdeSLsqSxBF1k1",
  "0K0a7kCxqhSfKN5iJ1oNiLShqSt1",
  "0RQBhsa2JsMWZovGyjn75VWYa9n1",
  "0lwAtZAVwfgWkTarcWVraUWybjC2",
  "dSk7TgQhBCUuZ0qaJlp9lrWPS152",
  "mVNbOUT0HNeJRxhHzrs0nA9dOqI3",
  "Jhz1jY1hZwN1wBtnbrGTP0ABFwl1",
  "KFw2DtUYtWVwRhNppdJepT4XNnn2",
  "KU2WsDHmdqhkwqXVWnLROcbUilx1",
  "LNHQ3ic0sTUmrW9M6tECUR9TQbH3",
  "LeGoeGE580c71TjnSLI6iB29f343",
  "MHRy2WloCifOzgnYQF9MgkKxLHg2",
  "OtEiZzIR7zM0E94v9tg7mMqnsMi2",
  "RR4eRVmkemOzoztWdHDZ637w68w2",
  "RXJFfwYheYN7LutR4qun6gzww8l1",
  "RZFMGirYtZVMLA7T5DSZSKmfLT02",
  "RjBjS2czTuUvyA5CSWnxd98HRKC2"
]

user_names = [
  "testnotifi.1511420786026",
  "light.1516676291611",
  "linhtm.1509005103447",
  "linh.tran.1509008739091",
  "name1.1510112753493",
  "truong.1508822781704",
  "name3.1521879034058",
  "ishida.1523521672949",
  "ishida.1523521526749",
  "ta123.1523529255592",
  "abcd.1509004951639",
  "aloha123.1523261534897",
  "tangay.1523529873598",
  "tran.linh.1508821569515",
  "hehe.1523525752833",
  "tranaaa.1522048284817",
  "vannam.1511937401878",
  "dadawdaw.1522051772089"
]

user_emails = [
  "testnotifi@gmail.com",
  "light@gmail.com",
  "linhtm@gmail.com",
  "tranlinh265@gmail.com",
  "name1@gmail.com",
  "abc@gmail.com",
  "name3@gmail.com",
  "ishida@gmail.com",
  "ishida1@gmail.com",
  "ta123@gmail.com",
  "abcd@gmail.com",
  "aloha123@gmail.com",
  "tangay@gmail.com",
  "tranlinh@gmail.com",
  "hehe@gmail.com",
  "tranaaa@gmail.com",
  "vannam@gmail.com",
  "dadawdaw@gmail.com"

]

display_names = [
  "testnotifi",
  "Yagami Light",
  "Trần Mạnh Linh",
  "Trần Linh",
  "Trần Tuấn Anh",
  "Trần Tuấn Linh",
  "Trần Việt Anh",
  "Nguyễn Hồng Phương",
  "Nguyễn Đức Nghĩa",
  "Nguyễn Việt Anh",
  "Phạm Gia",
  "Vũ Hằng",
  "Nguyễn Trí Minh",
  "Nguyễn Tiến Trường",
  "Nguyễn Nhật Tân",
  "Lại Là Ninh",
  "Trần Anh Đăng",
  "Doãn Minh Phúc"
]

for i in (0..17) do
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
    displayName: display_names[i]
  )

  if i >= 4
    rate = random.rand(1..5)
    price = random.rand(100000..200000)

    Lawyer.create!(
      user_id: user_ids[i],
      intro: Faker::HarryPotter.quote,
      rate: rate,
      price: price,
      achievement: Faker::HarryPotter.quote,
      cardNumber: rate,
      certificate: price,
      education: Faker::HarryPotter.house,
      exp: rate
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


for i in (1..13) do
  old_sp_id = [-1]
  sp_id = -1
  for j in (1..3)
    while old_sp_id.include? sp_id do
      sp_id = random.rand(1..8)
    end
    old_sp_id << sp_id
    LawyerSpecialize.create!(
      lawyer_id: i,
      specialization_id: sp_id
    )
  end
end

for i in (0..3) do
  for j in (1..14) do
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

for i in (1..18) do
  MoneyAccount.create!(
    profile_id: i,
    ammount: 10000
  )
end

for i in (1..18) do
  DepositHistory.create!(
    money_account_id: i,
    ammount: 10
  )
end

ContentType.create! name: "File"
ContentType.create! name: "Image"
