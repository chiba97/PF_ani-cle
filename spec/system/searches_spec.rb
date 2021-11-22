# frozen_string_literal: true

require 'rails_helper'

describe '検索機能テスト' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user_id: user.id) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
    visit root_path
  end

  describe 'ユーザー検索のテスト:ヒットした場合' do
    before do
      fill_in 'word', with: user.name
      select "ユーザー", from: "range"
      select "完全一致", from: "search"
      find('.header-search-btn').click
    end

    context "検索したユーザーにヒットした場合の表示の確認" do
      it '検索した結果が表示されている' do
        expect(page).to have_content '検索した結果はこちら'
      end
      it '検索したユーザーのプロフィール画像が表示される：リンク先はユーザー詳細画面' do
        expect(page).to have_link user.profile_image_id, href: user_path(user.id)
      end
      it '検索したユーザのニックネームが表示される：リンク先はユーザー詳細画面' do
        expect(page).to have_link user.name, href: user_path(user.id)
      end
      it '飼っているペット欄が表示される' do
        expect(page).to have_content user.pet
      end
      it '自己紹介欄が表示される' do
        expect(page).to have_content user.introduction
      end
    end
  end

  describe 'ユーザー検索のテスト:ヒットしなかった場合' do
    before do
      fill_in 'word', with: ''
      find('.header-search-btn').click
    end

    context '検索したユーザーにヒットしなかった場合の表示の確認' do
      it '見つかりませんでしたと表示されている' do
        expect(page).to have_content '該当するユーザーは見つかりませんでした'
      end
    end
  end

  describe '投稿記事検索のテスト：ヒットした場合' do
    before do
      fill_in 'word', with: post.pet
      select "投稿記事", from: "range"
      select "完全一致", from: "search"
      find('.header-search-btn').click
    end

    context '検索した投稿記事にヒットした場合の表示の確認' do
      it '検索した記事が表示されている' do
        expect(page).to have_content post.pet
      end
      it '検索した記事の詳細リンクが表示されている' do
        expect(page).to have_link '詳細', href: post_path(post.id)
      end
    end
  end

  describe '投稿記事検索のテスト：ヒットしなかった場合' do
    before do
      fill_in 'word', with: ''
      select "投稿記事", from: "range"
      select "完全一致", from: "search"
      find('.header-search-btn').click
    end

    context '検索した記事がヒットしなかった場合の表示の確認' do
      it '見つかりませんでしたと表示される' do
        expect(page).to have_content '該当する投稿記事は見つかりませんでした'
      end
    end
  end
end
