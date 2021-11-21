# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user_id: user.id) }
  let!(:other_post) { create(:post, user_id: other_user.id) }
  
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
  
  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end
    
    context '表示内容の確認' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人のリンク先が正しいか' do
        expect(page).to have_link '', href: user_path(post.user.id)
        expect(page).to have_link '', href: user_path(other_post.user.id)
      end
      it '自分と他人の投稿の詳細ページへのリンク先が正しい' do
        expect(page).to have_link '', href: post_path(post.id)
        expect(page).to have_link '', href: post_path(other_post.id)
      end
      it '自分と他人の投稿の内容が表示されている' do
        expect(page).to have_content post.pet
        expect(page).to have_content other_post.pet
      end
      it '自分と他人のプロフィール画像が表示されている' do
        expect(page).to have_content user.profile_image_id
        expect(page).to have_content other_user.profile_image_id
      end
    end
  end
  
  describe '投稿画面のテスト' do
    before do 
      visit new_post_path
      attach_file 'post[post_image]', "#{Rails.root}/app/assets/images/no_image.jpg"
      fill_in 'post[pet]', with: Faker::Lorem.characters(number: 10)
      fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
    end
    
    it '自分の新しい投稿が保存されるか' do
      expect { click_button '投稿する' }.to change(user.posts, :count).by(1)
    end
    it '投稿した際のリダイレクト先が投稿詳細画面になっているか' do
      click_button '投稿する'
      expect(current_path).to eq '/posts/' + Post.last.id.to_s
    end
  end
  
  describe '投稿詳細画面のテスト' do
    before do
      visit post_path(post.id)
    end
    
    context '表示内容の確認' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '投稿内容の詳細と表示されているか' do
        expect(page).to have_content '投稿内容の詳細'
      end
      it 'ユーザーの詳細画面のリンクが正しいか' do
        expect(page).to have_link '', href: user_path(user.id)
      end
      it '投稿者(自分)の名前が表示されているか' do
        expect(page).to have_content 'あなた'
      end
      it '投稿画像のペット名が表示されているか' do
        expect(page).to have_content post.pet
      end
      it '投稿内容が表示されているか' do
        expect(page).to have_content post.body
      end
      it '投稿の編集リンクが表示されているか' do
        expect(page).to have_link '削除', href: post_path(post.id)
      end
      it '投稿の削除リンクが表示されているか' do
        expect(page).to have_link '編集', href: edit_post_path(post.id)
      end
      it 'お気に入り登録リンクが表示されている' do
        expect(page).to have_link 'お気に入り登録', href: post_favorites_path(post.id)
      end
      it 'コメント入力フォームが表示されている' do
        expect(page).to have_field 'comment[comment]'
      end
      it 'コメント入力フォームに値が入っていない' do
        expect(find_field('comment[comment]').text).to be_blank
      end
      it 'コメント送信ボタンが表示されている' do
        expect(page).to have_button 'コメント送信'
      end
    end
    
    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end
    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end
      
      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it '削除後の遷移先が投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end
  end
  
  describe '投稿編集画面のテスト' do
    before do
      visit edit_post_path(post.id)
    end
    
    context '表示の確認' do
      it 'URLが正しいか' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it '投稿内容の編集と表示されているか' do
        expect(page).to have_content '投稿内容の編集'
      end
      it 'ペットの写真編集フォームが表示されているか' do
        expect(page).to have_field 'post[post_image]'
      end
      it 'ペットの種類編集フォームが表示される' do
        expect(page).to have_field 'post[pet]'
      end
      it '投稿内容編集フォームが表示されている' do
        expect(page).to have_field 'post[body]'
      end
      it '編集内容保存リンクが表示されている' do
        expect(page).to have_button '保存'
      end
      it '投稿詳細ページに戻るリンクが表示されている' do
        expect(page).to have_link '戻る'
      end
    end
    
    context '編集成功のテスト' do
      before do
        @post_old_pet = post.pet
        @post_old_body = post.body
        fill_in 'post[pet]', with: Faker::Lorem.characters(number: 5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 10)
        click_button '保存'
      end
      
      it 'ペットの種類が正しく更新される' do
        expect(post.reload.pet).not_to eq @post_old_pet
      end
      it '投稿内容が正しく更新される' do
        expect(post.reload.pet).not_to eq @post_old_body
      end
      it 'リダイレクト先が更新した記事の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
        expect(page).to have_content '投稿内容の詳細'
      end
    end
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
      it 'マイページの編集と表示されているか' do
        expect(page).to have_content 'マイページの編集'
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
  end
end