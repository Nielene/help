class Business < ApplicationRecord
  validates :name, :address, :phone_number, :cuisine, presence: true

  has_many :reviews

  has_many :photos

  has_many :reviewers, through: :reviews, source: :user

  has_attached_file :image, styles: { thumb: '100x100', croppable: '600x600>', big: '1000x1000>' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def self.in_bounds(bounds)
    self.where("lat < ?", bounds[:northEast][:lat]).where("lat > ?", bounds[:southWest][:lat])
    .where("lng < ?", bounds[:northEast][:lng]).where("lng < ?" ,bounds[:southWest][:lng])
  end

  def average_rating
    return 0 unless !!self.reviews
    (self.reviews.average(:rating).to_f * 2.to_f).round / 2.0
  end

  def review_count
    return 0 unless self.reviews
    self.reviews.count
  end

  def price_range
    return 0 unless self.reviews
    self.reviews.average(:price_range).to_i
  end

  def delivery
    return false unless self.reviews
    self.reviews.where(delivery: [true]).count > self.reviews.where(delivery: [false]).count
  end

  def noise_level
    return 0 unless self.reviews
    self.reviews.average(:noise_level).to_i 
  end

end
