# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーログイン後のテスト' do
  
  let(:user) { create(:user) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  
  describe 'ヘッダーのテスト：ログインしている場合' do
    context 'リンクの内容確認' do
      subject { current_path }
      it 'アイコンリンクを押すとトップ画面に遷移する' do
        icon_link = find_all('a')[0].native.inner_text
        click_link icon_link
        is_expected.to eq '/'
      end
      it 'マイページリンクを押すとマイページに遷移する' do
        click_link 'マイページ'
        is_expected.to eq '/users/' + user.id.to_s
      end
      it '新規投稿リンクを押すと新規投稿画面に遷移する' do
        click_link '新規投稿'
        is_expected.to eq '/posts/new'
      end
      it '投稿一覧リンクを押すと投稿一覧画面い遷移する' do
        click_link '投稿一覧'
        is_expected.to eq '/posts'
      end
      it '通知リンクを押すと通知一覧画面に遷移する' do
        click_link '通知'
        is_expected.to eq '/notifications'
      end
      it 'お問い合わせリンクを押すとお問い合わせページに遷移する' do
        click_link 'お問い合わせ'
        is_expected.to eq '/contacts/new'
      end
      it 'ログアウトリンクを押すとログアウトする' do
        click_link 'ログアウト'
        is_expected.to eq '/'
      end
    end
  end
  
end