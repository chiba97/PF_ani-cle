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
    before do 
      visit new_user_registration_path
    end
    
    context '表示内容の確認' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '新規会員登録と表示される' do
        expect(page).to have_content '新規会員登録'
      end
      it 'ニックネームフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'パスワード確認フォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
      it 'ログイン画面遷移リンクが表示されているか' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(log_in_link).to match(/こちら/)
      end
      it 'ログイン画面遷移リンクの中身が正しいか' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it 'ゲストログイン画面遷移リンクが表示されているか' do
        gest_log_in_link = find_all('a')[4].native.inner_text
        expect(gest_log_in_link).to match(/こちら/)
      end
      it 'ゲストログイン画面遷移リンクの中身が正しいか' do
        guest_log_in_link = find_all('a')[4].native.inner_text
        expect(page).to have_link guest_log_in_link, href: user_guest_sign_in_path
      end
    end
    
    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
      
      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録されたユーザーの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end
  
  describe 'ユーザログインのテスト' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
    end
    
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'ログインと表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'ニックネームフォームは表示されない' do
        expect(page).not_to have_field 'user[name]'
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end
    
    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end
      
      it 'ログイン後のリダイレクト先がトップページになっている' do
        expect(current_path).to eq '/'
      end
    end
    
    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end
      
      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
  
  describe 'ヘッダーのテスト：ログインしている場合' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end
    
    context 'ヘッダーの表示の確認' do
      it 'マイページリンクが表示される：左側から一番目のリンク' do
        mypage_link = find_all('a')[1].native.inner_text
        expect(mypage_link).to match(/マイページ/)
      end
      it '新規投稿リンクが表示される：左側から二番目のリンク' do
        newpost_link = find_all('a')[2].native.inner_text
        expect(newpost_link).to match(/新規投稿/)
      end
      it '投稿一覧リンクが表示される：左側から三番目のリンク' do
        indexpost_link = find_all('a')[3].native.inner_text
        expect(indexpost_link).to match(/投稿一覧/)
      end
      it '通知リンクが表示される：左から四番目のリンク' do
        notification_link = find_all('a')[4].native.inner_text
        expect(notification_link).to match(/通知/)
      end
      it 'お問い合わせリンクが表示される：左から五番目のリンク' do
        contact_link = find_all('a')[5].native.inner_text
        expect(contact_link).to match(/お問い合わせ/)
      end
      it 'ログアウトリンクが表示される：左から五番目のリンク' do
        sign_out_link = find_all('a')[6].native.inner_text
        expect(sign_out_link).to match(/ログアウト/)
      end
    end
  end
  
  describe 'ユーザーログアウトのテスト' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      click_link 'ログアウト'
    end
    
    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている：ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、トップ画面になっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end