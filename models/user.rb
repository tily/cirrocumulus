class User
        include Mongoid::Document
        include Mongoid::Timestamps
        field :screen_name, :type => String
        field :uid, :type => String
        field :provider, :type => String
        def self.create_with_omniauth(auth)
                create! do |user|
                        user.provider = auth["provider"]
                        user.uid = auth["uid"]
                        user.screen_name = auth["info"]["nickname"]
                end
        end
end
