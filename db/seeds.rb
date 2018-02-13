intro_template = <<EOF
Lorem Ipsum chỉ đơn giản là một đoạn văn bản giả,
được dùng vào việc trình bày và dàn trang phục vụ cho in ấn.
Lorem Ipsum đã được sử dụng như một văn bản chuẩn cho ngành
công nghiệp in ấn từ những năm 1500, khi một họa sĩ vô danh
ghép nhiều đoạn văn bản với nhau để tạo thành một bản mẫu văn bản.
Đoạn văn bản này không những đã tồn tại năm thế kỉ,
mà khi được áp dụng vào tin học văn phòng,
nội dung của nó vẫn không hề bị thay đổi.
EOF

names_list = [
  "Nguyễn Tiến Trường", "Trần Tuấn Anh",
  "Trần Mạnh Linh", "Nguyễn Nhật Tân", "Doãn Minh Phúc",
  "Park Hang Seo", "Alexis Sanchez", "Chú Tư", "Pham Gia"
]

specializations_list = [
  "Hình sự", "Sở hữu trí tuệ", "Hôn nhân & gia đình",
  "Nhà đất - Xây dựng", "Tài chính - Ngân hàng",
  "Dân sự", "Lao động - Bảo hiểm xã hội", "Doanh nghiệp"
]

costs_list = [200000, 300000, 500000, 600000, 100000, 550000]

rates_list = [4.5, 5, 5, 3.5, 2.5, 5, 3, 2.5, 5]

fb_ids_list = ["osEJmYiLmXQFq2ncCFz8Xr5qe5n1", "ppBZofn8AwTY1gTj92bfQegyBlw1",
"0K0a7kCxqhSfKN5iJ1oNiLShqSt1", "azXW5C600ESBl8ooAFneBt1hFhw2",
"3FI0yqkR6XTLICjzOCeFu7R2gDj1", "0lwAtZAVwfgWkTarcWVraUWybjC2",
"0K0a7kCxqhSfKN5iJ1oNiLShqSt2", "0K0a7kCxqhSfKN5iJ1oNiLShqSt5",
"0K0a7kCxqhSfKN5iJ1oNiLShqSt8"]

photo_urls_list = [
"https://lh4.googleusercontent.com/-9SCptAuM9Mo/AAAAAAAAAAI/AAAAAAAAAEM/hTRuSqgZwbs/photo.jpg",
"https://image.ibb.co/i23jUF/default_ava.png", "https://image.ibb.co/i23jUF/default_ava.png",
"http://cafef.vcmedia.vn/zoom/660_360/2015/truong-thanh-duc-1423034408715.png",
"https://image.ibb.co/i23jUF/default_ava.png",
"https://firebasestorage.googleapis.com/v0/b/lkbc-chat.appspot.com/o/avatar%2F0lwAtZAVwfgWkTarcWVraUWybjC2?alt=media&token=4a8b1ea5-0178-44dd-8db1-482beb81f7c7",
"https://image.ibb.co/i23jUF/default_ava.png",
"https://image.ibb.co/i23jUF/default_ava.png",
"https://image.ibb.co/i23jUF/default_ava.png"]

random = Random.new

for i in (0..8) do
  Lawyer.create!(
    name: names_list[i],
    rate: rates_list[i],
    intro: intro_template,
    cost: costs_list[i],
    view_count: 0,
    photo_url: photo_urls_list[i],
    fb_id: fb_ids_list[i]
  )
end

for i in (0..7) do
  Specialization.create!(
    name: specializations_list[i]
  )
end

for i in (1..9) do
  3.times do
    LawyerSpecialize.create!(
      lawyer_id: i,
      specialization_id: random.rand(1..8)
    )
  end
end
