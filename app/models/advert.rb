class Advert < ActiveRecord::Base
  mount_uploader :addsloader, AddsloaderUploader
  attr_accessible :company, :counter, :addsloader, :anchor, :place


  PLACES = {
    1 => "Верхняя реклама",
    2 => "Боковая реклама",
    3 => "Нижняя реклама"
  }

  # def addsloader=(obj)
  #   super(obj)
  # end
  def self.get_adverts
    adverts = Hash.new
    adverts[1] = Advert.get_first
    adverts[2] = Advert.get_second
    adverts[3] = Advert.get_third
    adverts
  end

  def self.get_first
    ad = Advert.where(:place => 1).last
    ad.counter+=1
    ad.save
    ad
  end

  def humanized_place
    PLACES[self.place]
  end

  def self.get_second
    ad = Advert.where(:place => 2).last
    ad.counter+=1
    ad.save
    ad
  end

  def self.get_third
    ad = Advert.where(:place => 3).last
    ad.counter+=1
    ad.save
    ad
  end
end
