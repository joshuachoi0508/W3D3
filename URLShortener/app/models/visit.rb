# == Schema Information
#
# Table name: visits
#
#  id         :bigint(8)        not null, primary key
#  url_id     :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Visit < ApplicationRecord
  validates :url_id, :user_id, presence: true

  def self.record_visit!(user, shortened_url)
    Visit.new(url_id: shortened_url.id, user_id: user.id)
  end

  belongs_to :visitors,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :visited_urls,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl
end
