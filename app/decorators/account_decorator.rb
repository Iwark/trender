# coding: utf-8
module AccountDecorator

  def followers_count
    histories.count > 0 ? histories.last.followers_count : ''
  end

  def retweets_count
    histories.count > 0 ? histories.last.retweet_count : ''
  end

  def favorites_count
    histories.count > 0 ? histories.last.favorite_count : ''
  end

end
