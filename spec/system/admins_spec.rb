# frozen_string_literal: true

require 'rails_helper'

describe '管理者側テスト' do
  let(:admin) { create(:admin) }
  before do
    visit new_admin_session_path
  end
  
  describe '管理者ログインのテスト' do
    context '表示内容の確認' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/admin/sign_in'
      end
      it '管理者ログインと表示されている' do
        expect(page).to have_content '管理者ログイン'
      end
      it '管理者メールアドレスフォームが表示されている' do
        expect(page).to have_field 'admin[email]'
      end
      it '管理者パスワードフォームが表示されている' do
        expect(page).to have_field 'admin[password]'
      end
      it 'ログインボタンが表示されている' do
        expect(page).to have_button 'ログイン'
      end
    end
    context 'ログイン成功のテスト' do
      before do
        fill_in 'admin[email]', with: admin.email
        fill_in 'admin[password]', with: admin.password
        click_button 'ログイン'
      end
      it 'ログイン後のリダイレクト先が会員一覧になっている' do
        expect(current_path).to eq '/admin/users'
      end
    end
    context 'ログイン失敗のテスト' do
      before do
        fill_in 'admin[email]', with: ''
        fill_in 'admin[password]', with: ''
        click_button 'ログイン'
      end
      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/admin/sign_in'
      end
    end
  end
  
  describe 'ヘッダーのテスト：ログインしている場合' do
    before do
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
    end
    context 'ヘッダーの表示の確認' do
      it '会員一覧リンクが表示される：左側から一番目のリンク' do
        admin_index_link = find_all('a')[1].native.inner_text
        expect(admin_index_link).to match(/会員一覧/)
      end
      it 'お問い合わせ一覧リンクが表示される：左側側から二番目のリンク' do
        admin_contact_link = find_all('a')[2].native.inner_text
        expect(admin_contact_link).to match(/お問い合わせ一覧/)
      end
      it 'ログアウトリンクが表示される：左側から三番目のリンク' do
        admin_sign_out_link = find_all('a')[3].native.inner_text
        expect(admin_sign_out_link).to match(/ログアウト/)
      end
    end
  end
  
  describe '管理者ログアウトのテスト' do
    before do
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      click_link 'ログアウト'
    end
    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている：ログアウト後のリダイレクト先においてAboutリンクが存在する' do
        expect(page).to have_link '', href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、ログイン画面になっている' do
        expect(current_path).to eq '/admin/sign_in'
      end
    end
  end
  
  describe '会員一覧のテスト' do
    let!(:user) { create(:user) }
    before do
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
    end
    context '会員一覧ページ表示の確認' do
      it 'URLは正しいか' do
        expect(current_path).to eq '/admin/users'
      end
      it '会員一覧と表示されているか' do
        expect(page).to have_content '会員一覧'
      end
      it '会員のIDは表示されている' do
        expect(page).to have_content user.id
      end
      it '会員のニックネームが表示されていてリンク先が正しい' do
        expect(page).to have_link user.name, href: '/admin/' + 'users/' + user.id.to_s
      end
      it '会員のメールアドレスは表示されているか' do
        expect(page).to have_content user.email
      end
      it '会員のステータスは表示されているか' do
        expect(page).to have_content '有効'
      end
    end
  end
end