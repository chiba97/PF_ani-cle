# frozen_string_literal: true

require 'rails_helper'

describe 'Userテスト' do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe "ユーザー詳細画面のテスト" do
    before do
      visit user_path(user.id)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '自分のプロフィール画像が表示されている' do
        expect(page).to have_content user.profile_image_id
      end
      it '自分のニックネームが表示されている' do
        expect(page).to have_content user.name
      end
      it '飼っているペットが表示されている' do
        expect(page).to have_content user.pet
      end
      it '自分の自己紹介が表示されている' do
        expect(page).to have_content user.introduction
      end
      it 'フォロー一覧リンクが表示されている' do
        expect(page).to have_link 'フォロー', href: follows_user_path(user.id)
      end
      it 'フォロワー一覧リンクが表示されている' do
        expect(page).to have_link 'フォロワー', href: followers_user_path(user.id)
      end
      it 'お気に入り登録一覧リンクが表示されている' do
        expect(page).to have_link 'お気に入り', href: favorites_user_path(user.id)
      end
      it 'マイページ編集リンクが表示されている' do
        expect(page).to have_link '編集', href: edit_user_path(user.id)
      end
    end
  end

  describe 'マイページ編集画面のテスト' do
    before do
      visit edit_user_path(user.id)
    end

    context '表示の確認' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it 'マイページ編集と表示されているか' do
        expect(page).to have_content 'マイページ編集'
      end
      it 'プロフィール写真編集フォームが表示されているか' do
        expect(page).to have_field 'user[profile_image]'
      end
      it 'ニックネーム編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '飼っているペット編集フォームが表示されている' do
        expect(page).to have_field 'user[pet]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it '編集内容保存リンクが表示されている' do
        expect(page).to have_button '保存'
      end
      it '投稿詳細ページに戻るリンクが表示されている' do
        expect(page).to have_link '戻る'
      end
      it '退会リンクが表示されている' do
        expect(page).to have_link '退会する'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_introduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 10)
        click_button '保存'
      end

      it 'namaが正しく保存される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく保存される' do
        expect(user.reload.name).not_to eq @user_old_introduction
      end
      it 'リダイレクト先が自分のマイページになっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    describe '退会画面のテスト' do
      before do
        visit unsubscribe_user_path(user.id)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + user.id.to_s + '/unsubscribe'
        end
        it '退会するリンクが表示されている' do
          expect(page).to have_link '退会する'
        end
        it '退会するリンクを押すと退会できる' do
          click_link '退会する'
          expect(user.reload.is_deleted).to eq true
        end
        it 'マイページへ戻るリンクが表示されていて、遷移先が正しい' do
          expect(page).to have_link '戻る', href: user_path(user.id)
        end
      end
    end
  end
end
