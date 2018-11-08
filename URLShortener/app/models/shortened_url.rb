# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :long_url, :short_url, presence: true, uniqueness: true

  # after_initialize :random_code

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  def self.create!(user, long_url)
    shortened_url = ShortenedUrl.random_code
    ShortenedUrl.new(long_url: long_url, short_url: shortened_url, user_id: user.id)
  end

  def self.random_code
    loop do
      shortened_url = SecureRandom.urlsafe_base64
      # return self.short_url = shortened_url unless ShortenedUrl.exists?(short_url: shortened_url)
      return shortened_url unless ShortenedUrl.exists?(short_url: shortened_url)
    end
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    # visitor_hash = Hash.new(0)
    #Visit.all.each {|visit| visitor_hash[visit.user_id] += 1 if visit.url_id == self.id}
    visits.select(user_id).distinct.count
    # visitor_hash.keys.count
  end

  def num_recent_uniques
    visits.select(user_id).distinct.where({ created_at: 10.minutes.ago..Time.now }).count
  end
end
