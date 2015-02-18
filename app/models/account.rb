# == Schema Information
#
# Table name: accounts
#
#  id          :integer          not null, primary key
#  screen_name :string(255)
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string(255)
#

class Account < ActiveRecord::Base
  
  has_many :histories

  # ステータス
  enum status: { on: 10, off: 20, deleted: 40 }
  validates :status, inclusion: { in: %w(on off deleted) }

  # ステータスで絞り込み
  scope :by_status, -> status {
    where(status: statuses[status])
  }
  scope :by_statuses, -> statuses {
    statuses.map! {|status| Account.statuses[status] }
    where(status: statuses)
  }

  def update_history
    user = get_user 
    timeline = get_user_timeline
    
    r_count = 0
    f_count = 0
    timeline.each do |tweet|
      r_count += tweet.retweet_count
      f_count += tweet.favorite_count
    end

    histories.create(
      followers_count: user.followers_count,
      retweet_count:   r_count / timeline.count,
      favorite_count:  f_count / timeline.count
    )
    self.touch
    self.save
  end

  private

  # クライアントの取得
  #
  # @return [Twitter::REST::Client] client Twitterクライアント
  def client
    @client ||=
      Twitter::REST::Client.new(
        consumer_key:        Rails.application.secrets.twitter_consumer_key,
        consumer_secret:     Rails.application.secrets.twitter_consumer_secret,
        access_token:        Rails.application.secrets.twitter_access_token,
        access_token_secret: Rails.application.secrets.twitter_access_token_secret
      )
  end

  # ユーザーの取得
  #
  # @param [String] target ターゲットアカウントのscreen_name
  # @return [Twitter::User] user Twitterユーザー情報.
  def get_user(target=screen_name)
    begin
      user = client.user(target)
    rescue => e
      error_log(e)
    end
    user
  end

  # ユーザーのタイムラインの取得
  #
  # @param [String] target ターゲットアカウントのscreen_name
  # @return [Array<Twitter::Tweet>] user_timeline ユーザーのタイムライン
  def get_user_timeline(target=screen_name)
    begin
      user_timeline = client.user_timeline(target)
    rescue => e
      error_log(e)
    end
    user_timeline
  end

end
