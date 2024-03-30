10.times do |number|
    Message.create(content: "#{number+1}番目のメッセージです！", user_id: User.first.id)
end