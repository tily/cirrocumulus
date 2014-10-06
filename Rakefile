Bundler.require
require 'csv'
require './models/user.rb'
require './models/work.rb'
Mongoid.load!('mongoid.yml')

desc 'download index file'
task 'download' do
	system [
		'curl -O http://www.aozora.gr.jp/index_pages/list_person_all_extended_utf8.zip',
		'unzip list_person_all_extended_utf8.zip',
		'rm list_person_all_extended_utf8.zip'
	].join(' && ')	
end

desc 'download EnJoeToh/Prologue'
task 'enjoe' do
	1.upto(6) do |i|
		system "curl https://raw.githubusercontent.com/EnJoeToh/Prologue/master/prologue#{i}.dat -o enjoe-prologue/#{i}.txt"
	end
end

desc 'load aozora csv'
task :load_csv do
	columns = %w(
		work_id
		title
		title_yomi
		title_yomi_sort
		subtitle
		subtitle_yomi
		original_title
		first_appearance
		class_number
		kana_type
		work_copyright_flag
		published_at
		last_updated_at
		card_url
		person_id
		last_name
		first_name
		last_name_yomi
		first_name_yomi
		last_name_yomi_sort
		first_name_yomi_sort
		last_name_roma
		first_name_roma
		role
		born_at
		died_at
		person_copyright_flag
		copytext1_title
		copytext1_publisher
		copytext1_published_at
		copytext1_version_of_typist
		copytext1_version_of_corrector
		copytext1_parent_title
		copytext1_parent_publisher
		copytext1_parent_published_at
		copytext2_title
		copytext2_publisher
		copytext2_published_at
		copytext2_version_of_typist
		copytext2_version_of_corrector
		copytext2_parent_title
		copytext2_parent_publisher
		copytext2_parent_published_at
		typist
		corrector
		text_url
		text_last_updated_at
		text_encoding
		text_charset
		text_mod_times
		html_url
		html_last_updated_at
		html_encoding
		html_charset
		html_mod_times
	)
	i = -1
	CSV.foreach('./list_person_all_extended_utf8.csv') do |row|
		i += 1
		next if i == 0
		work = Work.where(html_url: row[50]).first || Work.new
		row.each_with_index do |v, i|
			work.send "#{columns[i]}=", (v == '' ? nil : v)
		end
		work.save!
	end
end
