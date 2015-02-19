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

  # アカウントデータの更新
  #
  # @return [nil]
  def update_account_data
    user = get_user
    timeline = get_user_timeline
    if !user || !timeline
      self.update(status: :error)
      return
    end

    self.last_followers_count = user.followers_count

    if timeline.length > 0
      self.last_retweet_count  = timeline.inject(0){|sum, t| sum + t.retweet_count } / timeline.length
      self.last_favorite_count = timeline.inject(0){|sum, t| sum + t.favorite_count} / timeline.length

      # アカウント履歴の更新
      histories.create(
        followers_count: user.followers_count,
        retweet_count:   self.last_retweet_count,
        favorite_count:  self.last_favorite_count
      )
    end
    self.save
  end

  # アカウントの履歴をCSVで出力する
  #
  # @param [Fixnum] to 何日前までのデータを出力するか
  # @return [CSV] csv 出力するCSVデータ
  def self.to_csv(to=7)
    CSV.generate do |csv|
      row1 = ['Name', 'Screen name', 'Status', 'Last followers']
      row1 += Array.new(to-1, '')
      row1 << 'Last retweets'
      row1 += Array.new(to-1, '')
      row1 << 'Last favorites'
      row1 += Array.new(to-1, '')
      csv  << row1
      row2 = Array.new(3, '')
      (0...3).each do |i|
        (0...to).each do |t|
          row2 << t.days.ago.strftime("%m/%d")
        end
      end
      csv << row2

      followers_histories = {}
      retweet_histories = {}
      favorite_histories = {}
      (0...to).each do |i|
        date = i.days.ago.to_date
        followers_histories[i] = History.by_date(date).group(:account_id).average(:followers_count)
        retweet_histories[i]   = History.by_date(date).group(:account_id).average(:retweet_count)
        favorite_histories[i]  = History.by_date(date).group(:account_id).average(:favorite_count)
      end
      @accounts = Account.by_statuses([:on, :off, :error]).each do |a|
        adata = [a.name, a.screen_name, a.status]
        (0...to).each do |i|
          adata << followers_histories[i][a.id] ? followers_histories[i][a.id].to_i : 0
        end
        (0...to).each do |i|
          adata << retweet_histories[i][a.id] ? retweet_histories[i][a.id].to_i : 0
        end
        (0...to).each do |i|
          adata << favorite_histories[i][a.id] ? favorite_histories[i][a.id].to_i : 0
        end
        csv << adata
      end
    end
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

  # ユーザーの直近50ツイートのうち、リツイートやリプライは除くものを取得。
  #
  # @param [String] target ターゲットアカウントのscreen_name
  # @return [Array<Twitter::Tweet>] user_timeline ユーザーのタイムライン
  def get_user_timeline(target=screen_name)
    begin
      user_timeline = client.user_timeline(target, exclude_replies: true, trim_user: true, include_rts: false, count:50)
    rescue => e
      error_log(e)
    end
    user_timeline
  end

  def error_log(e)
    $stderr.puts "[ERROR] #{DateTime.now.strftime('%m/%d %H:%M')} #{screen_name}: #{e}"
  end

end
