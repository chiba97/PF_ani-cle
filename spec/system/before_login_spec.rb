# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/'
      end
      it '新規会員登録リンクが表示されている' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(sign_up_link).to match(/新規会員登録/)
      end
      it '新規会員登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
      it 'ログインリンクが表示されている' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(log_in_link).to match(/ログイン/)
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it 'ゲストログインリンクが表示されているか' do
        gest_log_in_link = find_all('a')[5].native.inner_text
        expect(gest_log_in_link).to match(/ゲストログイン（閲覧用）/)
      end
      it 'ゲストログインリンクの内容が正しい' do
        gest_log_in_link = find_all('a')[5].native.inner_text
        expect(page).to have_link gest_log_in_link, href: user_guest_sign_in_path
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit about_path
    end
    context '表示内容の確認' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/about'
      end
      it '新規会員登録リンクが表示されている' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(sign_up_link).to match(/新規会員登録/)
      end
      it '新規会員登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
      it 'ログインリンクが表示されている' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(log_in_link).to match(/ログイン/)
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it 'ゲストログインリンクが表示されているか' do
        gest_log_in_link = find_all('a')[5].native.inner_text
        expect(gest_log_in_link).to match(/ゲストログイン（閲覧用）/)
      end
      it 'ゲストログインリンクの内容が正しい' do
        gest_log_in_link = find_all('a')[5].native.inner_text
        expect(page).to have_link gest_log_in_link, href: user_guest_sign_in_path
      end
    end
  end

  describe 'ヘッダーのテスト(ログインしていない場合)' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'アイコンリンクの内容が正しい:左から一番目の画像アイコン' do
        home_link = find_all('a')[0].native.inner_text
        expect(page).to have_link home_link, href: root_path
      end
      it 'Aboutリンクが表示されている：左から二番目のリンク' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match(/About ANI-CLE/)
      end
      it '投稿一覧リンクが表示されている：左から三番目のリンク' do
        post_index_link = find_all('a')[2].native.inner_text
        expect(post_index_link).to match(/投稿一覧/)
      end
    end
    context 'リンクの内容を確認' do
      subject { current_path }

      it 'アイコンリンクを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[0].native.inner_text
        click_link home_link
        is_expected.to eq '/'
      end
      it 'Aboutリンクを押すと、アバウト画面に遷移する' do
        click_on 'About ANI-CLE'
        is_expected.to eq '/about'
      end
      it '投稿一覧リンクを押すと、投稿一覧画面の遷移する' do
        click_on '投稿一覧'
        is_expected.to eq '/posts'
      end
    end
  end
  
  describe 'ユーザー新規登録のテスト' do
    
  end
end