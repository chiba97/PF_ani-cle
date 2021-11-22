# frozen_string_literal: true

require 'rails_helper'

describe '通知機能のテスト' do
  
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:notification) { build(:notification, visitor_id: other_user.id, visited_id: user.id) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  
  describe '通知画面のテスト' do
    before do
      visit notifications_path
    end
    context '通知画面の表示のテスト' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/notifications'
      end
      it '通知一覧と表示されている' do
        expect(page).to have_content '通知一覧'
      end
      it '通知がない場合は通知がありませんと表示されている' do
        expect(page).to have_content '現在通知はありません'
      end
    end
  end
  
  describe '通知のテスト' do
    it '他人をフォローした際に通知が送られる' do
      visit user_path(other_user.id)
      click_link 'フォローする'
      expect(notification).to be_valid
    end
  end
  
  describe '通知が送られた際の通知画面のテスト' do
    before do
      visit user_path(other_user.id)
      click_link 'フォローする'
      click_link 'ログアウト'
      visit new_user_session_path
      fill_in 'user[email]', with: other_user.email
      fill_in 'user[password]', with: other_user.password
      click_button 'ログイン'
      visit notifications_path
    end
    context '画面のテスト' do
      it '通知一覧と表示されている' do
        expect(page).to have_content '通知一覧'
      end
      it 'フォローしたユーザーのマイページリンクが表示されている' do
        expect(page).to have_link user.name , href: user_path(user.id)
      end
      it 'フォローされた際の通知の表示が正しい' do
        expect(page).to have_content 'あなたをフォローしました'
      end
      it '全ての通知を削除するリンクがある' do
        expect(page).to have_link '全ての通知を削除'
      end
    end
  end
  
end