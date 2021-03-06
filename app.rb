require 'open-uri'
require 'kconv'
require 'csv'
require 'stringio'
Bundler.require
require './models/user.rb'
require './models/work.rb'
require './models/read.rb'

$redis = Redis::Namespace.new(:nimbus, redis: Redis::Pool.new(url: ENV['REDISTOGO_URL'] || 'redis://localhost:6379/15'))

configure do
	enable :sessions
	set :session_secret, ENV['SESSION_SECRET']

	use Rack::Session::Redis, {
		:url          => ENV['REDISTOGO_URL'] || 'redis://localhost:6379/15',
		:namespace    => "rack:session",
		:expire_after => 60*60*24*7
	}

	use OmniAuth::Builder do
	        provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
	end

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

	def str_to_arr(str)
		arr = []
		io = StringIO.new(str)
		while char = io.getc
		        arr << char
		end
		arr
	end

	Mongoid.load!("./mongoid.yml")
end

helpers do
	def current_user
		@current_user ||= User.where(uid: session[:uid]).first
	end

	def markdown2html(markdown)
		renderer = Redcarpet::Render::HTML.new(filter_html:true)
		Redcarpet::Markdown.new(renderer, autolink: true).render(markdown)
	end
end

get '/' do
	if params[:query]
		keywords = params[:query].split(/\s+/)
		f = File.open('./list_person_all_extended_utf8.csv')
		@results = []
		f.each_line do |l|
			match = keywords.all? do |keyword|
				l.match(/#{keyword}/)
			end
			@results << l.split(",").map {|e| e[/"(.+)"/, 1] } if match
		end
		f.close
	end
	haml :result
end

get '/EnJoeToh/Prologue' do
	md = ''
	@author = '円城塔'
	@title = 'Prologue'
	1.upto(6) do |i|
		url = "https://raw.githubusercontent.com/EnJoeToh/Prologue/master/prologue#{i}.dat"
		text = StringIO.new cache(url) { open(url).read }
		text.gets
		md += text.read.gsub(/^#.+$/, '').gsub(/\n/, "\n\n") + "\n\n"
	end
	@doc = Nokogiri::HTML.fragment markdown2html(md)
	haml :show
end

get '/cards/:cards/files/:files' do
	@work = Work.where(html_url: work_url(params)).first
	html = cache(work_url(params)) { open(work_url(params), 'r:binary').read }
	@doc = Nokogiri::HTML(html.toutf8, nil, 'utf-8')
	meta = @doc.xpath('//meta[@http-equiv="Content-Type"]').first
	meta['content'] = meta['content'].gsub(/(charset\=)(.+)/) { "#{$1}utf-8" }
	@doc.xpath('//h1').remove
	@doc.xpath('//h2').remove
	@title = @work.title
	@author = (@work.last_name || '') + (@work.first_name || '')
	@doc.xpath('//img').each do |img|
		img['src'] = 'http://www.aozora.gr.jp/' + img['src']
	end
	@doc.xpath('//hr/following::*').remove
	unless session[:ruby]
		@doc.xpath('//rt').remove
		@doc.xpath('//rp').remove
	end
	@doc.xpath('//div[@class="bibliographical_information"]').remove

	if empty_line = params[:empty_line]
		p 'here'
		#html = @doc.to_s.gsub(/([^>\s])\s*?(<br\s*\/?>\s+?){2,}/) { $1 + "<br /><br />" * empty_line.to_i }
		html = @doc.to_s.gsub(/(<br\s*\/?>\s+?){2,}/) { "<br /><br />" * empty_line.to_i }
		p html
		@doc = Nokogiri::HTML(html)
	end

	if params[:mode] == 'sort'
		body = @doc.xpath('//body').first
		body.content = cache("sorted:#{work_url(params)}") { Algorithms::Sort.mergesort(str_to_arr(body.text)).join }
	elsif params[:mode] == 'line'
		body = @doc.xpath('//body').first
		lines = body.text.scan(/「(.+?)」/)
		ul = Nokogiri::XML::Node.new('ul', @doc)
		lines.each do |line|
			li = Nokogiri::XML::Node.new('li', @doc)
			li.content = line.first
			ul << li
		end
		body.children.remove
		body << ul
	elsif params[:mode] == 'reverse'
		body = @doc.xpath('//body').first
		sentences = body.text.split(/。/).reverse.join('。')
		body.content = sentences
	end
	haml :show
end

get '/session' do
	if params[:solarized]
		session[:solarized] = params[:solarized] == 'true'
	end
	if params['font-family']
		session['font-family'] = (params['font-family'] == 'mincho' ? 'mincho' : 'gothic')
	end
	if params['ruby']
		session['ruby'] = params['ruby'] == 'true'
	end
	redirect params['redirect_to'] || '/'
end

get '/:user' do
	@user = User.where(screen_name: params[:user]).first
	haml :user
end

post '/:user' do
	work = Work.where(html_url: work_url(params)).first
	current_user.reads.create(work: work)
	redirect "/#{current_user.screen_name}"
end

get '/csv' do
	haml :csv
end

get '/logout' do
	session[:uid] = nil
	redirect '/'
end

get '/auth/twitter/callback' do
	auth = request.env["omniauth.auth"]
	User.where(:provider => auth["provider"], :uid => auth["uid"]).first || User.create_with_omniauth(auth)
	session[:uid] = auth["uid"]
	redirect '/'
end
