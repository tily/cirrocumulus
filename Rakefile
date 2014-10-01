

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
