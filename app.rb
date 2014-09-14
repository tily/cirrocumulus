require 'open-uri'
require 'kconv'
Bundler.require

$redis = Redis::Namespace.new(:nimbus, redis: Redis::Pool.new(url: ENV['REDISTOGO_URL'] || 'redis://localhost:6379/15'))

configure do
	def cache(url)
		if html = $redis.get(url)
			html
		else
			html = yield
			$redis.set(url, html)
			$redis.expire(url, 60*60*24)
			html
		end
	end

	def work_url(params)
		"http://www.aozora.gr.jp/cards/#{params[:cards]}/files/#{params[:files]}"
	end
end

get '/' do
	if params[:query]
		keywords = params[:query].split(/\s+/)
		p keywords
		f = File.open('./list_person_all_extended_utf8.csv')
		@results = []
		f.each_line do |l|
			match = keywords.all? do |keyword|
				l.match(/#{keyword}/)
			end
			@results << l.split(",").map {|e| e[/"(.+)"/, 1] } if match
		end
		haml :result
	else
		haml :top
	end
end

get '/cards/:cards/files/:files' do
	html = cache(work_url(params)) { open(work_url(params), 'r:binary').read }
	@doc = Nokogiri::HTML(html.toutf8, nil, 'utf-8')
	meta = @doc.xpath('//meta[@http-equiv="Content-Type"]').first
	meta['content'] = meta['content'].gsub(/(charset\=)(.+)/) { "#{$1}utf-8" }
	h1 = @doc.xpath('//h1')
	h2 = @doc.xpath('//h2')
	@title = h1.text
	@author = h2.text
	h1.remove
	h2.remove
	haml :show
end
