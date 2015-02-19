# coding: utf-8

class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  permits :name, :screen_name, :status

  # GET /accounts
  def index(followers_lt=nil, retweets_gt=nil, favorites_gt=nil)
    @accounts = Account.by_statuses([:on, :off, :error]).narrow(followers_lt, retweets_gt, favorites_gt)
  end

  # GET /accounts/1
  def show
    @followers_count_data = {}
    @account.histories.where(History.arel_table[:created_at].gt(7.days.ago)).group(:created_at).sum(:followers_count).each do |k, v|
      @followers_count_data[k] = v
    end
    @retweet_count_data = {}
    @account.histories.where(History.arel_table[:created_at].gt(7.days.ago)).group(:created_at).sum(:retweet_count).each do |k, v|
      @retweet_count_data[k] = v
    end
    @favorite_count_data = {}
    @account.histories.where(History.arel_table[:created_at].gt(7.days.ago)).group(:created_at).sum(:favorite_count).each do |k, v|
      @favorite_count_data[k] = v
    end
  end

  # GET /accounts/new
  def new
    @account = Account.new status: :on
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  def create(account)
    @account = Account.new(account)

    if @account.save
      redirect_to @account, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  # PUT /accounts/1
  def update(account)
    if @account.update(account)
      redirect_to @account, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy

    redirect_to accounts_url, notice: 'Account was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account(id)
      @account = Account.find(id)
    end
end
