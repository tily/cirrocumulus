class Work
        include Mongoid::Document
        include Mongoid::Timestamps
	# 作品ID (例: 000275, 048416)
	field :work_id, type: String
	# 作品名 (例: 女生徒, ピストルの使い方)
	field :title, type: String
	# 作品名読み (例: じょせいと, ピストルのつかいかた)
	field :title_yomi, type: String
	# ソート用読み (例: しよせいと, ひすとるのつかいかた)
	field :title_yomi_sort, type: String
	# 副題 (例: , ――（前題――楊弓）)
	field :subtitle, type: String
	# 副題読み (例: , ――（ぜんだい――ようきゅう）)
	field :subtitle_yomi, type: String
	# 原題 (例: , )
	field :original_title, type: String
	# 初出 (例: 「文学界」1939（昭和14）年4月, )
	field :first_appearance, type: String
	# 分類番号 (例: NDC 913, NDC 913)
	field :class_number, type: String
	# 文字遣い種別 (例: 新字新仮名, 新字新仮名)
	field :kana_type, type: String
	# 作品著作権フラグ (例: なし, なし)
	field :work_copyright_flag, type: String
	# 公開日 (例: 1999-02-16, 2011-06-29)
	field :published_at, type: Time
	# 最終更新日 (例: 2013-12-05, 2012-11-02)
	field :last_updated_at, type: Time
	# 図書カードURL (例: http://www.aozora.gr.jp/cards/000035/card275.html, http://www.aozora.gr.jp/cards/000050/card48416.html)
	field :card_url, type: String
	# 人物ID (例: 000035, 000050)
	field :person_id, type: String
	# 姓 (例: 太宰, 泉)
	field :last_name, type: String
	# 名 (例: 治, 鏡花)
	field :first_name, type: String
	# 姓読み (例: だざい, いずみ)
	field :last_name_yomi, type: String
	# 名読み (例: おさむ, きょうか)
	field :first_name_yomi, type: String
	# 姓読みソート用 (例: たさい, いすみ)
	field :last_name_yomi_sort, type: String
	# 名読みソート用 (例: おさむ, きようか)
	field :first_name_yomi_sort, type: String
	# 姓ローマ字 (例: Dazai, Izumi)
	field :last_name_roma, type: String
	# 名ローマ字 (例: Osamu, Kyoka)
	field :first_name_roma, type: String
	# 役割フラグ (例: 著者, 著者)
	field :role, type: String
	# 生年月日 (例: 1909-06-19, 1873-11-04)
	field :born_at, type: Time
	# 没年月日 (例: 1948-06-13, 1939-09-07)
	field :died_at, type: Time
	# 人物著作権フラグ (例: なし, なし)
	field :person_copyright_flag, type: String
	# 底本名1 (例: 女生徒, 泉鏡花集成8)
	field :copytext1_title, type: String
	# 底本出版社名1 (例: 角川文庫、角川書店, ちくま文庫、筑摩書房)
	field :copytext1_publisher, type: String
	# 底本初版発行年1 (例: 1954（昭和29）年10月20日、1968（昭和43）年2月5日改版44版, 1996（平成8）年5月23日)
	field :copytext1_published_at, type: Time
	# 入力に使用した版1 (例: , 1996（平成8）年5月23日第1刷)
	field :copytext1_version_of_typist, type: String
	# 校正に使用した版1 (例: 1989（平成元）年7月10日改版41版, 1996（平成8）年5月23日第1刷)
	field :copytext1_version_of_corrector, type: Time
	# 底本の親本名1 (例: , 鏡花全集　第二十三卷)
	field :copytext1_parent_title, type: String
	# 底本の親本出版社名1 (例: , 岩波書店)
	field :copytext1_parent_publisher, type: String
	# 底本の親本初版発行年1 (例: , 1942（昭和17）年6月22日)
	field :copytext1_parent_published_at, type: Time
	# 底本名2 (例: , )
	field :copytext2_title, type: String
	# 底本出版社名2 (例: , )
	field :copytext2_publisher, type: String
	# 底本初版発行年2 (例: , )
	field :copytext2_published_at, type: Time
	# 入力に使用した版2 (例: , )
	field :copytext2_version_of_typist, type: Time
	# 校正に使用した版2 (例: , )
	field :copytext2_version_of_corrector, type: Time
	# 底本の親本名2 (例: , )
	field :copytext2_parent_title, type: String
	# 底本の親本出版社名2 (例: , )
	field :copytext2_parent_publisher, type: String
	# 底本の親本初版発行年2 (例: , )
	field :copytext2_parent_published_at, type: Time
	# 入力者 (例: 細渕真弓, 門田裕志)
	field :typist, type: String
	# 校正者 (例: 細渕紀子, 仙酔ゑびす)
	field :corrector, type: String
	# テキストファイルURL (例: http://www.aozora.gr.jp/cards/000035/files/275_ruby_1532.zip, http://www.aozora.gr.jp/cards/000050/files/48416_ruby_42785.zip)
	field :text_url, type: String
	# テキストファイル最終更新日 (例: 2011-05-22, 2011-05-07)
	field :text_last_updated_at, type: Time
	# テキストファイル符号化方式 (例: ShiftJIS, ShiftJIS)
	field :text_encoding, type: String
	# テキストファイル文字集合 (例: JIS X 0208, JIS X 0208)
	field :text_charset, type: String
	# テキストファイル修正回数 (例: 5, 0)
	field :text_mod_times, type: String
	# XHTML/HTMLファイルURL (例: http://www.aozora.gr.jp/cards/000035/files/275_13903.html, http://www.aozora.gr.jp/cards/000050/files/48416_42914.html)
	field :html_url, type: String
	# XHTML/HTMLファイル最終更新日 (例: 2011-05-22, 2011-05-07)
	field :html_last_updated_at, type: Time
	# XHTML/HTMLファイル符号化方式 (例: ShiftJIS, ShiftJIS)
	field :html_encoding, type: String
	# XHTML/HTMLファイル文字集合 (例: JIS X 0208, JIS X 0208)
	field :html_charset, type: String
	# XHTML/HTMLファイル修正回数 (例: 2, 0)
	field :html_mod_times, type: String
end
