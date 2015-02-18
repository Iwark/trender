# coding: utf-8
module AccountDecorator
  def followers_count
    histories.count > 0 ? histories.last.followers_count : 0
  end

  def retweet_count
    histories.count > 0 ? histories.last.retweet_count : 0
  end

  def favorite_count
    histories.count > 0 ? histories.last.favorite_count : 0
  end
end
