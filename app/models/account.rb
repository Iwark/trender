# == Schema Information
#
# Table name: accounts
#
#  id                   :integer          not null, primary key
#  screen_name          :string(255)
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  name                 :string(255)
#  last_followers_count :integer          default("0")
#  last_retweet_count   :integer          default("0")
#  last_favorite_count  :integer          default("0")
#

class Account < ActiveRecord::Base
  
  has_many :histories

  # ステータス
  enum status: { on: 10, off: 20, error: 30, deleted: 40 }
  validates :status, inclusion: { in: %w(on off error deleted) }

  # ステータスで絞り込み
  scope :by_status, -> status {
    where(status: statuses[status])
  }
  scope :by_statuses, -> statuses {
    statuses.map! {|status| Account.statuses[status] }
    where(status: statuses)
  }

  # 条件で絞り込み
  scope :narrow, -> followers_lt, retweets_gt, favorites_gt {
    narrow_followers(followers_lt).
    narrow_retweets(retweets_gt).
    narrow_favorites(favorites_gt)
  }
  scope :narrow_followers, -> followers_lt {
    where(arel_table[:last_followers_count].lt(followers_lt)) if followers_lt.present?
  }
  scope :narrow_retweets, -> retweets_gt {
    where(arel_table[:last_retweet_count].lt(retweets_gt)) if retweets_gt.present?
  }
  scope :narrow_favorites, -> favorites_gt {
    where(arel_table[:last_favorite_count].lt(favorites_gt)) if favorites_gt.present?
  }

  def update_history
    user = get_user
    timeline = get_user_timeline
    if !user || !timeline
      self.update(status: :error)
      return
    end

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
    self.update(
      last_followers_count: user.followers_count,
      last_retweet_count:   r_count / timeline.count,
      last_favorite_count:  f_count / timeline.count
    )
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

  def error_log(e)
    $stderr.puts "[ERROR] #{DateTime.now.strftime('%m/%d %H:%M')} #{screen_name}: #{e}"
  end

end
