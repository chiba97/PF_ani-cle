# frozen_string_literal: true

require 'rails_helper'

describe 'お問い合わせ機能のテスト' do
  
  let(:user) { create(:user) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  
  describe 'お問い合わせフォームのテスト' do
    before do
      visit new_contact_path
    end
    context '表示の確認' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/contacts/new'
      end
      it 'お問い合わせフォームと表示されている' do
        expect(page).to have_content 'お問い合わせフォーム'
      end
      it 'タイトル入力欄が表示されている' do
        expect(page).to have_field 'contact[title]'
      end
      it 'お問い合わせ内容入力が表示されている' do
        expect(page).to have_field 'contact[body]'
      end
      it 'お問い合わせ送信ボタンが表示されている' do
        expect(page).to have_button '送信'
      end
    end
    context 'お問い合わせ投稿成功のテスト' do
      before do
        fill_in 'contact[title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'contact[body]', with: Faker::Lorem.characters(number: 30)
      end
      it 'お問い合わせ内容が投稿される' do
         expect { click_button '送信' }.to change(user.contacts, :count).by(1)
      end
      it 'お問い合わせを送信した際のリダイレクト先が正しい' do
        click_button '送信'
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
    context 'お問い合わせ投稿失敗のテスト' do
      it 'お問い合わせの投稿に失敗する' do
        fill_in 'contact[title]', with: ''
        fill_in 'contact[body]', with: ''
        click_button '送信'
        expect(page).to have_content '未入力です'
      end
    end
  end
  
end