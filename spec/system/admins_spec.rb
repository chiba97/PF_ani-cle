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
      it '会員一覧と表示されている' do
        expect(page).to have_content '会員一覧'
      end
      it '会員のIDは表示されている' do
        expect(page).to have_content user.id
      end
      it '会員のニックネームが表示されていてリンク先が正しい' do
        expect(page).to have_link user.name, href: '/admin/users/' + user.id.to_s
      end
      it '会員のメールアドレスは表示されている' do
        expect(page).to have_content user.email
      end
      it '会員のステータスは表示されている' do
        expect(page).to have_content '有効'
      end
    end
  end

  describe '会員詳細のテスト' do
    let!(:user) { create(:user) }
    before do
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      click_link user.name
    end
    context '編集リンクのテスト' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/admin/users/' + user.id.to_s
      end
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq '/admin/users/' + user.id.to_s + '/edit'
      end
    end
  end

  describe '会員情報編集のテスト' do
    let!(:user) { create(:user) }
    before do
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      visit edit_admin_user_path(user.id)
    end
    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/users/' + user.id.to_s + '/edit'
      end
      it '会員情報の編集と表示されている' do
        expect(page).to have_content '会員情報の編集'
      end
      it 'アイコン編集フォームが表示されている' do
        expect(page).to have_field 'user[profile_image]'
      end
      it 'ニックネーム編集フォームが表示されている' do
        expect(page).to have_field 'user[name]'
      end
      it 'メールアドレス編集フォームが表示されている' do
        expect(page).to have_field 'user[email]'
      end
      it '飼っているペットの編集フォームが表示されている' do
        expect(page).to have_field 'user[pet]'
      end
      it '自己紹介の編集フォームが表示されている' do
        expect(page).to have_field 'user[introduction]'
      end
      it '退会ステータス編集ラジオボタンが表示されている' do
        expect(page).to have_field 'user[is_deleted]'
      end
      it '編集内容を保存するバタンが表示されている' do
        expect(page).to have_button '保存'
      end
      it '会員詳細に戻るリンクが表示されている' do
        expect(page).to have_link '戻る', href: admin_user_path(user.id)
      end
    end
    context '編集成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_introduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 20)
        click_button '保存'
      end
      it 'ユーザーのニックネームが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'ユーザーの自己紹介が正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_introduction
      end
      it 'リダイレクト先が情報更新した会員の詳細画面になっている' do
        expect(current_path).to eq '/admin/users/' + user.id.to_s
        expect(page).to have_content '会員情報詳細'
      end
    end
    context '編集の失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[introduction]', with: ''
        click_button '保存'
      end
      it '編集に失敗して、編集ページにリダイレクトする' do
        expect(current_path).to eq '/admin/users/' + user.id.to_s
      end
      it '未入力欄に対して警告が出る' do
        expect(page).to have_content '未入力です'
      end
    end
  end
  
  describe 'お問い合わせ一覧テスト' do
    let!(:user) { create(:user) }
    let!(:contact) { create(:contact, user_id: user.id) }
    before do
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      visit admin_contacts_path
    end
    context '表示の確認' do
      it 'URLは正しい' do
        expect(current_path).to eq '/admin/contacts'
      end
      it '会員のIDは表示されている' do
        expect(page).to have_content user.id
      end
      it '会員のニックネームが表示されている' do
        expect(page).to have_content user.name
      end
      it 'お問い合わせタイトルが表示されている' do
        expect(page).to have_content contact.title
      end
      it '返信リンクが表示されている' do
        expect(page).to have_link '返信'
      end
      it '削除リンクが表示されている' do
        expect(page).to have_link '削除'
      end
    end
  end
  
  describe 'お問い合わせ返信フォームテスト' do
    let!(:user) { create(:user) }
    let!(:contact) { create(:contact, user_id: user.id) }
    before do
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      visit edit_admin_contact_path(user.id)
    end
    context '表示内容の確認' do
      it 'URLは正しい' do
        expect(current_path).to eq '/admin/contacts/' + user.id.to_s + '/edit'
      end
      it 'お問合せタイトルが表示されている' do
        expect(page).to have_content contact.title
      end
      it 'お問い合わせ内容が表示されている' do
        expect(page).to have_content contact.body
      end
      it '返信フォームが表示されている' do
        expect(page).to have_field 'contact[reply]'
      end
      it 'お問い合わせ返信リンクが表示されている' do
        expect(page).to have_button '返信'
      end
      it 'お問い合わせ一覧に戻るリンクが表示されている' do
        expect(page).to have_link '戻る'
      end
    end
    context '返信内容送信の成功テスト' do
      before do
        @contact_old_reply = contact.reply
        fill_in 'contact[reply]', with: Faker::Lorem.characters(number: 5)
        click_button '返信'
      end
      it '送信が成功している(返信内容の更新が成功している)' do
        expect(contact.reload.reply).not_to eq @contact_old_reply
      end
      it 'リダイレクト先がお問い合わせ一覧ページ' do
        expect(current_path).to eq '/admin/contacts'
      end
    end
  end
  
end