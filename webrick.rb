# webrick.rb
require 'webrick'

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

server.start
