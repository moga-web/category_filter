# webrick.rb
require 'webrick'
require 'erb'

foods = [
  { id: 1, name: "りんご", category: "fruits" },
  { id: 2, name: "バナナ", category: "fruits" },
  { id: 3, name: "いちご", category: "fruits" },
  { id: 4, name: "トマト", category: "vegetables" },
  { id: 5, name: "キャベツ", category: "vegetables" },
  { id: 6, name: "レタス", category: "vegetables" }
]

server = WEBrick::HTTPServer.new({ 
  :DocumentRoot => './',
  :BindAddress => '127.0.0.1',
  :Port => 8000
})

trap(:INT){
    server.shutdown
}

server.mount_proc("/time") do |req, res|
  # レスポンス内容を出力
  body = "<html><body>#{Time.now}</body></html>"
  res.status = 200
  res['Content-Type'] = 'text/html'
  res.body = body
end

server.mount_proc("/form_get") do |req, res|
  req.query
  body = "<html><head><meta charset='utf-8'></head><body>\n"
  body += "クエリパラメーターは#{req.query}です<br>"
  body += "こんにちは#{req.query['username']}さん。あなたの年齢は#{req.query['age']}ですね"
  body += "</body</html>\n"
  res.status = 200
  res['Content-Type'] = 'text/html'
  res.body = body
end

server.mount_proc("/form_post") do |req, res|
  req.query
  body = "<html><head><meta charset='utf-8'></head><body>\n"
  body += "クエリパラメーターは#{req.query}です<br>"
  body += "こんにちは#{req.query['username']}さん。あなたの年齢は#{req.query['age']}ですね"
  body += "</body</html>\n"
  res.status = 200
  res['Content-Type'] = 'text/html'
  res.body = body
end

WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
server.config[:MimeTypes]["erb"] = "text/html"

server.mount_proc("/hello") do |req, res|
  template = ERB.new( File.read('hello.erb') )
  @time = Time.now
  res.body << template.result( binding )
end

server.mount_proc("/foods") do |req, res|
  template = ERB.new( File.read('./foods/index.erb') )
  req.query
  @selected_category = req.query["category"]
  @foods = foods.filter{ |food| food[:category] == @selected_category || @selected_category == "all"}
  res.body << template.result( binding )
end

server.start
